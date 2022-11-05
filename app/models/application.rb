class Application < ApplicationRecord
  # RELATIONS #
  has_many :chats, dependent: :destroy

  # VALIDATIONS #
  validates :application_token, presence: true, uniqueness: { case_sensitive: false }
  validates :name, uniqueness:true, presence: true, allow_blank: false

  def as_json(options = {}) 
    super(except: %i[id created_at updated_at]) 
  end

end
