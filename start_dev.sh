#!/bin/bash

# Moodle Development Startup Script

# Function to handle script exit
cleanup() {
    echo "Stopping servers..."
    kill $(jobs -p) 2>/dev/null
    exit
}

# Trap SIGINT (Ctrl+C) to run cleanup
trap cleanup SIGINT

# Check for dependencies
if [ ! -d "node_modules" ]; then
    echo "Installing frontend dependencies..."
    npm install
fi

# Check for moodledata
if [ ! -d "moodledata" ]; then
    echo "Creating moodledata directory..."
    mkdir -p moodledata
    chmod 777 moodledata
fi

# Check for config.php
if [ ! -f "config.php" ]; then
    echo "WARNING: config.php not found. You may need to run the installation steps first."
    echo "See DEVELOPMENT_SETUP.md for details."
fi

# Ensure public/config.php symlink exists if config.php exists
if [ -f "config.php" ] && [ ! -f "public/config.php" ]; then
    echo "Creating symlink for public/config.php..."
    ln -s ../config.php public/config.php
fi

echo "Starting Grunt watcher..."
npx grunt watch > grunt.log 2>&1 &
GRUNT_PID=$!
echo "Grunt running (PID: $GRUNT_PID). Logs in grunt.log"

echo "Starting PHP Development Server..."
echo "Access the site at http://localhost:8000"
echo "Press Ctrl+C to stop."

php -S 0.0.0.0:8000 -t public
