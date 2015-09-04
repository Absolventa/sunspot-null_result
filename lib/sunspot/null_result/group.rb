module Sunspot
  class NullResult
    class Group < Struct.new(:value, :primary_keys, :collection_item_class_name)

      def solr_docs
        primary_keys.map { |id| "#{collection_item_class_name.to_s} #{id}" }
      end

      def hits
        primary_keys.map { |id| Hit.new(id) }
      end

    end
  end
end
