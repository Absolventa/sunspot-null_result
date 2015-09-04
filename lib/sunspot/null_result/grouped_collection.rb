module Sunspot
  class NullResult
    class GroupedCollection

      include Enumerable

      attr_reader :collection, :group_by

      def initialize(collection, group_by = nil)
        @collection = group_by.nil? ? [] : Array(collection)
        @group_by = group_by || :itself
      end

      def to_a
        collection.group_by(&group_by).values
      end

      def each(*args, &block)
        to_a.each(*args, &block)
      end

    end
  end
end
