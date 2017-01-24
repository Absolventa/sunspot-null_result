# frozen_string_literal: true
require "sunspot/null_result/version"
require "sunspot/null_result/grouped_collection"
require "sunspot/null_result/group"
require "sunspot/null_result/hit"
require "sunspot/null_result/facet"

module Sunspot
  class NullResult
    attr_reader :collection, :options, :group_by

    def initialize(collection = [], **options)
      @collection = collection
      @options    = options
      @group_by   = nil
    end

    # Implements the interface of
    # https://github.com/sunspot/sunspot/blob/master/sunspot_rails/lib/sunspot/rails/stub_session_proxy.rb
    class PaginatedNullArray < Array
      attr_reader :per_page

      def initialize(collection, current_page: 1, per_page: 1, offset: nil)
        super(collection)
        @current_page = current_page.to_i
        @per_page     = per_page.to_i
        @offset       = offset
        @_collection  = collection
      end

      alias limit_value per_page

      def size
        if @_collection.respond_to?(:total_count)
          @_collection.total_count
        else
          super
        end
      end
      alias total_count size

      def total_pages
        if @_collection.respond_to?(:total_pages)
          @_collection.total_pages
        else
          [(size/per_page.to_f).ceil, 1].max
        end
      end
      alias num_pages total_pages

      def current_page
        if @_collection.respond_to?(:current_page)
          @_collection.current_page
        else
          @current_page
        end
      end

      def prev_page
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
        @offset || 0
      end
    end

    def hits
      PaginatedNullArray.new(collection, options)
    end

    def results
      PaginatedNullArray.new(collection, options)
    end

    def group(group)
      @group_by = group
      self
    end

    def groups
      GroupedCollection.new(collection: collection, group_by: group_by, current_page: results.current_page, total_pages: results.total_pages)
    end

    def matches
      results.size
    end

    def facet(*)
      Sunspot::NullResult::Facet.new
    end

    def total
      collection.size
    end

  end
end
