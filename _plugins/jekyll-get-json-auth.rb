# Override jekyll-get-json to add GitHub authentication
require "jekyll"
require 'json'
require 'deep_merge'
require 'net/http'
require 'uri'

module JekyllGetJson
  class GetJsonGenerator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      config = site.config['jekyll_get_json']
      if !config
        return
      end
      if !config.kind_of?(Array)
        config = [config]
      end

      config.each do |d|
        begin
          target = site.data[d['data']]

          # Fetch JSON with authentication support
          uri = URI.parse(d['json'])

          if uri.host == 'api.github.com' && ENV['GITHUB_API_TOKEN']
            # Use authenticated request for GitHub API
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            request = Net::HTTP::Get.new(uri.request_uri)
            request['Authorization'] = "token #{ENV['GITHUB_API_TOKEN']}"
            request['Accept'] = 'application/vnd.github.v3+json'
            response = http.request(request)

            if response.code.to_i >= 400
              Jekyll.logger.warn "GitHub API Error:", "#{response.code} for #{d['json']}"
              next
            end

            source = JSON.parse(response.body)
          else
            # Fallback to original method for non-GitHub URLs
            source = JSON.load(URI.open(d['json']))
          end

          if target
            target.deep_merge(source)
          else
            site.data[d['data']] = source
          end
        rescue => e
          Jekyll.logger.error "Jekyll Get JSON Error:", "Failed to fetch #{d['json']}: #{e.message}"
          next
        end
      end
    end
  end
end
