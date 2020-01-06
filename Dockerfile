FROM ruby:2.6.5
RUN apt-get update && apt-get install -y default-mysql-client netcat

WORKDIR /otwa
COPY Gemfile .
COPY Gemfile.lock .
RUN gem install bundler -v 1.17.3 && bundle install

COPY . .

COPY ./script/docker_web_rails.sh /usr/bin/
RUN chmod +x /usr/bin/docker_web_rails.sh

EXPOSE 3000

CMD ["bash"]
