class Oven < ActiveRecord::Base
  belongs_to :user
  has_many :cookies, as: :storage

  validates :user, presence: true

  def batch_ready?
    !cookies.empty? && !!batch_completed_baking_at
  end

  def in_use?
    !cookies.empty?
  end

  def batch_fillings
    cookies.pluck(:fillings).uniq.join(' ')
  end
end
