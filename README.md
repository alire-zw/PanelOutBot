# PanelOut Bot

Telegram bot for selling panel and outbound VPN services. Built with [grammY](https://grammy.dev), Express webhooks, PostgreSQL (Prisma), Redis, and PasarGuard integration.

## Features

- Panel services: trial, unlimited (capacity-based), and pay-as-you-go usage
- Outbound services: volume packages and pay-as-you-go usage
- Wallet: TRON deposits, Rial card-to-card, transaction history, usage invoices
- Admin panel: payment settings, server/channel management, capacity & pricing
- Public FAQ page at `/faq`
- Docker-ready deployment with interactive setup script

## Requirements

- Docker 20+ with Compose v2 (or `docker-compose`)
- A public HTTPS URL for the Telegram webhook (reverse proxy / tunnel)
- Telegram bot token from [@BotFather](https://t.me/BotFather)
- TronGrid and SwapWallet API keys

## Quick start (Docker)

```bash
git clone https://github.com/alire-zw/PanelOutBot.git
cd PanelOutBot
chmod +x setup.sh
./setup.sh
```

The setup script will:

1. Ask for required configuration (bot token, webhook URL, database, etc.)
2. Generate a `.env` file
3. Build and start the application with Docker Compose

### Manual setup

```bash
cp .env.example .env
# Edit .env with your values
docker compose --profile infra up -d --build
```

## Environment variables

See [`.env.example`](.env.example) for the full list. Key variables:

| Variable | Description |
|----------|-------------|
| `BOT_TOKEN` | Telegram bot token |
| `WEBHOOK_URL` | Public base URL (no trailing slash) |
| `WEBHOOK_SECRET` | Random secret for webhook verification |
| `DATABASE_URL` | PostgreSQL connection string |
| `REDIS_URL` | Redis connection string |
| `ADMIN_IDS` | Comma-separated Telegram user IDs for admins |
| `TRONGRID_API_KEY` | TronGrid API key |
| `SWAPWALLET_API_KEY` | SwapWallet API key |

## Docker commands

```bash
# Start with bundled PostgreSQL + Redis
docker compose --profile infra up -d

# View logs
docker compose logs -f app

# Stop all services
docker compose down

# Optional: database UI (Adminer)
docker compose --profile tools up -d adminer
```

## Development (without Docker)

```bash
npm install
cp .env.example .env
# Set DATABASE_URL and REDIS_URL to localhost
npx prisma db push
npm run dev
```

## Project structure

```
src/           Application source code
prisma/        Database schema
public/faq/    Static FAQ page
docker/        Container entrypoint
setup.sh       Interactive Docker installer
```

## License

Private / all rights reserved unless otherwise specified by the repository owner.
