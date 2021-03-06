require 'spec_helper'

describe Nis::Request::PrepareAnnounce do
  let(:priv_key) { '00b4a68d16dc505302e9631b860664ba43a8183f0903bc5782a2403b2f9eb3c8a1' }
  let(:kp) { Nis::Keypair.new(priv_key) }

  let(:mo_attachment) do
    mosaic_id = Nis::Struct::MosaicId.new(
      namespaceId: 'sushi',
      name: 'anago'
    )
    properties = Nis::Struct::MosaicProperties.new(
      divisibility: 0,
      initialSupply: 10_000,
      supplyMutable: true,
      transferable: true
    )
    mo_def = Nis::Struct::MosaicDefinition.new(
      id: mosaic_id,
      properties: properties,
    )
    Nis::Struct::MosaicAttachment.new(mo_def, 1)
  end

  subject { described_class.new(tx, kp) }

  before { Timecop.freeze Time.utc(2015, 3, 29, 0, 6, 25, 0) }
  after  { Timecop.return }

  context 'Transaction#to_hash' do
    let(:mosaics) { [] }
    let(:tx) do
      Nis::Transaction::Transfer.new(
        'TA4TX6U5HG2MROAESH2JE5524T4ZOY2EQKQ6ELHF',
        1,
        'Good luck!',
        mosaics: mosaics
      )
    end

    it do
      expect(subject.to_hash).to match a_hash_including(
        transaction: {
          type: 257,
          fee: 100_000,
          recipient: 'TA4TX6U5HG2MROAESH2JE5524T4ZOY2EQKQ6ELHF',
          amount: 1_000_000,
          message: { type: 1, payload: '476f6f64206c75636b21' },
          timeStamp: 0,
          deadline: 3600,
          version: 0x98000001,
          signer: '5aff2e991f85d44eed8f449ede365a920abbefc22f1a2f731d4a002258673519',
          network: :testnet
        },
        privateKey: priv_key
      )
    end

    context 'when mosaic transfer' do
      let(:mosaics) { [mo_attachment] }

      it do
        expect(subject.to_hash).to match a_hash_including(
          transaction: {
            type: 257,
            fee: 100_000,
            recipient: 'TA4TX6U5HG2MROAESH2JE5524T4ZOY2EQKQ6ELHF',
            amount: 1_000_000,
            message: { type: 1, payload: '476f6f64206c75636b21' },
            timeStamp: 0,
            deadline: 3600,
            version: 0x98000002,
            signer: '5aff2e991f85d44eed8f449ede365a920abbefc22f1a2f731d4a002258673519',
            mosaics: [
              { mosaicId: { namespaceId: 'sushi', name: 'anago' }, quantity: 1 }
            ],
            network: :testnet
          },
          privateKey: priv_key
        )
      end
    end
  end

  context 'MultisigTransaction#to_hash' do
    let(:mosaics) { [] }
    let(:ttx) do
      Nis::Transaction::Transfer.new(
        'TA4TX6U5HG2MROAESH2JE5524T4ZOY2EQKQ6ELHF',
        1,
        'Good luck!',
        mosaics: mosaics
      )
    end
    let(:tx) do
      Nis::Transaction::Multisig.new(ttx, 'cc63b4dcdec745417043c3fa0992ec3a1695461a26d90264744648abbd5caa0d')
    end

    it do
      expect(subject.to_hash).to match a_hash_including(
        transaction: {
          type: 4100,
          timeStamp: 0,
          deadline: 3600,
          version: 0x98000001,
          signer: '5aff2e991f85d44eed8f449ede365a920abbefc22f1a2f731d4a002258673519',
          otherTrans: {
            type: 257,
            fee: 100_000,
            recipient: 'TA4TX6U5HG2MROAESH2JE5524T4ZOY2EQKQ6ELHF',
            amount: 1_000_000,
            message: { type: 1, payload: '476f6f64206c75636b21' },
            timeStamp: 0,
            deadline: 3600,
            version: 0x98000001,
            signer: 'cc63b4dcdec745417043c3fa0992ec3a1695461a26d90264744648abbd5caa0d',
            network: :testnet
          },
          fee: 150000,
          network: :testnet
          # signatures: []
        },
        privateKey: priv_key
      )
    end

    context 'when mosaic transfer' do
      let(:mosaics) { [mo_attachment] }

      it do
        expect(subject.to_hash).to match a_hash_including(
          transaction: {
            type: 4100,
            timeStamp: 0,
            deadline: 3600,
            version: 0x98000001,
            signer: '5aff2e991f85d44eed8f449ede365a920abbefc22f1a2f731d4a002258673519',
            otherTrans: {
              type: 257,
              fee: 100_000,
              recipient: 'TA4TX6U5HG2MROAESH2JE5524T4ZOY2EQKQ6ELHF',
              amount: 1_000_000,
              message: { type: 1, payload: '476f6f64206c75636b21' },
              timeStamp: 0,
              deadline: 3600,
              version: 0x98000002,
              signer: 'cc63b4dcdec745417043c3fa0992ec3a1695461a26d90264744648abbd5caa0d',
              mosaics: [
                { mosaicId: { namespaceId: 'sushi', name: 'anago' }, quantity: 1 }
              ],
              network: :testnet
            },
            fee: 150000,
            network: :testnet
            # signatures: []
          },
          privateKey: priv_key
        )
      end
    end
  end
end
