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
        grouped = collection.group_by(&group_by)

        grouped.keys.map do |group_key|
          Group.new(group_key, grouped[group_key], collection.first.class.to_s)
        end
      end

      def each(*args, &block)
        to_a.each(*args, &block)
      end

    end
  end
end
