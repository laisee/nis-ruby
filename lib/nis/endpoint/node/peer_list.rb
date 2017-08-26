module Nis::Endpoint
  module Node::PeerList
    # @return [Nis::Struct::NodeCollection]
    # @see https://nemproject.github.io/#complete-neighborhood
    def node_peerlist_all
      Nis::Struct::NodeCollection.build request!(:get, '/node/peer-list/all')
    end

    # @return [Array <Nis::Struct::Node>]
    # @see https://nemproject.github.io/#reachable-neighborhood
    def node_peerlist_reachable
      request!(:get, '/node/peer-list/reachable') do |res|
        res[:data].map { |n| Nis::Struct::Node.build(n) }
      end
    end

    # @return [Array <Nis::Struct::Node>]
    # @see https://nemproject.github.io/#active-neighborhood
    def node_peerlist_active
      request!(:get, '/node/peer-list/active') do |res|
        res[:data].map { |n| Nis::Struct::Node.build(n) }
      end
    end
  end
end
