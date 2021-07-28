class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    # p "_____record"
    # p record
    # record = target object to be changed
    @record = record
  end

  def index?
    
    p "application_policy"
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
