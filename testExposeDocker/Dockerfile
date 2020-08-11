# syntax = docker/dockerfile:experimental
FROM docker.pkg.github.com/beyondcode/expose/expose-server:1.3.2


RUN --mount=type=secret,id=expose_token,dst=/run/secrets/expose_token.txt php expose token $(cat /run/secrets/expose_token.txt)

# GETS CONTENTS SUCCESSFULLY
#RUN --mount=type=secret,id=expose_token,dst=/run/secrets/expose_token.txt cat /run/secrets/expose_token.txt
#RUN cat /run/secrets/expose_token.txt
WORKDIR /src/



CMD php expose share webHooks4JSONParsing.expose:4567 --subdomain=webhooktest
