require 'spec_helper'

RSpec.describe Sunspot::NullResult::Group do

  let(:collection) { [1, 2].map { |id| klass.new('foo', id) } }

  subject { described_class.new(42, collection) }

  describe '#solr_docs' do
    it 'build solr document list as expected' do
      expect(subject.solr_docs).to eql ['Struct::Monkey 1', 'Struct::Monkey 2']
    end
  end

  describe '#hits' do
    RSpec::Matchers.define :be_sunspot_hit_compliant do
      match do |actual|
        @missing_methods = []
        [:primary_key].each do |meth|
          @missing_methods << meth unless actual.respond_to? meth
        end
        @missing_methods.empty?
      end

      failure_message do |actual|
        "#{actual} does not respond to these methods: #{@missing_methods.inspect}"
      end
    end

    it 'implements sunspot hit interface' do
      subject.hits.each do |item|
        expect(item).to be_sunspot_hit_compliant
      end
    end
  end

  def klass
    @klass ||= Struct.new('Monkey', :foobar, :id)
  end

end
