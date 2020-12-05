# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Cache key name for models
  # can be used for Rails.cache.fetch(Model.cache_key(user_id, records, :v1)) { records }
  def self.cache_key(user_id, records, version)
    {
      user_id:     user_id,
      version:     version,
      serializer:  self.table_name,
      stat_record: records.maximum(:updated_at)
    }
  end
end
