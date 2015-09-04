module Sunspot
  class NullResult
    class GroupedCollection < SimpleDelegator
      attr_reader :collection, :group_by

      def initialize(collection, group_by = nil)
        @collection = group_by.nil? ? [] : collection
        super(@collection)
        @group_by = group_by
      end

      def to_a
        collection.group_by(&group_by).values
      end


    end
  end
end
