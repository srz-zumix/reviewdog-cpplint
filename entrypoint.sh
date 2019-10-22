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

function reviewdog_cpplint() {
    cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
      | reviewdog -efm="%f:%l: %m" -name="cpplint" "$1" ${INPUT_REVIEWDOG_OPTIONS} -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}"
}

if [ "${INPUT_REPORTER}" = "local" ]; then
    if [ "`echo ${INPUT_REVIEWDOG_OPTIONS}} | grep -e ""-diff""`" ]; then
        reviewdog_cpplint
    else
        if [ -n "${GITHUB_BASE_REF}" ]; then
            reviewdog_cpplint "-diff=""git diff origin/${GITHUB_BASE_REF}"""
        else
            reviewdog_cpplint "-diff=""git diff HEAD^"""
        fi
    fi
else
    reviewdog_cpplint
fi
