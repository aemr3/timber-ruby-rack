require "spec_helper"

RSpec.describe Timber::Util::Request do
  describe ".headers" do
    it "should ignore symbol keys" do
      req = described_class.new({test: "value"})
      expect(req.headers).to eq({})
    end
  end
end
