# Stage 1: Build the application
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Build the TypeScript files
RUN npm run build

# Stage 2: Run the application
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

# Install only production dependencies
RUN npm install --only=production

# Expose the port
EXPOSE 3000

# Start the application
CMD ["node", "dist/server.js"]
