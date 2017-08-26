class Nis::Fee
  class Multisig
    def initialize(transaction)
      @transaction = transaction
    end

    # @return [Integer] fee in micro XEM
    def value
      testnet? ? 0.15 * 1_000_000 : 6_000_000
    end

    # @return [Integer] fee in micro XEM
    def to_i
      value.to_i
    end

    # @return [Boolean]
    def testnet?
      @transaction.network == :testnet
    end
  end
end