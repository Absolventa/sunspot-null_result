# frozen_string_literal: true
module Sunspot
  class NullResult
    class Group < Struct.new(:value, :collection)

      def solr_docs
        collection.map { |item| "#{item.class.to_s} #{item.id}" }
      end

      def hits
        collection.map { |item| Hit.new item.id }
      end

    end
  end
end
