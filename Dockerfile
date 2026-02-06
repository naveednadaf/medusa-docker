# Development Dockerfile for Medusa
FROM node:20-alpine

# Set working directory
WORKDIR /server

# Copy package files and yarn config
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn/releases .yarn/releases

# Install all dependencies using yarn
RUN yarn install

# Copy source code (excluding node_modules to prevent conflicts with the volume mount)
COPY . .

# Remove any potential local node_modules that might interfere
RUN rm -rf node_modules

# Make start.sh executable
RUN chmod +x ./start.sh

# Expose the port Medusa runs on
EXPOSE 9000 5173

# Start with migrations and then the development server
CMD ["/bin/sh", "./start.sh"]