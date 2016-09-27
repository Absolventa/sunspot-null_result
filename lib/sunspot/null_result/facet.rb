# frozen_string_literal: true
module Sunspot
  class NullResult
    class Facet
      def rows
        []
      end
    end
  end
end
