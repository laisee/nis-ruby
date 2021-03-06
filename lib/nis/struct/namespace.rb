class Nis::Struct
  # @attr [String] fqn
  # @attr [String] owner
  # @attr [Integer] height
  # @see https://nemproject.github.io/#namespace
  class Namespace
    include Nis::Util::Assignable
    attr_accessor :fqn, :owner, :height

    def self.build(attrs)
      new(attrs)
    end
  end
end
