#!/usr/bin/env sh

set -ex

# echo Scanning with SonarQube...
# if [ "${CODEBUILD_BUILD_SUCCEEDING}" -eq 1 ]; then
#   SONAR_SCANNER_IMAGE="${REGISTRY_URI}/sonar-scanner-cli:latest"
#   set +x
#   docker run --rm \
#     -v ${PWD}:/home/app/webapp -v coverage:/home/app/webapp/coverage ${SONAR_SCANNER_IMAGE} \
#     -Dsonar.projectKey=${GITHUB_REPO} \
#     -Dsonar.organization=interfolio \
#     -Dsonar.host.url=https://sonarcloud.io \
#     -Dsonar.login=${SONAR_TOKEN} \
#     -Dsonar.projectBaseDir=/home/app/webapp \
#     -Dsonar.branch.name=${GIT_BRANCH} \
#     -Dsonar.scm.revision=${GIT_COMMIT} \
#     -Dsonar.pullrequest.key=${GITHUB_PR_KEY} \
#     -Dsonar.pullrequest.base=${GITHUB_PR_BASE} \
#     -Dsonar.pullrequest.branch=${GITHUB_PR_BRANCH} \
#     -Dsonar.pullrequest.provider=GitHub \
#     -Dsonar.pullrequest.github.repository=Interfolio/${GITHUB_REPO} \
#     -Dsonar.sourceEncoding=UTF-8 \
#     -Dsonar.scm.disabled=true \
#     -Dsonar.ruby.coverage.reportPaths=/home/app/webapp/coverage/.swaggerless_resultset.json || true
#   set -x
# fi

echo Pushing the test Docker image...
PUSH_TAGS=$(echo "${COMMIT_TAG} ${NAMED_TAG}" | tr " " "\n" | uniq)
for TAG in ${PUSH_TAGS}; do
  docker push "${REPOSITORY_URI}:test-${TAG}" > /dev/null
done
