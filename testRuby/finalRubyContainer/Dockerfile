# Dockerfile

FROM ruby:2.7.1

WORKDIR /server
COPY . /server

RUN bundle install

EXPOSE 4567

CMD bundle exec rackup --host 0.0.0.0 -p 4567
# docker run -p 127.0.0.2:8080:4567 simple
