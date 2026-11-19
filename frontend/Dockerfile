# Open Wearables developer portal (SvelteKit on Bun). Official image, pinned by version and digest.
# VITE_API_URL (public API address) and API_URL (private hop to the API) are read at runtime.
FROM themomentum/open-wearables-frontend:0.11.0@sha256:f78f925612034b2a9f196ebda562c21258e84573f8eb1f1e024d43bd49b887ba

ENV PORT=3000 HOST=0.0.0.0
EXPOSE 3000
CMD ["bun", "./build/index.js"]
