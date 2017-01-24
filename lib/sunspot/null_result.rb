# frozen_string_literal: true
require "sunspot/null_result/version"
require "sunspot/null_result/paginated_null_array"
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
