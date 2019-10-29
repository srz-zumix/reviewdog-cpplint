# GitHub Action: Run cpplint with reviewdog

[![Docker Image CI Status](https://github.com/srz-zumix/reviewdog-cpplint/workflows/Docker%20Image%20CI/badge.svg?branch=master)](https://github.com/srz-zumix/iutest/actions)
[![Release](https://img.shields.io/github/release/srz-zumix/reviewdog-cpplint.svg?maxAge=43200)](https://github.com/srz-zumix/reviewdog-cpplint/releases)

[![github-pr-check sample](https://user-images.githubusercontent.com/1439172/67361002-68025080-f5a2-11e9-97b7-530d0531edb4.png)](https://github.com/srz-zumix/reviewdog-cpplint/pull/4)
[![github-pr-review sample](https://user-images.githubusercontent.com/1439172/67361077-9c760c80-f5a2-11e9-98e4-975052cd6fd4.png)](https://github.com/srz-zumix/reviewdog-cpplint/pull/4)


This action runs [cpplint](https://pypi.org/project/cpplint/) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.
Default is `error`.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-pr-review].
Default is `github-pr-check`.

### `flags`

Optional. List of arguments to send to cpplint.
Default is `--extensions=h,hpp,c,cpp,cc,cu,hh,ipp`.

### `targets`

Optional. List of file list arguments to send to cpplint.
Default is `--recursive .`.

## Example Usage

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: Reviewdog
on: [push, pull_request]

jobs:
  cpplint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: srz-zumix/reviewdog-cpplint@master
      with:
        github_token: ${{ secrets.github_token }}
        reporter: github-pr-review
        flags: --linelength=50 # Optional
```
