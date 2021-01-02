# frozen_string_literal: true

module Analytics
  class ActivesService
    prepend BasicService

    COLORS = [
      '#2480cc',
      '#f93b4b',
      '#29b327',
      '#00c1ec'
    ].freeze

    def call(args={})
      initialize_variables
      collect_values(args)
      count_relative_values
      sort_result
    end

    private

    def initialize_variables
      @result = {}
      @total_amount_cents = 0
    end

    def collect_values(args)
      args.each.with_index do |(key, value), index|
        add_sector(I18n.t("actives.#{key}"), COLORS[index], value)
        update_total_cents_counter(value)
      end
    end

    def add_sector(sector_name, sector_color, cents_amount)
      @result[sector_name] = { color: sector_color, amount: cents_amount }
    end

    def update_total_cents_counter(cents_amount)
      @total_amount_cents += cents_amount
    end

    def count_relative_values
      @result.each do |_key, value|
        value[:amount] = @total_amount_cents.zero? ? 0 : (100.0 * value[:amount] / @total_amount_cents).round(2)
      end
    end

    def sort_result
      @result = @result.sort_by { |_key, value| -value[:amount] }.to_h
    end
  end
end
