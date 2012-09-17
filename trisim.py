import sys

CLUSTER_SIZE = 3

def make_cluster(items=None, size=CLUSTER_SIZE):
    if items:
        return ([None] * size + list(items))[-size:]
    else:
        return [None] * size


class TrieSearch(object):
    def __init__(self, q, depth=0, results=None, clusters=None):
        self.q = q
        self.depth = depth
        if results is not None:
            self.results = results
        else:
            self.results = []
        if clusters is not None:
            self.clusters = clusters
        else:
            self.clusters = []

    @property
    def head(self):
        return self.q[self.depth] if self.depth < len(self.q) else ''

    @property
    def tail(self):
        return self.q[self.depth + 1:]

    @property
    def cluster(self):
        return make_cluster(self.q[:self.depth + 1])

    def search(self, node):
        for item, node in node.children.iteritems():
            if not self.tail and node.data:
                self.results.append({
                    'data': node.data,
                    'similarity': len(self.clusters)
                })

            if item == self.head:
                self.descend(node)
            else:
                self.search(node)

        return self.results

    def descend(self, node):
        if node.cluster == self.cluster:
            clusters = self.clusters + [node.cluster]
        else:
            clusters = self.clusters
        search = TrieSearch(self.q, self.depth + 1, self.results, clusters)
        search.search(node)


class Trie(object):
    def __init__(self, *cluster):
        self.children = {}
        self.data = None
        self.cluster = list(cluster)

    def insert(self, data):
        node = self
        cluster = make_cluster()
        for item in data:
            cluster = make_cluster(cluster + [item])
            node.children.setdefault(item, Trie(*cluster))
            node = node.children[item]

        node.data = data

    def search(self, q):
        search = TrieSearch(q)
        results = search.search(self)
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
    for r in sorted(results, key=lambda r: r['similarity'], reverse=True):
        print r


if __name__ == '__main__':
    main(*sys.argv)
