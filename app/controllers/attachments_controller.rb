class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_attachment

  respond_to :js

  def destroy
    if current_user.author_of?(@attachment.attachable)
      respond_with(@attachment.destroy)
    end
  end

  private

  def get_attachment
    @attachment = Attachment.find(params[:id])
  end
end
