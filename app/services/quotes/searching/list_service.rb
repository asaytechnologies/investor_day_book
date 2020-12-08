# frozen_string_literal: true

module Quotes
  module Searching
    class ListService
      prepend BasicService

      SHORT_NAME_TICKERS = %w[A AA AN AX BA BC BH BK BL BR C CB CE CF CI CL CR CW CY D DD DE DG DK DT DY EA ED EL
                              ES ET EV EW F FB FL GD GE GH GL GM GS GT H HA HD HP IP IR IT J JD K KO KR L LB LH
                              LM LW M MA MD MO MS MU NP O OC OI ON PB PD PG PH PM PS R RE RF RH RL RP RS SF SO
                              SP SQ T TT TW UA UI V VC VG VZ W WB WH WK WM WU WY Y YY Z ZG ZM ZS].freeze

      def call(query: '')
        ticker = SHORT_NAME_TICKERS.find { |e| e == query.upcase }
        return if ticker.nil?

        security_ids = Security.where(ticker: ticker).pluck(:id)
        @result = Quote.where(security_id: security_ids)
      end
    end
  end
end
