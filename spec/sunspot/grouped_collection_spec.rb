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
      subject { described_class.new(collection, attribute).to_a }

      it 'groups its collection by given attribute' do
        expect(subject).to be_kind_of Array
        expect(subject).to match_array collection.group_by(&attribute).values
      end

      RSpec::Matchers.define :be_sunspot_group_result_compliant do
        match do |actual|
          @missing_methods = []
          [:solr_docs, :hits].each do |meth|
            @missing_methods << meth unless actual.respond_to? meth
          end
          @missing_methods.empty?
        end

        failure_message do |actual|
          "#{actual} does not respond to these methods: #{@missing_methods.inspect}"
        end
      end

      it 'implements grouped sunspot result interface' do
        subject.each do |item|
          expect(item).to be_sunspot_group_result_compliant
        end
      end
    end
  end

  def klass
    @klass ||= Struct.new(:foobar)
  end

end
