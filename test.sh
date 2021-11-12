#!/bin/bash
export GITHUB_REPOSITORY="opensafely/dummy_icnarc"
fail=false
echo "testing: $GITHUB_REPOSITORY"
if ! ./check.sh .; then
    echo "success"
else
    echo "failure"
    fail=true
fi

export GITHUB_REPOSITORY="opensafely/dummy_ons"
echo "testing: $GITHUB_REPOSITORY"
if ! ./check.sh .; then
    echo "success"
else
    echo "failure"
    fail=true
fi

export GITHUB_REPOSITORY="opensafely/dummy_icnarc_ons"
echo "testing: $GITHUB_REPOSITORY"
if ./check.sh .; then
    echo "success"
else
    echo "failure"
    fail=true
fi

export GITHUB_REPOSITORY="opensafely/dummy"
echo "testing: $GITHUB_REPOSITORY"
if ! ./check.sh .; then
    echo "success"
else
    echo "failure"
    fail=true
fi

if "$fail" = true; then
    exit 1
fi
