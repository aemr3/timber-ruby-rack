require "spec_helper"

RSpec.describe Timber::Integrations::Rack::HTTPResponse, :rails_23 => true do
  describe ".initialize" do
    it "should coerce content_length into an integer" do
      event = described_class.new(:content_length => "123", :status => 200, :duration_ms => 1)
      expect(event.content_length).to eq(123)
    end
  end
end
