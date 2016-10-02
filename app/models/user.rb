class User < ActiveRecord::Base
  has_attached_file :avatar, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "default_avatar/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable


  # For devise. 
  def update_without_password(params, *options)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get user, if it already exists
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource || identity.user
    # Create user if needed
    if user.nil?
      email = auth.info.email
      user = User.where(:email => email).first if email
      # Create user if this is a new record
      if user.nil?
        pass = Devise.friendly_token[0,20]
        user = User.new(
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          email: email,
          password: pass,
          password_confirmation: pass
        )
        user.confirmed_at = Time.now
        # user.skip_confirmation!
        user.save!
      end
    end
    # Связать identity с пользователем, если необходимо
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

end
