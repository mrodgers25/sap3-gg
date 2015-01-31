class OutboundClicksController < ApplicationController
  
  def show
    my_url = URI.decode(params[:url])
    my_user_id = current_user ? current_user.id : nil
    OutboundClick.create(user_id: my_user_id, url: my_url)
    redirect_to my_url
  end
  
end
