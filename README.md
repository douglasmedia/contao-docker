# Contao Docker using managed edition
- Based on php:7.4-fpm-alpine
- Nginx 1.18 Proxy
- PHP 7.4
- Preinstalled composer
- Preconfigured for Contao CMS

# Usage
1. Download or copy the contents of docker-compose.yml
2. Adjust credentials for MySQL
3. Startup Docker with docker-compose up -d
4. Go to http://localhost:8080/contao/install
5. Proceed with 

# Build
If you want to build a specific version you can do so using the following commands:

docker build -t contao . --build-arg CONTAO_VERSION=4.4