import sys


class Trie(object):
    def __init__(self):
        self.children = {}
        self.data = None

    def insert(self, data):
        node = self
        for d in data:
            node.children.setdefault(d, Trie())
            node = node.children[d]

        node.data = data

    def search(self, q):
        return self._search_recursive(q[0], q[1:], [])

    def _search_recursive(self, head, tail, results):
        for item, node in self.children.iteritems():
            if not tail and node.data:
                results.append(node.data)
            if item == head and tail:
                node._search_recursive(tail[0], tail[1:], results)
            else:
                node._search_recursive(head, tail, results)

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
    for r in results:
        print r


if __name__ == '__main__':
    main(*sys.argv)
