# syntax = docker/dockerfile:experimental

FROM ruby:2.7.1 AS sinatra
# Sinatra default port
EXPOSE 4567

# add the files for the ruby server
WORKDIR /src/
COPY ./config.ru /src/
COPY ./Gemfile /src/
Copy ./myWebApp.rb /src/
Copy ./exportGitHubToken.sh /src/

RUN bundle install

# start second stage of multi stage build
FROM docker.pkg.github.com/beyondcode/expose/expose-server:1.3.2 AS final

# Expose dashboard port
EXPOSE 4040

WORKDIR /src/

# get secrets for expose
RUN --mount=type=secret,id=expose_token,dst=/run/secrets/expose_token.txt php expose token $(cat /run/secrets/expose_token.txt)

# use the build artifact from sinatra stage
COPY --from=sinatra . /

RUN bundle update
ENV PATH="${PATH}:/usr/local/bundle/bin"
# get secrets for github
RUN --mount=type=secret,id=github_access_token,dst=/run/secrets/github_access_token.txt export SECRET_TOKEN=$(cat /run/secrets/github_access_token.txt)

CMD php expose share localhost:4567 --subdomain=webhooktest & bundle exec rackup --host 0.0.0.0 -p 4567

# combined build settings
# DOCKER_BUILDKIT=1 docker build \
# --secret id=expose_token,src./expose_token \
# id=github_access_token,src=./github_access_token.txt \
# --progress=plain \
# --no-cache \
# --force-rm
# -t test_combined_server \
# .

# combined build one line
# DOCKER_BUILDKIT=1 docker build --secret id=github_access_token,src=./github_access_token.txt --secret id=expose_token,src=./expose_token.txt --progress=plain --no-cache --force-rm -t test_combined_server .
# DOCKER_BUILDKIT=1 docker build --secret id=github_access_token,src=./github_access_token.txt --secret id=expose_token,src=./expose_token.txt --progress=plain -t test_combined_server .


# combined run settings
# DOCKER_BUILDKIT=1 docker run --publish=127.0.0.1:4040:4040 --publish=127.0.0.2:8080:4567 test_combined_server
