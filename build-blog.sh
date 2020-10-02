#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Save some useful information
TRAVIS_AUTHOR="Travis CI"
TRAVIS_EMAIL="travis@shiv.me"

CONTENT_BRANCH="all_md"

BLOG_REPO="https://github.com/shiva/blog.shiv.me.source.git"
BLOG_BRANCH="master"

POSTS_REPO="https://github.com/shiva/blog-posts.git"
POSTS_BRANCH="all_md"

GITHUB_PUBLISH_REPO="https://github.com/shiva/shiva.github.io.git"
GITHUB_PUBLISH_REPO_WITH_TOKEN=${GITHUB_PUBLISH_REPO/https:\/\/github.com\//https://${GH_TOKEN}@github.com/}
GITHUB_PUBLISH_BRANCH="master"

LAST_COMMIT_MSG=`git log -1 --pretty=format:%s`

echo "Starting publish for ${LAST_COMMIT_MSG}."
CHECKOUT_DIR=`pwd`

BLOG_DIR=${CHECKOUT_DIR}/blog

echo "Checkout ${BLOG_REPO} ..."
rm -rf ${BLOG_DIR}
git clone --depth=1 --single-branch -b ${BLOG_BRANCH} ${BLOG_REPO} ${BLOG_DIR}

echo "Create symlinks to content"
mkdir -p ${BLOG_DIR}/content/post
cp -R ${CHECKOUT_DIR}/post/* ${BLOG_DIR}/content/post/
ln -s ${CHECKOUT_DIR}/static ${BLOG_DIR}/static

echo "Checkout ${GITHUB_PUBLISH_REPO} ..."
rm -rf public
git clone --depth=1 --single-branch -b ${GITHUB_PUBLISH_BRANCH} ${GITHUB_PUBLISH_REPO} ${BLOG_DIR}/public

echo "Checkout blog theme ..."
cd ${BLOG_DIR}
git submodule update --init themes/HugoTex

echo "Re-generate blog ..."
${CHECKOUT_DIR}/binaries/hugo

echo "Done."
