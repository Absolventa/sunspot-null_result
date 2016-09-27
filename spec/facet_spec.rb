require 'spec_helper'

RSpec.describe Sunspot::NullResult::Facet do
  describe '#rows' do
    it 'returns an empty list' do
      expect(subject.rows).to eql []
    end
  end
end
