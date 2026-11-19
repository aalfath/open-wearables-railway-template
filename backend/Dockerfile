# Open Wearables API (FastAPI). Official image, pinned by version and digest.
FROM themomentum/open-wearables-backend:0.11.0@sha256:aaa0ccc7e6dcfbb3a36db6e0f63ec2782cf31a5bbd7cb466d11cd8d4657bc6dd

# Production mode: refuses the public default admin password and logs less.
ENV ENVIRONMENT=production \
    OUTGOING_WEBHOOKS_ENABLED=true

COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh
EXPOSE 8000
# Waits for Postgres, then runs upstream's scripts/start/app.sh
# (svix database, migrations, seed data, admin account, API server).
CMD ["/usr/local/bin/railway-start.sh"]
