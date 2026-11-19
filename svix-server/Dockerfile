# Svix webhook server, used by Open Wearables for outgoing webhooks.
# Same version upstream's docker-compose.yml runs, pinned by digest.
FROM svix/svix-server:v1.101.0@sha256:7ba594c766c882dea9c868cd38957755b1d5c8bc5020f81cf5521ba5ab5adc11

ENV SVIX_QUEUE_TYPE=redis \
    SVIX_CACHE_TYPE=redis \
    SVIX_LISTEN_ADDRESS=[::]:8071 \
    PORT=8071

COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh
EXPOSE 8071
CMD ["/usr/local/bin/railway-start.sh"]
