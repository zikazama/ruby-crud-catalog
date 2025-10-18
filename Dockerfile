FROM ruby:3.3.6

RUN apt-get update -qq && apt-get install -y     build-essential     libpq-dev     postgresql-client     nodejs     && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

COPY Gemfile* ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
