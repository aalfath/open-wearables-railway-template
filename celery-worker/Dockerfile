# Open Wearables Celery worker. Same official backend image as the API, pinned by version and digest.
FROM themomentum/open-wearables-backend:0.11.0@sha256:aaa0ccc7e6dcfbb3a36db6e0f63ec2782cf31a5bbd7cb466d11cd8d4657bc6dd

ENV ENVIRONMENT=production \
    OUTGOING_WEBHOOKS_ENABLED=true

WORKDIR /root_project
CMD ["scripts/start/worker.sh"]
