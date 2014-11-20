class StoryPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def scrape?
    allowed = ["associate","admin"]
    allowed.include?(@current_user.role)
    # binding.pry
  end

  def destroy?
    allowed = ["admin"]
    allowed.include?(@current_user.role)
  end

  # def index?
  #   @current_user.admin?
  # end
  #
  # def show?
  #   @current_user.admin? or @current_user == @user
  # end
  #
  # def update?
  #   @current_user.admin?
  # end
  #
  # def destroy?
  #   return false if @current_user == @user
  #   @current_user.admin?
  # end

end
