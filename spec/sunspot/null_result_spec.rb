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
      expect(subject.prev_page).to be_nil
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

      it { expect(subject.prev_page).to eql (current_page-1) }
      it { expect(subject.next_page).to eql (current_page+1) }
    end
  end

  shared_examples_for 'detects and honours kaminari-compatible data structures' do |method|
    let(:collection) do
      entries = 3.times.map { double }
      # Mime a collection that has pagination methods mixed in
      Class.new(Array) {
        def initialize(entries)
          super(entries)
        end

        def total_pages
          :total_pages_from_injected_collection
        end
      }.new(entries)
    end

    describe '#total_pages' do
      subject { described_class.new(collection).send(method) }
      it 'returns the total pages from the collection' do
        expect(subject.total_pages).to eql :total_pages_from_injected_collection
      end
    end

  end

  describe '#hits' do
    it_behaves_like 'returns a paginated enumerable', :hits
    it_behaves_like 'returns injected results list',  :hits
    it_behaves_like 'allows injection of pagination options', :hits
    it_behaves_like 'detects and honours kaminari-compatible data structures', :hits
  end

  describe '#results' do
    it_behaves_like 'returns a paginated enumerable', :results
    it_behaves_like 'returns injected results list',  :results
    it_behaves_like 'allows injection of pagination options', :results
    it_behaves_like 'detects and honours kaminari-compatible data structures', :results
  end

  describe '#group' do
    let(:collection) do
      %w(one two).map { |group| Struct.new(:foobar, :id).new(group, '_') }
    end

    subject { described_class.new(collection) }

    it 'sets the group_by' do
      expect { subject.group(:foobar) }.
        to change { subject.group_by }.to :foobar
    end

    it 'returns itself' do
      expect(subject.group(:foobar)).to eql subject
    end

    it 'returns a grouped result' do
      expect(subject.group(:foobar).groups).not_to be_empty
    end
  end

  describe '#groups' do
    it 'returns an empty list' do
      expect(subject.groups).to be_empty
    end

    it 'knows about current_page' do
      expect(subject.groups.current_page).to be_an Integer
    end

    it 'knows about next_page' do
      expect(subject.groups.next_page).to be_an Integer
    end

    it 'knows about prev_page' do
      expect(subject.groups.prev_page).to be_an Integer
    end

    it 'knows about total_pages' do
      expect(subject.groups.total_pages).to be_an Integer
    end

    context 'with an :group_by option' do
      subject { described_class.new(collection) }
      before { subject.group(:itself) }

      it 'still is an array' do
        expect(subject.groups).to be_kind_of Enumerable
      end
    end
  end

  describe '#matches' do
    it 'returns total count of (possibly child) elements' do
      expect(subject.matches).to eql 0
    end
  end

  describe '#facet' do
    it 'returns a Facet instance' do
      expect(subject.facet(:foobar)).to be_instance_of Sunspot::NullResult::Facet
    end
  end

  describe '#total' do
    it { expect(subject.total).to eql 0 }

    context 'with injected results' do
      let(:collection) { 3.times.map { double } }

      subject { described_class.new collection }

      it 'returns the size of the list of results' do
        expect(subject.total).to eql 3
      end
    end
  end
end
