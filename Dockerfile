FROM ruby:2.6.5
RUN apt-get update && apt-get install -y default-mysql-client

WORKDIR /otwa
COPY Gemfile .
COPY Gemfile.lock .
RUN gem install bundler -v 1.17.3 && bundle install

COPY . .

# runs rake commands on start
ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 3000

# start the main process
CMD ["bundle", "exec", "rails", "s", "-p", "3000"]
