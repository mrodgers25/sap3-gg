class OutboundClicksController < ApplicationController
  
  def show
    decoded_url = URI.decode(params[:url])
    my_user_id = current_user ? current_user.id : nil
    OutboundClick.create(user_id: my_user_id, url: decoded_url)
    redirect_to params[:url]
  end
  
end
