# frozen_string_literal: true

module YahooFinanceApi
  module Summary
    module AssetProfile
      def asset_profile(ticker:)
        response = connection.get("quoteSummary/#{ticker}?modules=assetProfile")
        response.body
      end
    end
  end
end
