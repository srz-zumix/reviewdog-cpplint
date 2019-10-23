# GitHub Action: Run cpplint with reviewdog

[![Docker Image CI Status](https://github.com/srz-zumix/reviewdog-cpplint/workflows/Docker%20Image%20CI/badge.svg?branch=master)](https://github.com/srz-zumix/iutest/actions)

This action runs [cpplint](https://pypi.org/project/cpplint/) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-pr-review].
Default is github-pr-check.
github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `flags`

Optional. List of arguments to send to cpplint.
Default is --extensions=h,hpp,c,cpp,cc,cu,hh,ipp.

### `targets`

Optional. List of file list arguments to send to cpplint.
Default is '--recursive .'.

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
