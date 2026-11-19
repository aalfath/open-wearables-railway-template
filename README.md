[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/open-wearables-2?utm_medium=integration&utm_source=button&utm_campaign=open-wearables)

# Deploy and Host Open Wearables on Railway

Open Wearables is an open-source (MIT) platform that pulls health data from wearables such as Garmin, Oura, Whoop, Polar, Suunto, Withings and Apple Health into one database and serves it through one REST API. It includes a developer portal where you manage users, provider connections, API keys and outgoing webhooks.

## About Hosting Open Wearables

Open Wearables needs more than one container. A FastAPI backend serves the API and runs the database migrations, a Celery worker does the provider syncs and data processing, Celery beat schedules the recurring syncs, and a SvelteKit portal is the web UI. PostgreSQL stores users and health data, Redis is the Celery broker and cache, and Svix delivers signed outgoing webhooks. This template wires all of them over Railway's private network, generates every secret, keeps PostgreSQL and Redis on volumes, and pins Open Wearables 0.11.0 by image digest. The only thing it asks you for is the admin email. To pull data from real devices you add each provider's OAuth app credentials after the deploy.

## Common Use Cases

* Give a health, fitness or coaching app one API for data from many wearable brands
* Keep wearable and health data on infrastructure you control, instead of a paid aggregator
* Get webhooks when new sleep, activity or workout data arrives for your users

## Dependencies for Open Wearables Hosting

* PostgreSQL (Railway's PostgreSQL, on a volume)
* Redis (Railway's Redis, on a volume)

### Deployment Dependencies

* [Open Wearables 0.11.0 release](https://github.com/the-momentum/open-wearables/releases/tag/0.11.0)
* [Open Wearables Docker deployment docs](https://docs.openwearables.io/deployment/docker)
* [Provider setup guides](https://docs.openwearables.io/providers/supported)
* [Svix server](https://github.com/svix/svix-webhooks), v1.101.0 (the version upstream's Compose file runs)
* [Template repository](https://github.com/aalfath/open-wearables-railway-template)

### Implementation Details

The template deploys these services:

| Service | What it does | Public |
|---|---|---|
| `frontend` | Developer portal (SvelteKit). Open this URL and sign in | yes |
| `backend` | FastAPI API. Runs migrations and seed scripts on every start, then serves the API. Your apps, SDKs and provider webhooks call this URL | yes |
| `celery-worker` | Background jobs: provider syncs, Apple Health imports, webhook sends | no |
| `celery-beat` | Schedules the recurring syncs | no |
| `svix-server` | Delivers outgoing webhooks. Keeps its data in a `svix` database the backend creates in the same PostgreSQL | no |
| `Postgres` | Railway PostgreSQL, on a volume | no |
| `Redis` | Railway Redis, on a volume | no |

**After the deploy**

1. Open the `frontend` URL and sign in with the `ADMIN_EMAIL` you entered. The password is the generated `ADMIN_PASSWORD` in the `backend` service's Variables tab. Change it in the portal after your first sign-in. Changing `ADMIN_PASSWORD` later doesn't change an existing account.
2. Add more developers by invitation in the portal. Invitation emails need `RESEND_API_KEY`, or `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD` and `EMAIL_FROM_ADDRESS`, on `backend` and `celery-worker`.
3. For each provider you want, create an OAuth app on the provider's developer site (redirect URIs use the `backend` URL, which is already set as `API_BASE_URL`). Then add its variables, for example `GARMIN_CLIENT_ID` and `GARMIN_CLIENT_SECRET`, to **both** `backend` and `celery-worker`, because the worker refreshes tokens and runs the syncs. The [provider guides](https://docs.openwearables.io/providers/supported) list every variable.
4. Apple Health XML uploads and raw payload storage need an S3-compatible bucket (`AWS_BUCKET_NAME`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_ENDPOINT_URL`). They're optional.

**Good to know**

* Outgoing webhooks are on (`OUTGOING_WEBHOOKS_ENABLED=true`) and run through the bundled `svix-server`. They need no setup.
* Open Wearables sends anonymous usage counts to its developers by default (no user or health data). To turn that off, set `TELEMETRY_ENABLED=false` on `backend`, `celery-worker` and `celery-beat`.
* Flower, the Celery monitoring UI, isn't included, because it has no login of its own.

**Updates.** Every service builds from this repository, whose Dockerfiles pin the official `themomentum/open-wearables-backend`, `themomentum/open-wearables-frontend` and `svix/svix-server` images by version and digest. When a new release is pinned here, Railway shows an update notice on your project, and you choose when to apply it. Read [CHANGELOG.md](https://github.com/aalfath/open-wearables-railway-template/blob/main/CHANGELOG.md) first. The backend applies database migrations on its next start.

## Why Deploy Open Wearables on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Open Wearables on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
