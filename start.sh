#!/usr/bin/env sh

set -e  # Exit on any error

echo "Starting container initialization..."

# Check if we're in the right directory
echo "Current directory: $(pwd)"

# Ensure dependencies are installed in the container
echo "Ensuring dependencies are installed..."
if [ -f "yarn.lock" ]; then
  echo "Installing or updating dependencies..."
  yarn install
else
  echo "ERROR: yarn.lock not found!"
  exit 1
fi

# Verify node_modules exist
if [ ! -d "node_modules" ]; then
  echo "ERROR: node_modules directory not found after installation!"
  exit 1
fi

echo "Dependencies installed successfully."

# Run migrations and start server
echo "Running database migrations..."
yarn medusa db:migrate

echo "Seeding database..."
yarn seed || echo "Seeding failed, continuing..."

echo "Starting Medusa development server..."
yarn dev