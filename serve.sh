#!/bin/bash

# Variables
CONTAINER_NAME="static-site-server"
SITE_PATH="/data/dev/git/OWS-StaticSiteGenerator/hugo/public"
PORT=80

# Ensure the site has been built
if [ ! -d "$SITE_PATH" ]; then
    echo "❌ Error: Compiled site directory '$SITE_PATH' does not exist."
    exit 1
fi

# Stop and remove any existing container
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🔄 Stopping existing container..."
    docker stop $CONTAINER_NAME > /dev/null
    docker rm $CONTAINER_NAME > /dev/null
fi

# Run the Docker container
echo "🚀 Starting web server on http://192.168.1.19:$PORT/"
docker run -d --name $CONTAINER_NAME -p $PORT:80 -v "$SITE_PATH":/usr/share/nginx/html:ro nginx

# Show running container
docker ps | grep $CONTAINER_NAME

# open log stream for container
docker logs -f $CONTAINER_NAME

