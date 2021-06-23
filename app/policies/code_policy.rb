class CodePolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    allowed = ['admin']
    allowed.include?(@current_user.role)
  end

  def show?
    allowed = ['admin']
    allowed.include?(@current_user.role)
  end

  def create?
    allowed = ['admin']
    allowed.include?(@current_user.role)
  end

  def new?
    allowed = ['admin']
    allowed.include?(@current_user.role)
  end

  def update?
    allowed = ['admin']
    allowed.include?(@current_user.role)
  end

  def edit?
    allowed = ['admin']
    allowed.include?(@current_user.role)
  end

  def destroy?
    allowed = ['admin']
    allowed.include?(@current_user.role)
  end
end
