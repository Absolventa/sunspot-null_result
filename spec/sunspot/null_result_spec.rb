require 'spec_helper'

RSpec.describe Sunspot::NullResult do
  it 'has a version number' do
    expect(Sunspot::NullResult::VERSION).not_to be nil
  end

  let(:collection) { [double] }

  describe 'its constructor' do
    it 'does not require an argument' do
      expect(described_class.new).to be_instance_of described_class
    end

    it 'sets the collection' do
      subject = described_class.new collection
      expect(subject.collection).to eql collection
    end

    context 'with grouping' do
      it 'leaves group_by blank' do
        expect(subject.group_by).to be_nil
      end

      it 'sets the group_by' do
        subject = described_class.new collection, group_by: :foobar
        expect(subject.group_by).to eql :foobar
      end
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

  shared_examples_for 'allows injection of pagination options' do |method|
    let(:collection) { 3.times.map { double } }

    context 'setting per_page' do
      let(:per_page) { 2 }
      subject { described_class.new(collection, per_page: per_page).send(method) }
      it { expect(subject.per_page).to eql per_page }

      it { expect(subject.total_pages).to eql 2 }
    end

    context 'setting the current_page' do
      let(:current_page) { 2 }
      subject { described_class.new(collection, current_page: current_page).send(method) }
      it { expect(subject.current_page).to eql current_page }

      it { expect(subject.previous_page).to eql (current_page-1) }
      it { expect(subject.next_page).to eql (current_page+1) }
    end
  end

  describe '#hits' do
    it_behaves_like 'returns a paginated enumerable', :hits
    it_behaves_like 'returns injected results list',  :hits
    it_behaves_like 'allows injection of pagination options', :hits
  end

  describe '#results' do
    it_behaves_like 'returns a paginated enumerable', :results
    it_behaves_like 'returns injected results list',  :results
    it_behaves_like 'allows injection of pagination options', :results
  end

  describe '#groups' do
    it 'returns an empty list' do
      expect(subject.groups).to eql([])
    end

    context 'with an :group_by option' do
      subject { described_class.new(collection, group_by: :itself) }

      it 'still is an array' do
        expect(subject.groups).to be_kind_of Array
      end
    end
  end
end
