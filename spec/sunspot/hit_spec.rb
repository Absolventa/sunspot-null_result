require 'spec_helper'

RSpec.describe Sunspot::NullResult::Hit do
  it { expect(subject).to respond_to(:primary_key) }
end
