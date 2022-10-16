set -x
set -m

/entrypoint.sh couchbase-server &

sleep 15

# Setup index and memory quota
curl -v -X POST http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/pools/default -d memoryQuota=300 -d indexMemoryQuota=300

# Setup services
curl -v http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex

# Setup credentials
curl -v http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/settings/web -d port=8091 -d username=$COUCHBASE_USER -d password=$COUCHBASE_PASSWORD

# Setup Memory Optimized Indexes
curl -i -u $COUCHBASE_USER:$COUCHBASE_PASSWORD -X POST http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/settings/indexes -d storageMode=memory_optimized

# Load travel-sample bucket
curl -v -X POST http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/pools/default/buckets \
  -u $COUCHBASE_USER:$COUCHBASE_PASSWORD \
  -d name=dev-stories \
  -d ramQuota=256 \
  -d bucketType=couchbase

curl -X POST -v -u $COUCHBASE_USER:$COUCHBASE_PASSWORD "http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/_p/query/query/service" -d \
  'statement=CREATE PRIMARY INDEX IF NOT EXISTS ON `default`:`dev-stories`'

echo "Type: $TYPE"

if [ "$TYPE" = "WORKER" ]; then
  echo "Sleeping ..."
  sleep 15

  #IP=`hostname -s`
  IP=$(hostname -I | cut -d ' ' -f1)
  echo "IP: " $IP

  echo "Auto Rebalance: $AUTO_REBALANCE"
  if [ "$AUTO_REBALANCE" = "true" ]; then
    couchbase-cli rebalance --cluster=$COUCHBASE_MASTER:8091 --user=$COUCHBASE_USER --password=$COUCHBASE_PASSWORD --server-add=$IP --server-add-username=$COUCHBASE_USER --server-add-password=$COUCHBASE_PASSWORD
  else
    couchbase-cli server-add --cluster=$COUCHBASE_MASTER:8091 --user=$COUCHBASE_USER --password=$COUCHBASE_PASSWORD --server-add=$IP --server-add-username=$COUCHBASE_USER --server-add-password=$COUCHBASE_PASSWORD
  fi
fi

fg 1
