#!/bin/bash
curl -XPOST -H "Content-Type: application/json" http://localhost:8888/druid/indexer/v1/task -d@$1

