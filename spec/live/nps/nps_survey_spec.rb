require 'core/spec_helper'

describe ZendeskAPI::Nps::Survey do
  it_should_be_readable :surveys

  describe ".list" do
    let(:results) { ZendeskAPI::Nps::Survey.list(client) }

    around do |example|
      # 1 request every 5 minutes allowed <-> you can only test 1 call ...
      VCR.use_cassette("surveys_list") do
        client.config.retry = false

        example.call

        client.config.retry = true
      end
    end

    it "finds nps_surveys" do
      expect(results.to_a.first).to be_an_instance_of ZendeskAPI::Nps::Survey
    end

    it "is able to do next" do
      first = results.to_a.first
      stub_json_request(:get, %r{/api/v2/nps/surveys}, json(:results => []))

      results.next
      expect(results.first).to_not eq(first)
    end
  end
end
