module Sunspot
  class NullResult
    class Hit < Struct.new(:primary_key)
    end
  end
end
