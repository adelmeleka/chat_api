require 'rails_helper'

RSpec.describe Chat, type: :model do
    ### Association tests ###
    #  Ensure Chat model belongs to one application model
    it { is_expected.to belong_to(:application) }
    #  Ensure Chat model has a 1:m relationship with message model
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    
    ### Validation tests ###
    # Ensure presence of some cols before saving
    it { is_expected.to validate_presence_of(:chat_number) }
end