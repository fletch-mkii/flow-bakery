class Cookie < ActiveRecord::Base
  attr_accessor :cookie_batch_size

  belongs_to :storage, polymorphic: :true
  
  validates :storage, presence: true

  before_validation :normalize_blank_fillings

  def ready?
    !!completed_baking_at
  end

  def normalize_blank_fillings
    self.fillings = nil if fillings.blank?
  end
end
