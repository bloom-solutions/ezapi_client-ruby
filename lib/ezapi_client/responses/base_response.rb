module EZAPIClient
  class BaseResponse

    include Virtus.model
    attribute :raw_response, Object
    attribute(:response_body, IndifferentHash, {
      lazy: true,
      default: :default_response_body,
    })
    attribute :success, Boolean, lazy: true, default: :default_success
    attribute :code, String, lazy: true, default: :default_code
    attribute :message, String, lazy: true, default: :default_message

    private

    def default_success
      response_body[:success]
    end

    def default_response_body
      JSON.parse(raw_response.body)
    end

    def default_code
      response_body[:code]
    end

    def default_message
      response_body[:message]
    end

  end
end