require 'spec_helper'

RSpec.describe Sunspot::NullResult::GroupedCollection do

  let(:values) { %w(one two three) }
  let(:collection) { (values*2).map { |value| klass.new(value) }.shuffle }

  describe 'its delegation behavior' do
    subject { described_class.new(collection) }
    it { is_expected.to respond_to(:each); subject.each { |i| } }
  end

  describe '#to_a' do
    subject { described_class.new(collection, attribute).to_a }

    context 'without group_by specified' do
      let(:attribute) {}

      it 'returns empty list' do
        expect(subject).to be_empty
      end
    end

    context 'with group_by specified' do
      let(:attribute) { :foobar }

      it 'groups its collection by given attribute' do
        expect(subject).to be_kind_of Array
        expect(subject).to match_array collection.group_by(&attribute).values
      end

      RSpec::Matchers.define :be_sunspot_group_result_compliant do
        match do |actual|
          @missing_methods = []
          [:solr_docs, :hits, :value].each do |meth|
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
