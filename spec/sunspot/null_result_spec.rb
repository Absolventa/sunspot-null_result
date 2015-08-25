require 'spec_helper'

RSpec.describe Sunspot::NullResult do
  it 'has a version number' do
    expect(Sunspot::NullResult::VERSION).not_to be nil
  end

  shared_examples_for 'returns a paginated enumerable' do |method|
    subject { described_class.new.send(method) }

    it 'returns a total count of 0' do
      expect(subject.total_count).to eql 0
    end

    it 'returns a total page count of 1' do
      expect(subject.total_pages).to eql 1
    end

    it 'returns the current page as 1' do
      expect(subject.current_page).to eql 1
    end

    it 'returns the limit value as 1' do
      expect(subject.limit_value).to eql 1
    end
  end

  describe '#hits' do
    it_behaves_like 'returns a paginated enumerable', :hits
  end

  describe '#results' do
    it_behaves_like 'returns a paginated enumerable', :results
  end

end
