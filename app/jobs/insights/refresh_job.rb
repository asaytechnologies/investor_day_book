# frozen_string_literal: true

module Insights
  class RefreshJob < ApplicationJob
    queue_as :default

    def perform(parentable_id:, parentable_type:, insightable_id:, insightable_type:, plan:)
      parentable  = parentable_type.constantize.find(parentable_id)
      insightable = insightable_type.constantize.find(insightable_id)

      Insights::RefreshService.call(parentable: parentable, insightable: insightable, plan: plan)
    end
  end
end
