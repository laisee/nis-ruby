class Nis::Transaction
  # @attr [Integer] timestamp
  # @attr [Integer] amount
  # @attr [Integer] fee
  # @attr [String]  recipient
  # @attr [Integer] type
  # @attr [Integer] deadline
  # @attr [Nis::Struct::Message] message
  # @attr [Integer] version
  # @attr [String]  signer
  # @attr [Array <Nis::Struct::MosaicId>] mosaics
  # @see http://bob.nem.ninja/docs/#transferTransaction
  # @see http://bob.nem.ninja/docs/#initiating-a-transfer-transaction
  # @see http://bob.nem.ninja/docs/#version-1-transfer-transactions
  # @see http://bob.nem.ninja/docs/#version-2-transfer-transactions
  class Transfer
    include Nis::Mixin::Network
    attr_writer :version, :fee

    include Nis::Util::Assignable
    attr_accessor :timeStamp, :amount, :recipient, :type, :deadline, :message, :signer,
                  :mosaics

    alias :timestamp :timeStamp
    alias :timestamp= :timeStamp=

    TYPE = 0x0101 # 257 (transfer transaction)
    FEE  = 25

    def self.build(attrs)
      new(attrs)
    end

    # @return [Integer]
    def type
      @type ||= TYPE
    end

    # @return [Integer]
    def fee
      @fee ||= calculate_fee
    end

    def mosaics
      @mosaics ||= []
    end

    alias to_hash_old to_hash

    def to_hash
      type
      fee
      to_hash_old
    end

    # @return [Integer]
    def calculate_fee
      if mosaics.empty?
        tmp_fee = [1, amount / 1_000_000 / 10_000].max
        fee = (tmp_fee > FEE ? FEE : tmp_fee)
      else
        # TODO: calc mosaics fee
        raise NotImplementedError, 'not implemented calculation mosaic fee.'
        fee = FEE
      end

      if message.bytesize > 0
        fee += [1, (message.bytesize / 2 / 32) + 1].max
      end

      fee * 1_000_000
    end
  end
end