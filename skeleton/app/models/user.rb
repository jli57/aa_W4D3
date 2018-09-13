# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  
  validates :user_name, presence: true, uniqueness: true 
  validates :session_token, presence: true, uniqueness: true 
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  
  attr_reader :password
  
  after_initialize :ensure_session_token
  
  has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat
    
  has_many :rental_requests,
    foreign_key: :user_id,
    class_name: :CatRentalRequest    
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if user && user.is_password?(password)
  end
  
  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end
  
  def password=(pw)
    @password = pw 
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
  
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end
  
  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end
  
end
