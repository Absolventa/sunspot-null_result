require "sunspot/null_result/version"

module Sunspot
  class NullResult
    attr_reader :collection, :options, :group_by

    def initialize(*collection, group_by: nil, **options)
      @collection = collection.flatten
      @group_by   = group_by
      @options    = options
    end

    # Implements the interface of
    # https://github.com/sunspot/sunspot/blob/master/sunspot_rails/lib/sunspot/rails/stub_session_proxy.rb
    class PaginatedNullArray < Array
      attr_reader :current_page, :per_page

      def initialize(collection, current_page: 1, per_page: 1)
        super(collection)
        @current_page = current_page
        @per_page     = per_page
      end

      alias total_count size
      alias limit_value per_page

      def total_pages
        [(size/per_page.to_f).ceil, 1].max
      end
      alias num_pages total_pages


      def previous_page
        (current_page-1) if current_page > 1
      end

      def next_page
        (current_page+1) if total_pages > current_page
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

    def groups
      []
    end

  end
end
