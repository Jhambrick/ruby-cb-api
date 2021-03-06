module Cb
  module Clients
    class Application
      class << self

        def get(criteria)
          response cb_call(:get, criteria)
        end

        def create(criteria)
          response cb_call(:post, criteria)
        end

        def update(criteria)
          response cb_call(:put, criteria)
        end

        def form(job_id)
          url = Cb.configuration.uri_application_form.sub(':did', job_id)
          response_hash = api_client.cb_get(url, headers: headers)
          Responses::ApplicationForm.new(response_hash)
        end

        private

        def cb_call(http_method, criteria)
          options = { headers: headers }
          if [:post, :put].include? http_method
            options[:body] = criteria.to_json
          end

          uri = uri(criteria)
          api_client.method(:"cb_#{http_method}").call uri, options
        end

        def response(response_hash)
          Responses::Application.new response_hash
        end

        def uri(criteria)
          did = criteria.respond_to?(:application_did) ? criteria.application_did : ''
          Cb.configuration.uri_application.sub ':did', did
        end

        def headers
          {
            'DeveloperKey' => Cb.configuration.dev_key,
            'HostSite' => Cb.configuration.host_site,
            'Content-Type' => 'application/json'
          }
        end

        def api_client
          Cb::Utils::Api.instance
        end
      end
    end
  end
end
