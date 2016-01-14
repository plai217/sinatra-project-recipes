class User < ActiveRecord::Base
  has_many :recipes
  has_many :ingredients
  has_secure_password

  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(sg)
    self.all.find {|user| sg if sg == user.slug}
  end
end