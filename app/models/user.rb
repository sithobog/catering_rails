class User < ActiveRecord::Base

  has_many :daily_rations

  scope :with_rations, -> (sprint_id) { find(find_rations(sprint_id)) }
  scope :without_rations, -> (sprint_id) { where.not(id: find_rations(sprint_id)) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def reset_authentication_token
    self.authentication_token = nil
    self.save
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  #find users with rations for specific sprint
  def self.find_rations(sprint_id)
    rations = DailyRation.includes(:user).where(sprint_id: sprint_id)
    users = []
    rations.each do |ration|
      users << ration.user.id
    end
    users = users.uniq
  end


end
