#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo ${INPUT_FLAGS}
echo ${INPUT_TARGETS}
echo ${INPUT_REPORTER}
echo ${INPUT_LEVEL}
echo ${INPUT_REVIEWDOG_OPTIONS}

function reviewdog_cpplint() {
    cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
    | reviewdog -efm="%f:%l: %m" -name="cpplint" "$1" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}" "${INPUT_REVIEWDOG_OPTIONS}"
}

if [ "${INPUT_REPORTER}" = "local" ]; then
  reviewdog_cpplint '-diff=""git diff""'
else
  reviewdog_cpplint
fi
