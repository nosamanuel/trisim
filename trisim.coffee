class Trie
    clusterSize: 3

    constructor: (cluster) ->
        @children = {}
        @data = null
        @cluster = cluster

    newCluster: -> (null for i in [1..@clusterSize])

    insert: (path, data) ->
        node = @
        cluster = @newCluster()
        data or= path
        for item in path
            cluster = (cluster.concat item)[-@clusterSize..]
            if not node.children[item]
                node.children[item] = new Trie(cluster)
            node = node.children[item]

        node.data = data

    search: (q) ->
        results = @searchRecursive q[0], q[1..], [], [], @newCluster()
        results.sort (a, b) ->
            b.similarity - a.similarity
        return results

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


examples = [
    'Northeast Lakeview College',
    'Midland College',
    'The University of Texas at Brownsville',
    'Schreiner University',
    'University of Houston System',
    'Stephen F. Austin State University',
    'Grayson College',
    'Hill College',
    'Mountain View College',
    'Navarro College',
    'North Central Texas College',
    'North Lake College',
    'Panola College',
    'Paris Junior College',
    'Ranger College',
    'Richland College',
    'Texas College',
    'Lon Morris College',
    'Northeast Texas Community College',
    'Odessa College',
    'Northwest Vista College',
    'Palo Alto College',
    'Antonio College',
    'Alvin Community College',
    'Amarillo College',
    'College of the Mainland Community College District',
    'St. Philip\'s College',
    'Texas Tech University System',
    'Midwestern State University',
    'University of the Incarnate Word',
    'Texas Lutheran University',
    'College of Saints John Fisher & Thomas More',
    'San Jacinto College Central Campus',
    'Angelina College',
    'Austin Community College',
    'Blinn College',
    'Coastal Bend College',
    'San Jacinto College North Campus',
    'San Jacinto College South Campus',
    'St. Edward\'s University',
    'Tarleton State University',
    'Dallas County Community College District',
    'Laredo Community College',
    'Lee College',
    'Cy-Fair',
    'Kingwood',
    'Montgomery',
    'North Harris',
    'Tomball',
    'Texas A&M University System',
    'Texas A&M University-Central Texas',
    'Lone Star College System District',
    'McLennan Community College',
    'Brazosport College',
    'Brookhaven College',
    'Cedar Valley College',
    'Central Texas College',
    'Cisco College',
    'Clarendon College',
    'Collin County Community College District',
    'Del Mar College',
    'Eastfield College',
    'El Centro College',
    'El Paso Community College District',
    'Frank Phillips College',
    'Galveston College',
    'Houston Community College',
    'Howard College',
    'Kilgore College',
    'San Jacinto Community College',
    'South Plains College',
    'South Texas College',
    'Southwest Collegiate Institute for the Deaf',
    'Southwest Texas Junior College',
    'Tarrant County College District',
    'Texas Tech University',
    'Tarrant County College District Northeast Campus',
    'Tarrant County College District Northwest Campus',
    'Tarrant County College District South Campus',
    'Tarrant County College District Southeast Campus',
    'Tarrant County College District Trinity River Campus',
    'Temple College',
    'Texarkana College',
    'Texas Southmost College',
    'Vernon College',
    'Victoria College, The',
    'Weatherford College',
    'Western Texas College',
    'Wharton County Junior College',
    'Trinity Valley Community College',
    'Tyler Junior College',
    'Texas State Technical College-Harlingen',
    'Texas State Technical College-Marshall',
    'Texas State Technical College-Waco',
    'Texas State Technical College-West Texas',
    'Lamar Institute of Technology',
    'Lamar State College-Orange',
    'Lamar State College-Port Arthur',
    'Alamo Community College District',
    'Howard County Junior College District',
    'Texas State Technical College Central Office',
    'Jacksonville College',
    'Parker University',
    'Texas Chiropractic College',
    'Prairie View A&M University',
    'Texas A&M International University',
    'Texas A&M University',
    'Texas A&M University at Galveston',
    'Texas A&M University-Commerce',
    'Texas A&M University-Corpus Christi',
    'Texas A&M University-Kingsville',
    'Texas A&M University-San Antonio',
    'Texas A&M University-Texarkana',
    'The University of Texas-Pan American',
    'Baylor College of Medicine',
    'UT Brownsville/TSC',
    'Our Lady of the Lake University of San Antonio',
    'Southwestern Christian College',
    'Texas A&M University System Health Science Center',
    'Texas Tech University Health Sciences Center',
    'West Texas A&M University',
    'University of St. Thomas',
    'Amberton University',
    'The University of Texas Health Science Center at Houston',
    'The University of Texas Health Science Center at San Antonio',
    'The University of Texas Health Science Center at Tyler',
    'The University of Texas M.D. Anderson Cancer Center',
    'Wayland Baptist University',
    'Southwestern Adventist University',
    'The University of Texas of the Permian Basin',
    'The University of Texas System',
    'The University of Texas Medical Branch at Galveston',
    'The University of Texas Southwestern Medical Center',
    'University of North Texas Health Science Center',
    'Paul Quinn College',
    'St. Mary\'s University',
    'Trinity University',
    'University of North Texas at Dallas',
    'University of North Texas System',
    'Rice University',
    'University of North Texas',
    'McMurry University',
    'Southern Methodist University',
    'Sul Ross State University Rio Grande College',
    'South Texas College of Law',
    'Texas Wesleyan University',
    'University of Mary Hardin-Baylor',
    'Wiley College',
    'Concordia University Texas',
    'Jarvis Christian College',
    'Houston Baptist University',
    'University of Dallas',
    'Sam Houston State University',
    'Sul Ross State University',
    'Texas Christian University',
    'Texas Southern University',
    'Hardin-Simmons University',
    'University of Houston-Clear Lake',
    'Southwestern University',
    'East Texas Baptist University',
    'Abilene Christian University',
    'Angelo State University',
    'Texas Woman\'s University',
    'The University of Texas at Tyler',
    'Texas State University System',
    'The University of Texas at Arlington',
    'The University of Texas at San Antonio',
    'University of Houston-Downtown',
    'The University of Texas at Dallas',
    'Lubbock Christian University',
    'LeTourneau University',
    'Southwestern Assemblies of God University',
    'Austin College',
    'University of Houston',
    'Dallas Baptist University',
    'Huston-Tillotson University',
    'Baylor University',
    'The University of Texas at Austin',
    'The University of Texas at El Paso',
    'University of Houston-Victoria',
    'Howard Payne University',
    'Lamar University',
    'Texas State University-San Marcos',
]
trie = new Trie()
for e in examples
    trie.insert e.toLowerCase(), e
console.log trie.search 'texas state'
