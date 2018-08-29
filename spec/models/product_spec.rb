require 'rails_helper'

RSpec.describe Product, type: :model do
 	it { is_expected.to have_many(:packs) }
	it { is_expected.to have_many(:order_items) }
	it { is_expected.to validate_presence_of(:name) }
	it { is_expected.to validate_presence_of(:code) }
	it { is_expected.to validate_uniqueness_of(:name) }
	it { is_expected.to validate_uniqueness_of(:code) }
	
end
