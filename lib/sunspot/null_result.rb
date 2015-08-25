require "sunspot/null_result/version"

module Sunspot
  class NullResult
    attr_reader :collection

    def initialize(collection = [])
      @collection = collection
    end

    class PaginatedNullArray < Array

      def initialize(*items)
        @items = Array(items).flatten
      end

      def total_count
        @items.size
      end

      def current_page
        1
      end

      def total_pages
        1
      end

      def limit_value
        1
      end
    end

    def hits
      PaginatedNullArray.new(collection)
    end

    def results
      PaginatedNullArray.new(collection)
    end

  end
end
