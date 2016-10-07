class User < ActiveRecord::Base
	GENDER_TYPES = ["Not telling","Male", "Female"]
  validates :gender, inclusion: {in: [1, 2, 3], message: "%{value} is not valid gender" }
  has_attached_file :avatar, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "default_avatar/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates :first_name, :last_name, presence: true
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
    p auth
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource || identity.user
    # Create user if needed
    if user.nil?
      email = auth.info.email
      user = User.where(:email => email).first if email
      # Create user if this is a new record
      if user.nil?
        pass = Devise.friendly_token[0,20]
        gender = auth.extra.raw_info.sex == 1 ? 3 : auth.extra.raw_info.sex == 2 ? 2 : 1
        user = User.new(
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          gender: gender,
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

  def age
    if birth_date
      now = Time.now.utc.to_date
      now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
    else
      nil
    end
  end

  # User search
  scope :by_gender, lambda {|gender| where(:gender => gender)}

  scope :by_name, (lambda do |name|
    search = "%#{name}%".mb_chars.downcase.to_s
    where("LOWER(last_name || ' ' || first_name) LIKE ? or LOWER(first_name || ' ' || last_name) LIKE ?", search, search)    
  end)

  scope :by_min_age, (lambda do |min_age|
    date = Date.today - min_age.to_i.years
    where("birth_date <= ?", date)
  end) 

  scope :by_max_age, (lambda do |min_age|
    date = Date.today - (min_age.to_i + 1).years
    where("birth_date > ?", date)
  end) 

  scope :by_country, lambda {|country| where(:country_id => country)}

  scope :by_state, lambda {|state| where(:state_id => state)}

  scope :by_city, lambda {|city| where(:city_id => city)}

  def gender_txt
  	GENDER_TYPES[self.gender - 1]
  end

end
