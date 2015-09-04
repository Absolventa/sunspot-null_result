require 'spec_helper'

RSpec.describe Sunspot::NullResult::GroupedCollection do

  let(:values) { %w(one two three) }
  let(:collection) { (values*2).map { |value| klass.new(value) }.shuffle }

  describe 'its constructor' do
    context 'without group_by specified' do
      it 'returns empty list' do
        expect(described_class.new(collection)).to eql([])
      end
    end
  end

  describe '#to_a' do
    context 'with group_by specified' do
      let(:attribute) { :foobar }
      subject { described_class.new(collection, attribute) }

      it 'groups its collection by given attribute' do
        expect(subject.to_a).to be_kind_of Array
        expect(subject.to_a).to match_array collection.group_by(&attribute).values
      end
    end
  end

  def klass
    @klass ||= Struct.new(:foobar)
  end

end
