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
        head, tail = q[0], q[1:]
        cluster = self._new_cluster() + [head]
        return self._search_recursive(head, tail, [], [], cluster)

    def _search_recursive(self, head, tail, results, clusters, cluster):
        for item, node in self.children.iteritems():
            if not tail and node.data:
                result = Result(node.data, len(clusters))
                results.append(result)

            if item == head:
                new_cluster = (cluster + [head])[-self.cluster_size:]
                if node.cluster == new_cluster:
                    new_clusters = clusters + [new_cluster]
                else:
                    new_clusters = clusters
                node._search_recursive(tail[:1], tail[1:], results,
                                       new_clusters, new_cluster)
            else:
                node._search_recursive(head, tail, results, clusters, cluster)

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
