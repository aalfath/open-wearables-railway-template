#!/bin/bash
# Railway wrapper for svix-server. The Open Wearables backend creates the "svix"
# database on its first start, so retry the migrations until it exists (up to 10 minutes).
set -uo pipefail
: "${SVIX_JWT_SECRET:?SVIX_JWT_SECRET must be set}"
: "${SVIX_DB_DSN:?SVIX_DB_DSN must be set}"
: "${SVIX_REDIS_DSN:?SVIX_REDIS_DSN must be set}"

for attempt in $(seq 1 120); do
  if svix-server migrate; then
    exec svix-server
  fi
  echo "svix database not ready yet (attempt ${attempt}/120), retrying in 5s..."
  sleep 5
done
echo "svix database never became ready" >&2
exit 1
