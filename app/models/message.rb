class Message < ApplicationRecord
  # RELATIONS #
  belongs_to :chat

  # VALIDATIONS #
  validates_presence_of :message_number
  validates_uniqueness_of :message_number, scope: :chat

  def as_json(options = {}) 
    super(except: %i[id chat_id created_at updated_at]) 
  end

end
