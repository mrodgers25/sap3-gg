class SessionsController < ApplicationController
  def toggle_sidebar_state
    session[:sb_closed] = if session[:sb_closed].nil?
                            # If there is no session availabe because it is the first visit and
                            # they click on the icon to open then navbar (it is closed by default),
                            # this returns the correct value of false vs object to the front end.
                            false
                          else
                            !session[:sb_closed]
                          end

    respond_to do |format|
      format.json { render json: { sb_closed: session[:sb_closed] } }
    end
  end
end
