FROM ruby:2.3.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client nodejs

# enable utf8 in irb
ENV LANG C.UTF-8

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
ADD vendor/gems /app/vendor/gems
RUN bundle install

ADD . /app

EXPOSE 5000