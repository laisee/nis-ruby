class Nis
  class Keypair
    attr_reader :private, :public

    def initialize(private_key, public_key: nil)
      @private = private_key
      @public  = public_key || calc_public_key
    end

    def fix_private_key(key)
      "#{'0' * 64}#{key.sub(/^00/i, '')}"[-64, 64]
    end

    def calc_public_key
      bin_secret = fix_private_key(@private).scan(/../).map(&:hex).reverse.pack('C*')
      bin_public = Nis::Util::Ed25519.publickey_hash_unsafe(bin_secret)
      bin_public.unpack('H*').first
    end
  end
end
