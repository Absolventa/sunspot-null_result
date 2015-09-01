require "sunspot/null_result/version"

module Sunspot
  class NullResult
    attr_reader :collection, :options

    def initialize(*collection, **options)
      @collection = collection.flatten
      @options    = options
    end

    # Implements the interface of
    # https://github.com/sunspot/sunspot/blob/master/sunspot_rails/lib/sunspot/rails/stub_session_proxy.rb
    class PaginatedNullArray < Array
      attr_reader :current_page

      def initialize(collection, current_page: 1)
        super(collection)
        @current_page = current_page
      end

      alias total_count size

      def total_pages
        1
      end
      alias num_pages total_pages

      def per_page
        1
      end
      alias limit_value per_page

      def previous_page
      end

      def next_page
      end

      def first_page?
        true
      end

      def last_page?
        true
      end

      def out_of_bounds?
        false
      end

      def offset
        0
      end
    end

    def hits
      PaginatedNullArray.new(collection, options)
    end

    def results
      PaginatedNullArray.new(collection, options)
    end

  end
end
