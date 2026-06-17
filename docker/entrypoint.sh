#!/bin/sh
set -e

echo "[entrypoint] syncing database schema..."
npx prisma db push --skip-generate

echo "[entrypoint] starting application..."
exec "$@"
