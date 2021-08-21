FROM ruby:2.4.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client nodejs poppler-utils

# enable utf8 in irb
ENV LANG C.UTF-8

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

EXPOSE 5000
