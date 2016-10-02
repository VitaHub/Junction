module ApplicationHelper

  def resource_name
    # devise_mapping.name
    :user
  end

  alias :scope_name :resource_name

  def resource_class
    devise_mapping.to
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
