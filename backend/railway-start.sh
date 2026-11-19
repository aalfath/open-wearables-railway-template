#!/bin/bash
# Railway wrapper for the Open Wearables API.
set -euo pipefail
cd /root_project

# Railway routes the public domain to PORT; upstream listens on API_PORT.
export API_PORT="${PORT:-${API_PORT:-8000}}"

# On a fresh template deploy Postgres may still be starting: wait up to 5 minutes
# so the migrations in app.sh don't fail on the first try.
python3 - <<'PY'
import os, sys, time
import psycopg
dsn = dict(host=os.environ.get("DB_HOST", "db"), port=os.environ.get("DB_PORT", "5432"),
           dbname=os.environ.get("DB_NAME", "open-wearables"), user=os.environ.get("DB_USER", "open-wearables"),
           password=os.environ.get("DB_PASSWORD", ""), connect_timeout=5)
for attempt in range(60):
    try:
        psycopg.connect(**dsn).close()
        print("Postgres is reachable.", flush=True)
        sys.exit(0)
    except Exception as exc:
        print(f"Waiting for Postgres ({attempt + 1}/60): {exc.__class__.__name__}", flush=True)
        time.sleep(5)
sys.exit("Postgres did not become reachable in 5 minutes.")
PY

exec scripts/start/app.sh
