#!/usr/bin/env sh

# Ensure dependencies are installed in the container
echo "Checking dependencies..."
yarn install --frozen-lockfile || yarn install

# Run migrations and start server
echo "Running database migrations..."
yarn medusa db:migrate

echo "Seeding database..."
yarn seed || echo "Seeding failed, continuing..."

echo "Starting Medusa development server..."
yarn dev