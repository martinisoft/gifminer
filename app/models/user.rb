# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:tumblr, :google_oauth2, :facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid

  has_many :sites

  def self.find_by_auth(auth, signed_in_resource=nil)
    if signed_in_resource.nil?
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        user = User.create(
          provider: auth.provider,
          uid:      auth.uid,
          email:    auth.info.email || "#{auth.info.name}@example.com", # tumblr doesn't provide the email, maybe one day it will
          password: Devise.friendly_token[0,20]
        )
        Rails.logger.error user.errors.full_messages.to_sentence unless user.errors.empty?
      end
      user
    else
      signed_in_resource.update_attributes(provider: auth.provider, uid: auth.uid) if signed_in_resource.provider.blank?
      signed_in_resource
    end
  end

end
