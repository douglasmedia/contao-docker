# contao-docker
This repository contains files to create container with contao.

# Run Container
docker run -d -p 8080:80 contao-nginx

# Build
If you want to build a specific version you can do so using the following commands:

docker build -t contao-nginx . --build-arg CONTAO_VERSION=4.4

docker build -t contao-nginx