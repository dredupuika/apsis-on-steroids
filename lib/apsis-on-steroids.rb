require "json"
require "http2"
require "string-cases"
require "timeout"
require "cgi"

class ApsisOnSteroids
  attr_reader :http
  
  def self.const_missing(name)
    require "#{File.dirname(__FILE__)}/../include/#{::StringCases.camel_to_snake(name)}"
    raise "Still not loaded: '#{name}'." unless ApsisOnSteroids.const_defined?(name)
    return ApsisOnSteroids.const_get(name)
  end
  
  def initialize(args)
    raise "Invalid API key: '#{args[:api_key]}' from: '#{args}'." if args[:api_key].to_s.strip.empty?
    
    @args = args
    @http = Http2.new(
      :host => "se.api.anpdm.com",
      :port => 8443,
      :ssl => true,
      :follow_redirects => false,
      :debug => args[:debug],
      :extra_headers => {
        "Accept" => "text/json, application/json"
      },
      :basic_auth => {
        :user => @args[:api_key],
        :passwd => ""
      }
    )
    
    if block_given?
      begin
        yield self
      ensure
        @http.destroy
        @http = nil
      end
    end
  end
  
  # Closes connection and removes all references to resource-objects.
  def destroy
    @http.destroy if @http
    @http = nil
  end
  
  def debugs(str)
    puts str if @args[:debug]
  end
  
  def mailing_lists
    res = req_json("v1/mailinglists/1/999")
    
    ret = []
    res["Result"]["Items"].each do |mlist|
      ret << ApsisOnSteroids::MailingList.new(
        :aos => self,
        :data => mlist
      )
    end
    
    return ret
  end
  
  def create_mailing_list(data)
    res = req_json("v1/mailinglists/", :post, :json => data)
    if res["Code"] == 1
      # Success!
    else
      raise "Unexpected result: '#{res}'."
    end
  end
  
  def mailing_list_by_name(name)
    self.mailing_lists.each do |mlist|
      return mlist if name.to_s == mlist.data(:name).to_s
    end
    
    raise "Could not find mailing list by that name: '#{name}'."
  end
    
  def subscriber_by_email(email)
    begin
      res = req_json("v1/subscribers/email/lookup/#{CGI.escape(email)}")
    rescue
      raise "Could not find subscriber by that email in the system"
    end
  
    sub = ApsisOnSteroids::Subscriber.new(
      :aos => self,
      :data => {
        "Id" => res["Result"],
        "Email" => email
      }
    )
    
    return sub
  end
  
  def req_json(url, type = :get, method_args = {})
    # Parse arguments, send and parse the result.
    args = { :url => url.start_with?('/') ? url[1..-1] : url }.merge(method_args)
    http_res = @http.__send__(type, args)
    
    begin
      res = JSON.parse(http_res.body)
    rescue JSON::ParserError
      raise "Invalid JSON given: '#{http_res.body}'."
    end
    
    # Check for various kind of server errors and raise them as Ruby errors if present.
    raise "Failed on server with code #{res["Code"]}: #{res["Message"]}" if res.is_a?(Hash) && res.key?("Code") && res["Code"] < 0
    raise "Failed on server with state #{res["State"]} and name '#{res["StateName"]}': #{res["Message"]}" if res.is_a?(Hash) && res.key?("State") && res["State"].to_i < 0
    
    # Return the result.
    return res
  end
  
  def read_queued_response(url)
    uri = URI.parse(url)
    
    Timeout.timeout(300) do
      loop do
        sleep 1
        res = req_json(uri.path)
        
        if res["State"] == "2"
          uri_data = URI.parse(res["DataUrl"])
          return req_json(uri_data.path)
        elsif res["State"] == "1" || res["State"] == "0"
          # Keep waiting.
        else
          raise "Unknown state '#{res["State"]}': #{res}"
        end
      end
    end
  end
  
  def parse_obj(obj)
    if obj.is_a?(Array)
      ret = []
      obj.each do |obj_i|
        ret << parse_obj(obj_i)
      end
      
      return ret
    elsif obj.is_a?(Hash)
      ret = {}
      obj.each do |key, val|
        ret[key] = parse_obj(val)
      end
      
      return ret
    elsif obj.is_a?(String)
      # Automatically convert dates.
      if match = obj.match(/^\/Date\((\d+)\+(\d+)\)\//)
        unix_t = match[1].to_i / 1000
        return Time.at(unix_t)
      end
      
      return obj
    else
      return obj
    end
  end
end
