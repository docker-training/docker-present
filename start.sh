docker rm -f $(docker ps -q)
docker rm -f present

docker run --name present -ti \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd)/../presentations/:/tmp/src \
    -v $(pwd)/present/css/docker.css:/opt/revealjs/css/theme/docker.css \
    -v $(pwd)/present/css/docker-code.css:/opt/revealjs/lib/css/docker-code.css \
    -v $(pwd)/present/css/sd_custom.css:/opt/revealjs/css/sd_custom.css \
    -v $(pwd)/present/css/print:/opt/revealjs/css/print/ \
    -v $(pwd)/present/templates/index.html:/opt/revealjs/index.html \
    -v $(pwd)/present/fonts:/opt/revealjs/fonts/ \
    -v $(pwd)/present/images:/opt/revealjs/images/ \
    training/docker-present -p 8000

# -v $(pwd)/../presentations/presentations/:/opt/revealjs/src/presentations/custom \