class Chat < ApplicationRecord
  # RELATIONS #
  belongs_to :application
  has_many :messages, dependent: :destroy

  # VALIDATIONS #
  validates_presence_of :chat_number
  validates_uniqueness_of :chat_number, scope: :application
end
