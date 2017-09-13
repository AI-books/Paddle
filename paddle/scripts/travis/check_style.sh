#!/bin/bash
function abort(){
    echo "Your change doesn't follow PaddlePaddle's code style." 1>&2
    echo "Please use pre-commit to check what is wrong." 1>&2
    exit 1
}

trap 'abort' 0
set -e

cd $TRAVIS_BUILD_DIR
export PATH=/usr/bin:$PATH
pre-commit install
clang-format --version

# set up go environment for running gometalinter
mkdir -p $GOPATH/src/github.com/PaddlePaddle/
ln -sf $TRAVIS_BUILD_DIR $GOPATH/src/github.com/PaddlePaddle/Paddle
cd  $GOPATH/src/github.com/PaddlePaddle/Paddle/go; glide install; cd -

if ! pre-commit run -a ; then
    git diff
    exit 1
fi

trap : 0