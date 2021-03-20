# frozen_string_literal: true

describe PortfolioSerializer do
  let!(:portfolio) { create :portfolio }
  let(:serializer) { described_class.new(portfolio).serializable_hash.to_json }

  %w[id name currency broker_name created_at].each do |attr|
    it "serializer contains portfolio #{attr}" do
      expect(serializer).to have_json_path("data/attributes/#{attr}")
    end
  end
end
