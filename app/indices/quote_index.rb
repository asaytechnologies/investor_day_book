# frozen_string_literal: true

ThinkingSphinx::Index.define :quote, with: :real_time do
  # indexes
  indexes figi, type: :string
  indexes security.name_en, type: :string, as: :security_name_en
  indexes security.name_ru, type: :string, as: :security_name_ru
  indexes security.isin, type: :string, as: :security_isin
  indexes security.ticker, type: :string, as: :security_ticker

  # properties
  set_property min_infix_len: 3
end
