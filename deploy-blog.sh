#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Save some useful information
TRAVIS_AUTHOR="Travis CI"
TRAVIS_EMAIL="travis@shiv.me"

CONTENT_BRANCH="all_md"

GITHUB_PUBLISH_REPO="https://github.com/shiva/shiva.github.io.git"
GITHUB_PUBLISH_REPO_WITH_TOKEN=${GITHUB_PUBLISH_REPO/https:\/\/github.com\//https://${GH_TOKEN}@github.com/}
GITHUB_PUBLISH_BRANCH="master"

LAST_COMMIT_MSG=`git log -1 --pretty=format:%s`

echo "Starting deploy for ${LAST_COMMIT_MSG}."
CHECKOUT_DIR=`pwd`

echo "Check for changes in ${GITHUB_PUBLISH_REPO}"
cd ${CHECKOUT_DIR}/blog/public
if git diff-index --quiet HEAD --; then
    echo "No changes to the spec on this push; Nothing to deploy. exiting."
    exit 0
fi

echo "Something changed; commit changes to ${GITHUB_PUBLISH_REPO} ..."
# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$CONTENT_BRANCH" ]; then
    echo "Not in production env. Skipping commit and deploy; Done."
    exit 0
fi

git config user.name ${TRAVIS_AUTHOR}
git config user.email ${TRAVIS_EMAIL}
git add .
git commit -m "publish: ${LAST_COMMIT_MSG}"
git push ${GITHUB_PUBLISH_REPO_WITH_TOKEN} ${GITHUB_PUBLISH_BRANCH}

echo "Done."
