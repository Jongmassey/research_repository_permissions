#!/bin/bash
export GITHUB_REPOSITORY="opensafely_dummy_icnarc"
echo "testing: $GITHUB_REPOSITORY"
if ! ./check.sh test/study_def_1.py; then
    echo "success"
else
    echo "failure"
fi

export GITHUB_REPOSITORY="opensafely_dummy_ons"
echo "testing: $GITHUB_REPOSITORY"
if ! ./check.sh test/study_def_1.py; then
    echo "success"
else
    echo "failure"
fi

export GITHUB_REPOSITORY="opensafely_dummy_icnarc_ons"
echo "testing: $GITHUB_REPOSITORY"
if ./check.sh test/study_def_1.py; then
    echo "success"
else
    echo "failure"
fi