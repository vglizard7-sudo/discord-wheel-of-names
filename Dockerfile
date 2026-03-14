FROM node:18-bullseye

# Install system libraries needed by canvas
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    librsvg2-dev \
    build-essential \
    python3 \
    pkg-config \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Clean install dependencies
RUN rm -rf node_modules package-lock.json \
 && npm install \
 && npm rebuild @napi-rs/canvas --build-from-source

# Copy source code
COPY . .

# Start the bot
CMD ["node", "index.js"]
