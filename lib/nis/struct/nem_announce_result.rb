class Nis::Struct
  # @attr [String] type
  # @attr [String] code
  # @attr [String] message
  # @attr [String] transactionHash
  # @attr [String] innerTransactionHash
  # @see http://bob.nem.ninja/docs/#nemAnnounceResult
  class NemAnnounceResult
    include Nis::Util::Assignable
    attr_accessor :type, :code, :message, :transactionHash, :innerTransactionHash

    alias :transaction_hash :transactionHash
    alias :inner_transaction_hash :innerTransactionHash

    def self.build(attrs)
      new(attrs)
    end
  end
end
