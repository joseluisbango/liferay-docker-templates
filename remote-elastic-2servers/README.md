# 2 Liferay severs sharing a remote Elasticsearch instance
This template will set up 2 independent Liferay servers (no cluster) that connect to a remote Elasticserach instance. 

However, you can set up only 1 Liferay server easily.

## How to use only 1 Liferay server
Simply comment out the `liferay-2` service, the `lr-network` section and the `- lr-network` line in `liferay-1` service.

## How to connect to Elasticsearch from you machine
The remote Elasticsearch instance is ready to accept request from the host machine.

In order to test it, try using cURL: `curl -X GET locahost:9200`

The response should be something like this:

    $ curl -X GET locahost:9200
    {
        "name" : "01e43cc0a20e",
        "cluster_name" : "LiferayElasticsearchCluster",
        "cluster_uuid" : "2htKv0LoQZeSqlfuwYyZ6w",
        "version" : {
            "number" : "7.17.6",
            "build_flavor" : "default",
            "build_type" : "tar",
            "build_hash" : "f65e9d338dc1d07b642e14a27f338990148ee5b6",
            "build_date" : "2022-08-23T11:08:48.893373482Z",
            "build_snapshot" : false,
            "lucene_version" : "8.11.1",
            "minimum_wire_compatibility_version" : "6.8.0",
            "minimum_index_compatibility_version" : "6.0.0-beta1"
        },
        "tagline" : "You Know, for Search"
    }

