#!/usr/bin/env sh

set -e  # Exit on any error

echo "Starting container initialization..."

# Check if we're in the right directory
echo "Current directory: $(pwd)"
echo "Contents: $(ls -la)"

# Ensure dependencies are installed in the container
echo "Ensuring dependencies are installed..."
if [ -f "yarn.lock" ]; then
  echo "Installing dependencies..."
  yarn install --immutable
else
  echo "yarn.lock not found!"
fi

# Verify node_modules exist
if [ ! -d "node_modules" ]; then
  echo "ERROR: node_modules directory not found!"
  exit 1
fi

echo "node_modules directory exists with $(ls -1 node_modules | wc -l) packages"

# Run migrations and start server
echo "Running database migrations..."
yarn medusa db:migrate

echo "Seeding database..."
yarn seed || echo "Seeding failed, continuing..."

echo "Starting Medusa development server..."
yarn dev