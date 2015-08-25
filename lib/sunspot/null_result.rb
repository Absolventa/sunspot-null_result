require "sunspot/null_result/version"

module Sunspot
  class NullResult

    class PaginatedNullArray < Array
      def total_count
        0
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
      PaginatedNullArray.new
    end

    def results
      PaginatedNullArray.new
    end

  end
end
