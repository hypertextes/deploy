#!/bin/bash

set -e
set -o pipefail

BRANCH="master"
BUILD_DIR="."

if [[ -n "$TOKEN" ]]; then
    GITHUB_TOKEN=$TOKEN
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Invalid GITHUB_TOKEN"
    exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
    echo "Invalid GITHUB_REPOSITORY"
    exit 1
fi

main() {
    REMOTE_REPO="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
    REMOTE_BRANCH=$BRANCH

    echo "Zola: $(zola --version)"
    echo "Sass: $(sass --version)"
    echo "Building directory: $BUILD_DIR"
    echo Building with flags: ${BUILD_FLAGS:+"$BUILD_FLAGS"}

    cd $BUILD_DIR

    zola build ${BUILD_FLAGS:+"$BUILD_FLAGS"}
    sass --style=compressed assets/scss/index.scss public/index.css

    echo "Pushing artifacts to ${GITHUB_REPOSITORY}:$REMOTE_BRANCH"

    cd public
    git init
    git config user.name "GitHub Actions"
    git config user.email "github-actions-bot@users.noreply.github.com"
    git add .

    git commit -m "${GITHUB_REPOSITORY} deployed to $REMOTE_BRANCH"
    git push --force "${REMOTE_REPO}" master:${REMOTE_BRANCH}

    echo "${GITHUB_REPOSITORY} deployed to $REMOTE_BRANCH"
}

main "$@"
