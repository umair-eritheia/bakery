require 'rails_helper'

RSpec.describe Customer, type: :model do
	let(:customer) { described_class.new }
  it { is_expected.to have_many(:orders) }
end
