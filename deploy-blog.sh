#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

CONTENT_BRANCH="all_md"
GITHUB_PUBLISH_BRANCH="master"
# Save some useful information
BLOG_REPO="https://github.com/shiva/blog.shiv.me.source.git"
BLOG_BRANCH="master"
BLOG_REPO_WITH_TOKEN=${BLOG_REPO/https:\/\/github.com\//https://${GH_TOKEN}@github.com/}

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$CONTENT_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    exit 0
fi

echo "Clone $BLOG_REPO ..."
git clone $BLOG_REPO blog
cd blog
git checkout $BLOG_BRANCH
git submodule init
git submodule update content

git config user.name "Travis CI"
git config user.email "travis@shiv.me"

echo "Update to latest posts ..."
cd content # descend
git fetch
git checkout all_md
LAST_COMMIT_MSG=`git log -1 --pretty=format:%s`

cd ..   # go to blog-repo. If there are no changes then just bail.
if git diff-index --quiet HEAD --; then
    echo "No changes to the spec on this push; exiting."
    exit 0
fi

echo "Something changed; commit changes to $BLOG_REPO ..."
git add .
git commit -m "sync:${LAST_COMMIT_MSG}"
git push $BLOG_REPO_WITH_TOKEN $BLOG_BRANCH

echo "Done."
