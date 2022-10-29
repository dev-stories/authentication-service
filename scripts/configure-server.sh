set -x
set -m

/entrypoint.sh couchbase-server &

sleep 20

# Setup services
# curl --silent -v -u "$COUCHBASE_USER":"$COUCHBASE_PASSWORD" http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex

# Setup credentials
curl --silent -v -u "$COUCHBASE_USER":"$COUCHBASE_PASSWORD" \
  http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/settings/web \
  -d port=8091 \
  -d username="$COUCHBASE_USER" \
  -d password="$COUCHBASE_PASSWORD"

# Setup index and memory quota
curl --silent -v -u "$COUCHBASE_USER":"$COUCHBASE_PASSWORD" -X POST \
  http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/pools/default \
  -d memoryQuota=300 \
  -d indexMemoryQuota=300

# Setup Memory Optimized Indexes
curl --silent -i -u "$COUCHBASE_USER":"$COUCHBASE_PASSWORD" -X POST \
  http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/settings/indexes \
  -d storageMode=memory_optimized

isBucketExists=$("curl --silent -LI -u cagillaser:cagillaser123 -X GET \
  http://$COUCHBASE_HOST:$COUCHBASE_PORT/default/buckets/$COUCHBASE_BUCKET \
  -o /dev/null -w '%{http_code}\n' -s")

if [ "$isBucketExists" = 404 ]; then
  curl --silent -v -X POST http://"$COUCHBASE_HOST":"$COUCHBASE_PORT"/pools/default/buckets \
    -u "$COUCHBASE_USER":"$COUCHBASE_PASSWORD" \
    -d name="$COUCHBASE_BUCKET" \
    -d ramQuota=256 \
    -d bucketType=couchbase
fi

curl --silent -X POST -v -u "$COUCHBASE_USER":"$COUCHBASE_PASSWORD" \
  "http://$COUCHBASE_HOST:$COUCHBASE_PORT/_p/query/query/service" \
  -d "statement=CREATE PRIMARY INDEX idx_default_primary IF NOT EXISTS ON \`$COUCHBASE_BUCKET\` USING GSI"

fg 1
