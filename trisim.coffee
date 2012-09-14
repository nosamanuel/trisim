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
            cluster = (cluster.concat item)[1..@clusterSize]
            if item not in node.children
                node.children[item] = new Trie(cluster)
            node = node.children[item]

        node.data = data

    search: (q) ->
        [head, tail] = (q.slice 0) q[1..]
        cluster = @newCluster().concat head
        @searchRecursive head, tail, [], [], cluster

    searchRecursive: (head, tail, results, clusters, cluster) ->
        for item, node in @children
            if not tail and node.data
                results.append
                    data: node.data
                    similarity: clusters.length

            if item == head
                newCluster = cluster[..].concat head
                if node.cluster == newCluster
                    newClusters = clusters[..].concat newCluster
                else
                    newClusters = clusters
                [newHead, newTail] = tail[..1] newTail = tail[1..]
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
