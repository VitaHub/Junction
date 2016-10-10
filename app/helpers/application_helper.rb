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

  def time_for_messages(utc_time)
    local = utc_time.in_time_zone("Kyiv")
    time = Time.zone.now.in_time_zone("Kyiv")
    if local.to_date == time.to_date
      local.strftime("%H:%M")
    else
      local.strftime("%H:%M %d/%m/%Y")
    end
  end
end



