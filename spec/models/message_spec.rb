require 'rails_helper'

RSpec.describe Message, type: :model do
    ### Association tests ###
    #  Ensure Application model has one chat model
    it { is_expected.to belong_to(:chat)}
    
    ### Validation tests ###
    # Ensure presence of some cols before saving
    it { is_expected.to validate_presence_of(:message_number) }
    it { is_expected.to validate_presence_of(:message_content) }
end