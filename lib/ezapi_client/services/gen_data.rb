module EZAPIClient
  class GenData
    ALLOWED_CHARACTERS = '[^\w\s-]'

    include Virtus.model
    attribute :username, String
    attribute :password, String
    attribute :prv_path, String
    attribute :eks_path, String
    attribute :reference_no, String
    attribute :message, Hash
    attribute :json, String, lazy: true, default: :default_json
    attribute :command, String, lazy: true, default: :default_command
    attribute :logger, Object
    attribute :log, Boolean

    def self.call(attributes)
      self.new(attributes).()
    end

    def call
      if log
        logger.info(EZAPIClient::LOG_PROGNAME) { command }
        ExecCommand.(command, logger)
      else
        ExecCommand.(command)
      end
    end

    private

    def default_command
      [
        "java -cp",
        JAR_PATH,
        "ezpadala.EZdata",
        prv_path,
        eks_path,
        username,
        password,
        reference_no,
        %Q('#{json}'),
      ].join(" ")
    end

    def default_json
      message.each_with_object({}) do |(key, value), hash|
        hash[key.to_s.camelcase(:lower)] = strip_special_characters(value)
      end.to_json
    end

    def strip_special_characters(value)
      return value if !value.is_a?(String)

      value.gsub(Regexp.new(ALLOWED_CHARACTERS), '')
    end

  end
end
