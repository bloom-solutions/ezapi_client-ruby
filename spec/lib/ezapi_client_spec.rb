require 'spec_helper'

describe EZAPIClient do

  it 'has a version number' do
    expect(EZAPIClient::VERSION).not_to be nil
  end

  describe ".new" do
    context "with complete credentials" do
      let(:logger) { Logger.new(STDOUT) }

      it "instantiates a Client, passing options" do
        client = described_class.new(
          username: "username",
          password: "password",
          eks_path: CONFIG[:eks_path],
          prv_path: CONFIG[:prv_path],
          host: CONFIG[:host],
          logger: logger,
          log: true,
        )

        expect(client).to be_a EZAPIClient::Client
        expect(client.username).to eq "username"
        expect(client.password).to eq "password"
        expect(client.eks_path).to eq CONFIG[:eks_path]
        expect(client.prv_path).to eq CONFIG[:prv_path]
        expect(client.host).to eq CONFIG[:host]
        expect(client.logger).to eq logger
        expect(client.log).to be true
      end
    end

    context "with incomplete credentials" do
      it "raises an error" do
        expect { described_class.new(username: "username") }.
          to raise_error(ArgumentError)
      end
    end
  end

end
