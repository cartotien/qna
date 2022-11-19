class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    if current_user.author_of?(@attachment.record)
      @attachment.purge
      flash[:notice] = 'Attachment was successfully deleted.'
    else
      flash[:alert] = "You can't delete another's attachement!"
    end
  end
end
