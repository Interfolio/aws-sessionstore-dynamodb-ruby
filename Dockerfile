ARG REGISTRY_URI=interfolio

FROM ${REGISTRY_URI}/passenger-ruby:2.4.2 AS dependencies
COPY Gemfile* *.gemspec ./
COPY ./lib/ ./lib/
RUN bundle config --local PATH "vendor/bundle" \
    && bundle install --without development test

FROM dependencies AS test-dependencies
RUN bundle config --delete without \
    && bundle install

FROM test-dependencies AS test
COPY --chown=app . ./
CMD ["bundle", "exec", "rspec"]

FROM test-dependencies AS release
COPY --chown=app . ./
CMD ["bundle", "exec", "rspec"]
