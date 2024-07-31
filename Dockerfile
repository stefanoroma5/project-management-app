FROM ruby:3.2.2

WORKDIR /home/pma

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec rails db:migrate

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]