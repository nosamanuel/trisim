// Generated by CoffeeScript 1.3.3
(function() {
  var Trie, e, examples, trie, _i, _len;

  Trie = (function() {

    Trie.prototype.clusterSize = 3;

    function Trie(cluster) {
      this.children = {};
      this.data = null;
      this.cluster = cluster;
    }

    Trie.prototype.newCluster = function() {
      var i, _i, _ref, _results;
      _results = [];
      for (i = _i = 1, _ref = this.clusterSize; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        _results.push(null);
      }
      return _results;
    };

    Trie.prototype.insert = function(data) {
      var cluster, item, key, node, _i, _len;
      node = this;
      cluster = this.newCluster();
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        item = data[_i];
        cluster = (cluster.concat(item)).slice(-this.clusterSize);
        if (item !== (function() {
          var _results;
          _results = [];
          for (key in node.children) {
            _results.push(key);
          }
          return _results;
        })()) {
          node.children[item] = new Trie(cluster);
        }
        node = node.children[item];
      }
      return node.data = data;
    };

    Trie.prototype.search = function(q) {
      var head, tail, _ref;
      _ref = [q[0], q.slice(1)], head = _ref[0], tail = _ref[1];
      return this.searchRecursive(head, tail, [], [], this.newCluster());
    };

    Trie.prototype.searchRecursive = function(head, tail, results, clusters, cluster) {
      var item, newCluster, newClusters, newHead, newTail, node, _ref, _ref1;
      _ref = this.children;
      for (item in _ref) {
        node = _ref[item];
        if (!tail && node.data) {
          results.append({
            data: node.data,
            similarity: clusters.length
          });
        }
        if (item === head) {
          newCluster = (cluster.slice(0).concat(head)).slice(-this.clusterSize);
          if (node.cluster.join() === newCluster.join()) {
            newClusters = clusters.slice(0).concat([newCluster]);
          } else {
            newClusters = clusters;
          }
          _ref1 = [tail[0], tail.slice(1)], newHead = _ref1[0], newTail = _ref1[1];
          node.searchRecursive(newHead, newTail, results, newClusters, newCluster);
        } else {
          node.searchRecursive(head, tail, results, clusters, cluster);
        }
      }
      return results;
    };

    return Trie;

  })();

  examples = (function() {
    var _i, _len, _ref, _results;
    _ref = ['Trinity University', 'The University of Texas at Austin', 'Rice University', 'The University of Houston'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      e = _ref[_i];
      _results.push(e.toLowerCase());
    }
    return _results;
  })();

  trie = new Trie();

  for (_i = 0, _len = examples.length; _i < _len; _i++) {
    e = examples[_i];
    trie.insert(e);
  }

  console.log(trie.search('trinity'));

}).call(this);
