#!/usr/bin/env sh

set -ex

GITHUB_DEFAULT_BRANCH='master'
GIT_COMMIT=${CODEBUILD_RESOLVED_SOURCE_VERSION}
if [ "$(echo ${CODEBUILD_WEBHOOK_TRIGGER} | cut -d '/' -f 1)" = "branch" ]; then
  GIT_BRANCH="$(echo ${CODEBUILD_WEBHOOK_TRIGGER} | cut -d '/' -f 2-)"
fi

if [ "$(echo ${CODEBUILD_WEBHOOK_TRIGGER} | cut -d '/' -f 1)" = "pr" ]; then
  GITHUB_PR_KEY=$(echo ${CODEBUILD_WEBHOOK_TRIGGER} | cut -d '/' -f 2-)
  GITHUB_PR_BRANCH=$(echo ${CODEBUILD_WEBHOOK_HEAD_REF} | cut -d/ -f3,4)
  GITHUB_PR_BASE=$(echo ${CODEBUILD_WEBHOOK_BASE_REF} | cut -d/ -f3,4)
fi

echo Pulling cached image...
REPOSITORY_URI="${REGISTRY_URI}/${GITHUB_REPO}"
COMMIT_TAG="commit_${CODEBUILD_RESOLVED_SOURCE_VERSION}"
[ -z "${SOURCE_NAME}" ] && SOURCE_NAME="${CODEBUILD_WEBHOOK_TRIGGER}"
[ -z "${SOURCE_NAME}" ] && SOURCE_NAME="${COMMIT_TAG}"
NAMED_TAG="$(printf "${SOURCE_NAME}" | tr '/' '_')"
DEFAULT_TAG="branch_${GITHUB_DEFAULT_BRANCH}"
for TAG in "${COMMIT_TAG}" "${NAMED_TAG}" "${DEFAULT_TAG}"; do
  IMAGE="${REPOSITORY_URI}:test-${TAG}"
  docker pull "${IMAGE}" > /dev/null || continue
  CACHE_FROM="--cache-from=${IMAGE}"
  break
done
