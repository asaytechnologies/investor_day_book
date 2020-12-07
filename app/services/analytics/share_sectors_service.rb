# frozen_string_literal: true

module Analytics
  class ShareSectorsService
    prepend BasicService

    EXCHANGE_RATES = { RUB: 1, USD: 74.25, EUR: 90.26 }.freeze

    def initialize; end

    def call(stats:)
      initialize_variables
      collect_absolute_values(stats)
      count_relative_values
      sort_result
    end

    private

    def initialize_variables
      @result = {}
      @total_amount_cents = 0
    end

    def collect_absolute_values(stats)
      stats.each do |quote, stats|
        sector = quote.security.sector
        next unless sector

        cents_amount = cents_amount(quote, stats)
        sector_name  = sector_name(sector)

        update_total_cents_counter(cents_amount)
        next update_sector(sector_name, cents_amount) if @result.has_key?(sector_name)

        add_sector(sector_name, sector.color, cents_amount)
      end
    end

    def count_relative_values
      @result.each do |_key, value|
        value[:amount] = (100.0 * value[:amount] / @total_amount_cents).round(2)
      end
    end

    def sort_result
      @result = @result.sort_by { |_key, value| -value[:amount] }.to_h
    end

    def update_total_cents_counter(cents_amount)
      @total_amount_cents += cents_amount
    end

    def add_sector(sector_name, sector_color, cents_amount)
      @result[sector_name] = { color: sector_color, amount: cents_amount }
    end

    def update_sector(sector_name, cents_amount)
      @result[sector_name][:amount] += cents_amount
    end

    def sector_name(sector)
      sector.name[I18n.locale.to_s]
    end

    def cents_amount(quote, stats)
      stats[:selling_total_cents] * EXCHANGE_RATES[quote.price_currency.to_sym]
    end
  end
end
