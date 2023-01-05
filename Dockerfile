FROM ruby:3.0.4

WORKDIR /app
COPY . .

RUN groupadd -g 1053 testuser && useradd -u 1053 -s /bin/false -d /app -g testuser testuser

RUN bundle install

RUN chown -R testuser:testuser .
USER testuser:testuser

CMD rails s -b 0.0.0.0