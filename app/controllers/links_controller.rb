class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @link = Link.find(params[:id])

    if current_user.author_of?(@link.linkable)
      @link.destroy
      flash[:notice] = 'Link was successfully destroyed'
    else
      flash[:alert] = "You can't destroy another's link!"
    end
  end
end
