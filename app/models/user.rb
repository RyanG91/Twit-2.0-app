class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :posts
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :set_role

  def set_role
    add_role :author
  end

  def can_create?
    self.has_role?(:admin) || self.has_role?(:author)
  end
  def can_update?(post)
    self.has_role?(:admin) || (self.has_role?(:author) && post.user == self)
  end

  def can_delete?(post)
    self.has_role?(:admin) || self.has_role?(:moderator) || (self.has_role?(:author) && post.user == self)
  end
end
