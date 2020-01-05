cp -n config/database.docker.yml config/database.yml
cp -n config/redis.docker.yml config/redis.yml
cp -n config/local.docker.yml config/local.yml

chmod +x docker-entrypoint.sh

docker-compose build