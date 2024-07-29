docker stop $(docker ps -qa --no-trunc) || true
docker rm $(docker ps -qa --no-trunc) || true
docker rmi -f $(docker images -aq) || true
docker system prune -f || true
