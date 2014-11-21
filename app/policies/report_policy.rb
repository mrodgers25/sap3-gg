class ReportPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def export_stories_users?
    allowed = ["admin"]
    allowed.include?(@current_user.role)
    # binding.pry
  end

  def export_stories?
    allowed = ["associate","admin"]
    allowed.include?(@current_user.role)
  end

end
