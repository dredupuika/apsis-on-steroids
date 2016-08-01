class ApsisOnSteroids::Newsletter < ApsisOnSteroids::SubBase
  def links(args = {})
    list_for("newsletters/v1/%{newsletter_id}/links", "Link", args)
  end

  def web_version
    resource_url = "v1/newsletters/%{newsletter_id}/webversion".gsub("%{newsletter_id}", data(:id).to_s)
    results = aos.req_json(resource_url)

    return results["Result"]
  end

  private

  def list_for(resource_url, resource_name, args = {})
    resource_url = resource_url.gsub("%{newsletter_id}", data(:id).to_s)
    results = aos.req_json(resource_url)

    Enumerator.new do |yielder|
      aos.read_resources_from_array(resource_name, results["Result"]["NewsletterLinks"]).each do |resource|
        yielder << resource
      end
    end

  end
end
