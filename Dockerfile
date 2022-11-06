FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /app
WORKDIR /app 

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

ENV BUNDLER_VERSION=2.1.4

RUN gem update --system && \
    gem install bundler:2.1.4 && \
    gem install rake:13.0.6 && \
    bundle install

COPY . /app

# Add a script to be executed every time the container starts
COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
CMD sh docker-entrypoint.sh