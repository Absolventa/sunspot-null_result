require 'spec_helper'

RSpec.describe Sunspot::NullResult do
  it 'has a version number' do
    expect(Sunspot::NullResult::VERSION).not_to be nil
  end

  let(:collection) { [double, double] }

  describe 'its constructor' do
    it 'does not require an argument' do
      expect(described_class.new).to be_instance_of described_class
    end

    it 'sets the collection' do
      subject = described_class.new collection
      expect(subject.collection).to eql collection
    end
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

  shared_examples_for 'returns injected results list' do |method|
    subject { described_class.new(collection).send(method) }

    let(:size) { collection.size }

    it 'returns a total amount of collection objects' do
      expect(subject.total_count).to eql size
    end

    it 'returns a total page count of 1' do
      expect(subject.total_pages).to eql 1
    end

    it 'returns a num page count of 1' do
      expect(subject.num_pages).to eql 1
    end

    it 'returns the current page as 1' do
      expect(subject.current_page).to eql 1
    end

    it 'returns the limit value as 1' do
      expect(subject.limit_value).to eql 1
    end

    it 'returns the per_page value as 1' do
      expect(subject.per_page).to eql 1
    end

    it 'yields each item in the collection' do
      expect { |b| subject.each(&b) }.to \
        yield_successive_args(*collection)
    end

    it { is_expected.to be_first_page }
    it { is_expected.to be_last_page }
    it { is_expected.not_to be_out_of_bounds }

    it 'has an offset value of 0' do
      expect(subject.offset).to eql 0
    end

    it 'has no previous page' do
      expect(subject.previous_page).to be_nil
    end

    it 'has no next page' do
      expect(subject.next_page).to be_nil
    end

  end

  describe '#hits' do
    it_behaves_like 'returns a paginated enumerable', :hits
    it_behaves_like 'returns injected results list',  :hits
  end

  describe '#results' do
    it_behaves_like 'returns a paginated enumerable', :results
    it_behaves_like 'returns injected results list',  :results
  end

end
