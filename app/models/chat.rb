class Chat < ApplicationRecord
  # RELATIONS #
  belongs_to :application
  has_many :messages, dependent: :destroy

  # VALIDATIONS #
  validates_presence_of :chat_number
  validates_uniqueness_of :chat_number, scope: :application

  def as_json(options = {}) 
    super(except: %i[id application_id created_at updated_at]) 
  end
end
