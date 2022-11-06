require 'rails_helper'

RSpec.describe Application, type: :model do
    ### Association tests ###
    #  Ensure Application model has a 1:m relationship with the chat model
    it { is_expected.to have_many(:chats).dependent(:destroy) }
    
    ### Validation tests ###
    # Ensure presence of some cols before saving
    it { is_expected.to validate_presence_of(:application_token) }
    it { is_expected.to validate_presence_of(:name) }
end