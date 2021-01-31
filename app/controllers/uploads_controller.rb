# frozen_string_literal: true

class UploadsController < ApplicationController
  def create
    Uploads::CreateService.call(params: upload_params.merge(user: current_user))
  end

  private

  def upload_params
    params.require(:upload).permit(:name, :guid, :file)
  end
end
