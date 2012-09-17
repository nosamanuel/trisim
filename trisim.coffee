class Trie
    clusterSize: 3

    constructor: (cluster) ->
        @children = {}
        @data = null
        @cluster = cluster

    newCluster: -> (null for i in [1..@clusterSize])

    insert: (data) ->
        node = @
        cluster = @newCluster()
        for item in data
            cluster = (cluster.concat item)[-@clusterSize..]
            if not node.children[item]
                node.children[item] = new Trie(cluster)
            node = node.children[item]

        node.data = data

    search: (q) ->
        [head, tail] = [q[0], q[1..]]
        @searchRecursive head, tail, [], [], @newCluster()

    searchRecursive: (head, tail, results, clusters, cluster) ->
        for item, node of @children
            if not tail and node.data
                results.push
                    data: node.data
                    similarity: clusters.length

            if item == head
                newCluster = (cluster[..].concat head)[-@clusterSize..]
                if node.cluster.join() == newCluster.join()
                    newClusters = clusters[..].concat [newCluster]
                else
                    newClusters = clusters
                [newHead, newTail] = [tail[0], tail[1..]]
                node.searchRecursive newHead, newTail, results, newClusters, newCluster
            else
                node.searchRecursive head, tail, results, clusters, cluster

        return results


examples = (e.toLowerCase() for e in [
    'Trinity University',
    'The University of Texas at Austin',
    'Rice University',
    'The University of Houston'
])
trie = new Trie()
for e in examples
    trie.insert e
console.log trie.search 'trinity'
