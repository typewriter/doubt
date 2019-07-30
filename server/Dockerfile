FROM ruby:slim
EXPOSE 8080

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y mecab mecab-ipadic git build-essential

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

COPY . .

ENV MECAB_PATH /usr/lib/x86_64-linux-gnu/libmecab.so.2
CMD ["bundle", "exec", "unicorn", "-E production -c unicorn.conf"]

