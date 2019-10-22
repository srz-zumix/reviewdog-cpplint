#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ -n "${INPUT_DEBUG}" ]; then
    # env
    echo "cpplint option"
    echo "  flags   : ${INPUT_FLAGS}"
    echo "  targets : ${INPUT_TARGETS}"
    echo "reviewdog option"
    echo "  reporter: ${INPUT_REPORTER}"
    echo "  level   : ${INPUT_LEVEL}"
    echo "  options : ${INPUT_REVIEWDOG_OPTIONS}"

    # echo "cpplint: ${INPUT_FLAGS} ${INPUT_TARGETS}"
    # cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1
fi

function reviewdog_cpplint() {
    if [ -n "${INPUT_DEBUG}" ]; then
        echo "cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
          | reviewdog -efm="%f:%l: %m" -name="cpplint" "$1" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}" "${INPUT_REVIEWDOG_OPTIONS}""
    fi
    cpplint ${INPUT_FLAGS} ${INPUT_TARGETS} 2>&1 \
      | reviewdog -efm="%f:%l: %m" -name="cpplint" "$1" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}" "${INPUT_REVIEWDOG_OPTIONS}"
}

if [ "${INPUT_REPORTER}" = "local" ]; then
    if [ "`echo ${INPUT_REVIEWDOG_OPTIONS}} | grep "-diff"`" ]; then
        reviewdog_cpplint
    else
        reviewdog_cpplint "-diff=""git diff origin/${GITHUB_BASE_REF}"""
    fi
else
    reviewdog_cpplint
fi
