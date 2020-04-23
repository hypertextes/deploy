#!/bin/sh

set -e

BRANCH="gh-pages"
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
    ZOLA_VERSION=$(zola --version)
    REMOTE_REPO="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
    REMOTE_BRANCH=$BRANCH

    echo "Starting deploy:"
    echo "  Zola: $ZOLA_VERSION"

    # echo "Fetching themes"
    # git config --global url."https://".insteadOf git://
    # git config --global url."https://github.com/".insteadOf git@github.com:
    # git submodule update --init --recursive

    echo "Building $BUILD_DIR:"
    cd $BUILD_DIR

    echo Building with flags: ${BUILD_FLAGS:+"$BUILD_FLAGS"}
    zola build ${BUILD_FLAGS:+"$BUILD_FLAGS"}

    echo "Pushing artifacts to ${GITHUB_REPOSITORY}:$REMOTE_BRANCH"

    cd public
    git init
    git config user.name "GitHub Actions"
    git config user.email "github-actions-bot@users.noreply.github.com"
    git add .

    git commit -m "Deploy ${GITHUB_REPOSITORY} to ${GITHUB_REPOSITORY}:$REMOTE_BRANCH"
    git push --force "${REMOTE_REPO}" master:${REMOTE_BRANCH}

    echo "Deploy complete"
}

main "$@"