require 'spec_helper'

module EZAPIClient
  RSpec.describe BaseResponse, type: %i[virtus] do

    describe "attributes" do
      subject { described_class }
      it { is_expected.to have_attribute(:raw_response) }
      it { is_expected.to have_attribute(:response_body) }
      it { is_expected.to have_attribute(:success) }
      it { is_expected.to have_attribute(:code, String) }
      it { is_expected.to have_attribute(:message, String) }
    end

    describe "#response_body" do
      let(:raw_response) do
        instance_double(HTTParty::Response, body: '{"hi": "there"}')
      end
      let(:response) { described_class.new(raw_response: raw_response) }
      let(:response_body) { response.response_body }

      it "is the hashified body of #raw_response" do
        expect(response_body).to eq("hi" => "there")
        expect(response_body[:hi]).to eq "there"
      end
    end

    describe "#success" do
      let(:response) { described_class.new(response_body: {success: true}) }

      it "defaults to #response_body's success" do
        expect(response.success).to be true
      end
    end

    describe "#code" do
      let(:response) { described_class.new(response_body: {code: "IRP"}) }

      it "defaults to #response_body's code" do
        expect(response.code).to eq "IRP"
      end
    end

    describe "#message" do
      let(:response) do
        described_class.new(response_body: {message: "Missing or invalid..."})
      end

      it "defaults to #response_body's message" do
        expect(response.message).to eq "Missing or invalid..."
      end
    end

  end
end