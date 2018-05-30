#!/bin/bash

set -e

on_exit() {
  exitcode=$?
  if [ $exitcode != 0 ] ; then
    echo -e '\e[41;33;1m'"Failure encountered!"'\e[0m'
  fi
}

trap on_exit EXIT

test() {
  set -e
  base_dir="$(cd "$(dirname $0)" ; pwd )"
  echo "${base_dir}"
  if [ -f "${base_dir}/../out" ] ; then
    cmd="../out"
  elif [ -f /opt/resource/out ] ; then
    cmd="/opt/resource/out"
  fi

cat <<EOM >&2
------------------------------------------------------------------------------
TESTING: $1
Input:
$(cat ${base_dir}/${1}.out)
Output:
EOM

  result="$(cd $base_dir && cat ${1}.out | $cmd . 2>&1 | tee /dev/stderr)"
  echo >&2 ""
  echo >&2 "Result:"
  echo $result > /tmp/tcr-test # doing echo from the function wouldn't work for some reason
}

test everything
cat /tmp/tcr-test | jq -e '
  .body.host == "selenium.grid.com" and
  .body.suite == "blank suite" and
  .body.token == "supersecrettoken" and
  .body.project == "some project" and
  .body.test_plan == "sometestplan" and
  .body.port == "4444" and
  .body.parallel == "3" and
  .body.test_id == "sometestid" and
  .body.label == "somelabel" and
  .body.timeout == "300"
  '

  test no_parallel
  cat /tmp/tcr-test | jq -e '
    .body.host == "selenium.grid.com" and
    .body.suite == "blank suite" and
    .body.token == "supersecrettoken" and
    .body.project == "some project" and
    .body.test_plan == "sometestplan" and
    .body.port == "4444" and
    .body.parallel == "null" and
    .body.test_id == "sometestid" and
    .body.label == "somelabel" and
    .body.timeout == "300"
    '
