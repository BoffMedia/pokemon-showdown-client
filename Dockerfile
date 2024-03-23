# Use a Node.js base image
FROM node:latest AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

RUN npm cache clean --force && rm -rf node_modules package-lock.json && npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build-full

# Stage 2: Use a lightweight Nginx image for serving the built files
FROM node:alpine

# Copy built files from the previous stage to the Nginx web root directory
COPY --from=builder /app/ /app/

# Expose the port the app runs on
EXPOSE 80

# Expose the port the app runs on
EXPOSE 3000

WORKDIR /app

# Command to serve the files
CMD ["npx", "serve", "./play.pokemonshowdown.com"]