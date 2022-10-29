#!/bin/sh
echo "Hey! I will try check health of couchbase for 120 seconds. Let's go to take an americano with extra shot ☕︎︎"
second=1
until $(curl --output /dev/null --silent --head --fail "$COUCHBASE_URL"); do
    if [ $second -ge 120 ]; then
      echo "\nSorry but i am so tired. Try again later pls ¯\_(ツ)_/¯"
      exit 1
    fi
    ((second++))
    sleep 1
done
echo "Connected in $second seconds. Let's start"
exec "$@"
