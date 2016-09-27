# frozen_string_literal: true
module Sunspot
  class NullResult
    class Hit < Struct.new(:primary_key)
    end
  end
end
