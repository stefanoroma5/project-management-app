FROM ruby:3.2.2

WORKDIR /home/pma

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

RUN bundle exec rails db:migrate

CMD ["rails", "server", "-b", "0.0.0.0"]