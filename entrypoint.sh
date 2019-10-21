#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ -n "${INPUT_DEBUG}" ]; then
    echo "cpplint option"
    echo "  flags   : ${INPUT_FLAGS}"
    echo "  targets : ${INPUT_TARGETS}"
    echo "reviewdog option"
    echo "  reporter: ${INPUT_REPORTER}"
    echo "  level   : ${INPUT_LEVEL}"
    echo "  options : ${INPUT_REVIEWDOG_OPTIONS}"
fi

cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
  | reviewdog -efm="%f:%l: %m" -name="cpplint" -diff="git diff" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}" "${INPUT_REVIEWDOG_OPTIONS}"
