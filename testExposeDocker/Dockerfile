# syntax = docker/dockerfile:experimental
FROM docker.pkg.github.com/beyondcode/expose/expose-server:1.3.2


RUN --mount=type=secret,id=expose_token,dst=/run/secrets/expose_token.txt php expose token $(cat /run/secrets/expose_token.txt)

# GETS CONTENTS SUCCESSFULLY
#RUN --mount=type=secret,id=expose_token,dst=/run/secrets/expose_token.txt cat /run/secrets/expose_token.txt
#RUN cat /run/secrets/expose_token.txt
WORKDIR /src/



CMD php expose share webHooks4JSONParsing.expose:4567 --subdomain=webhooktest
#DOCKER_BUILDKIT=1 docker build --secret id=github_access_token,src=./github_access_token.txt --secret id=expose_token,src=./expose_token.txt --progress=plain -t expose_test .
#DOCKER_BUILDKIT=1 docker run --publish=127.0.0.1:4040:4040 --publish=127.0.0.2:8080:4567 expose_test
