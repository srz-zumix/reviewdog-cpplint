#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

REVIEWDOG_OPTION=
if [ ${INPUT_REPORTER} = "local" ]; then
    REVIEWDOG_OPTION='-diff "git diff"'
fi

cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
  | reviewdog -efm="%f:%l: %m" -name="cpplint" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}" $REVIEWDOG_OPTION
