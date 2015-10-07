module Sunspot
  class NullResult
    class GroupedCollection

      include Enumerable

      attr_reader :collection, :group_by, :current_page, :total_pages

      def initialize(collection:, group_by: nil, current_page: 1, total_pages: 1)
        @collection = group_by.nil? ? [] : Array(collection)
        @group_by = group_by || :itself
        @current_page = current_page
        @total_pages = total_pages
      end

      def to_a
        grouped = collection.group_by(&group_by)

        grouped.keys.map do |group_key|
          Group.new(group_key, grouped[group_key])
        end
      end

      def empty?
        to_a.empty?
      end

      def each(*args, &block)
        to_a.each(*args, &block)
      end

      def next_page
        [current_page + 1, total_pages].min
      end

      def prev_page
        [current_page - 1, 0].max
      end

    end
  end
end
