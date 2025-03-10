#!/bin/bash

CONTAINER_5_2_IMAGE="../5.2"
CONTAINER_5_3_IMAGE="."
CONTAINER_5_3_RUN="$(realpath ../5.2)"


IMAGE_5_2="watermark-app-5.2"
IMAGE_5_3="watermark-app-5.3"

build_docker() {
    local dir=$1
    local image_name=$2
    echo "🔨 Building Docker image for $dir..."
    docker build -t "$image_name" "$dir"
    if [ $? -ne 0 ]; then
        echo "❌ Failed to build $image_name. Exiting..."
        exit 1
    fi
    echo "✅ Built $image_name successfully!"
}

run_container2() {
    local image_name=$1
    local volume_path=$2
    echo "🚀 Running Docker container: $image_name..."
    docker run --rm -v "$volume_path:/images" "$image_name" /images
    if [ $? -ne 0 ]; then
        echo "❌ Docker container $image_name failed. Exiting..."
        exit 1
    fi
    echo "✅ Docker container $image_name finished successfully!"
}

cleanup() {
    echo "🧹 Cleaning up..."

    docker ps -q --filter ancestor="$IMAGE_5_2" | xargs -r docker stop
    docker ps -q --filter ancestor="$IMAGE_5_3" | xargs -r docker stop

    docker ps -a -q --filter ancestor="$IMAGE_5_2" | xargs -r docker rm
    docker ps -a -q --filter ancestor="$IMAGE_5_3" | xargs -r docker rm

    docker rmi -f "$IMAGE_5_2" "$IMAGE_5_3" 2>/dev/null

    echo "✅ Cleanup done!"
}

run_container() {
    cd ../5.2
    echo "🚀 Running Docker container: $image_name..."
    docker run -it -v "$(pwd)":/app my_python_5.2 --plant "Rose" --height 50 55 60 65 70 --leaf_count 35 40 45 50 55 --dry_weight 2.0 2.0 2.1 2.1 3.0
    if [ $? -ne 0 ]; then
        echo "❌ Docker container $image_name failed. Exiting..."
        exit 1
    fi
    echo "✅ Docker container $image_name finished successfully!"
}

# Build Dockers
build_docker "$CONTAINER_5_2_IMAGE" "$IMAGE_5_2"
build_docker "$CONTAINER_5_3_IMAGE" "$IMAGE_5_3"

run_container
cd ../5.3
run_container2 "$IMAGE_5_3" "$CONTAINER_5_3_RUN" 
cleanup