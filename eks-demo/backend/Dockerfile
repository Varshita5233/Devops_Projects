# Small base image
FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy the app (no dependencies needed - pure Node http)
COPY server.js .

# Run as non-root user for security (talking point!)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# The app listens on 8080
EXPOSE 8080

# Start the app
CMD ["node", "server.js"]
