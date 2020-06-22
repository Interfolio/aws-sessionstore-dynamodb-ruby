#!/usr/bin/env sh

set -ex

echo Building the test Docker image...
docker build . ${CACHE_FROM} \
  --target=test \
  --build-arg="REGISTRY_URI=${REGISTRY_URI}" \
  --tag="${REPOSITORY_URI}:test-${COMMIT_TAG}" \
  --tag="${REPOSITORY_URI}:test-${NAMED_TAG}"

echo Testing...
RUN_OPTIONS="run --rm --net host -e CI=true -e RAILS_ENV=test -v coverage:/home/app/webapp/coverage"
RUN_COMMAND="${REPOSITORY_URI}:test-${COMMIT_TAG} bundle exec"
docker ${RUN_OPTIONS} ${RUN_COMMAND} rake
