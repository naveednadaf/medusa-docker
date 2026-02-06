#!/usr/bin/env sh

set -e  # Continue on error to see all issues

echo "==========================================="
echo "Starting Medusa container initialization..."
echo "Current directory: $(pwd)"
echo "Node version: $(node --version)"
echo "Yarn version: $(yarn --version)"
echo "Contents of /server:"
ls -la
echo "==========================================="

# Ensure dependencies are installed in the container
echo "Ensuring dependencies are installed..."
if [ -f "yarn.lock" ]; then
  echo "Installing or updating dependencies..."
  yarn install --immutable || yarn install
else
  echo "WARNING: yarn.lock not found!"
fi

# Verify node_modules exist
if [ ! -d "node_modules" ]; then
  echo "ERROR: node_modules directory not found after installation!"
  ls -la
  exit 1
fi

echo "Dependencies installed successfully."
echo "Number of packages in node_modules: $(ls -1 node_modules 2>/dev/null | wc -l)"

# Wait a bit for DB to be ready
echo "Waiting for database to be ready..."
sleep 10

# Run migrations and start server
echo "Running database migrations..."
yarn medusa db:migrate

echo "Seeding database..."
yarn seed || echo "Seeding failed, continuing..."

echo "Starting Medusa development server..."
exec yarn dev