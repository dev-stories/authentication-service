set -x
set -m

/entrypoint.sh couchbase-server &

sleep 15

# Setup index and memory quota
curl -v -X POST http://127.0.0.1:8091/pools/default -d memoryQuota=300 -d indexMemoryQuota=300

# Setup services
curl -v http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex

# Setup credentials
curl -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=cagillaser -d password=cagillaser123

# Setup Memory Optimized Indexes
curl -i -u cagillaser:cagillaser123 -X POST http://127.0.0.1:8091/settings/indexes -d storageMode=memory_optimized

#->
#couchbase-cli bucket-create -c 127.0.0.1:8091 --username cagillaser \
# --password cagillaser123 --bucket dev-stories --bucket-type couchbase \
# --bucket-ramsize 1024

# Load travel-sample bucket
curl -v -X POST http://127.0.0.1:8091/pools/default/buckets \
-u cagillaser:cagillaser123 \
-d name=dev-stories \
-d ramQuota=256 \
-d bucketType=couchbase

echo "Type: $TYPE"

if [ "$TYPE" = "WORKER" ]; then
  echo "Sleeping ..."
  sleep 15

  #IP=`hostname -s`
  IP=`hostname -I | cut -d ' ' -f1`
  echo "IP: " $IP

  echo "Auto Rebalance: $AUTO_REBALANCE"
  if [ "$AUTO_REBALANCE" = "true" ]; then
    couchbase-cli rebalance --cluster=$COUCHBASE_MASTER:8091 --user=cagillaser --password=cagillaser123 --server-add=$IP --server-add-username=cagillaser --server-add-password=cagillaser123
  else
    couchbase-cli server-add --cluster=$COUCHBASE_MASTER:8091 --user=cagillaser --password=cagillaser123 --server-add=$IP --server-add-username=cagillaser --server-add-password=cagillaser123
  fi;
fi;

fg 1