import sys


class Result(object):
    def __init__(self, data, similarity):
        self.data = data
        self.similarity = similarity

    def __repr__(self):
        return u'<Result: %r, similarity=%d>' % (self.data, self.similarity)


class Trie(object):
    cluster_size = 3

    def __init__(self, *cluster):
        self.children = {}
        self.data = None
        self.cluster = list(cluster)

    def _new_cluster(self):
        return [None] * self.cluster_size

    def insert(self, data):
        node = self
        cluster = self._new_cluster()
        for item in data:
            cluster = (cluster + [item])[-self.cluster_size:]
            node.children.setdefault(item, Trie(*cluster))
            node = node.children[item]

        node.data = data

    def search(self, q):
        head, tail, results, clusters = q[0], q[1:], [], []
        cluster = self._new_cluster()
        return self._search_recursive(cluster, head, tail, results, clusters)

    def _search_recursive(self, cluster, head, tail, results, clusters):
        for item, node in self.children.iteritems():
            if not tail and node.data:
                results.append(Result(node.data, len(clusters)))

            if item == head:
                new_cluster = (cluster + [head])[-self.cluster_size:]
                new_clusters = list(clusters)
                if node.cluster == new_cluster:
                    new_clusters.append(cluster)
                if tail:
                    node._search_recursive(new_cluster, tail[0], tail[1:], results, new_clusters)
                else:
                    node._search_recursive(new_cluster, None, [], results, new_clusters)
            else:
                node._search_recursive(cluster, head, tail, results, clusters)

        return results


def load_trie():
    trie = Trie()
    for line in open('examples.txt'):
        word = line.strip().decode('utf-8').lower()
        trie.insert(word)

    return trie


def main(script, q):
    trie = load_trie()
    results = trie.search(q.decode('utf-8'))
    for r in sorted(results, key=lambda r: r.similarity, reverse=True):
        print r


if __name__ == '__main__':
    main(*sys.argv)
