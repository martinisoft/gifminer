# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  type       :string(255)
#  name       :string(255)
#  url        :string(255)
#  avatar     :string(255)
#  public     :boolean
#  post       :boolean
#  token      :string(255)
#  secret     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Site < ActiveRecord::Base
  attr_accessible :avatar, :name, :post, :public, :secret, :token, :type, :url, :user_id

  belongs_to :user

  validates_uniqueness_of :url, :scope => [:user_id]
end
