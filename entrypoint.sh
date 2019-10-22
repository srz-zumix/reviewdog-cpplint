#!/bin/sh

cd "${GITHUB_WORKSPACE}"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

function verbose() {
    if [ -n "${INPUT_DEBUG}" ]; then
        echo "$*"
    fi
}

if [ -n "${INPUT_DEBUG}" ]; then
    echo "cpplint option"
    echo "  flags   : ${INPUT_FLAGS}"
    echo "  targets : ${INPUT_TARGETS}"
    echo "reviewdog option"
    echo "  reporter: ${INPUT_REPORTER}"
    echo "  level   : ${INPUT_LEVEL}"
    echo "  options : ${INPUT_REVIEWDOG_OPTIONS}"
    echo "  diff    : ${INPUT_REVIEWDOG_DIFF}"

    cpplint ${INPUT_FLAGS} ${INPUT_TARGETS}
fi

function reviewdog_cpplint() {
    cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
      | reviewdog -efm="%f:%l: %m" -name="cpplint" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}" "${INPUT_REVIEWDOG_OPTIONS}" "$1"
}

if [ -z "${INPUT_REVIEWDOG_DIFF}" ]; then
    if [ "${INPUT_REPORTER}" = "local" ]; then
        if [ -n "${GITHUB_BASE_REF}" ]; then
            export INPUT_REVIEWDOG_DIFF="-diff=""git diff origin/${GITHUB_BASE_REF}"""
        else
            export INPUT_REVIEWDOG_DIFF="-diff=""git diff HEAD^"""
        fi
    fi
fi
if [ -n "${INPUT_REVIEWDOG_DIFF}" ]; then
    verbose "reviewdog cpplint with diff option"
    reviewdog_cpplint "-diff=""${INPUT_REVIEWDOG_DIFF}"""
else
    cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
      | reviewdog -efm="%f:%l: %m" -name="cpplint" -reporter=${INPUT_REPORTER} -level=${INPUT_LEVEL}
fi
