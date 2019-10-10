#!/usr/bin/env bash
if [ -z "$PREPARE_BASH_RUN" ]; then
  echo "--- [script:bash]"
  set -e

  [ -z "$CI_DEBUG" ] || set -x
  [ -z "$CI" ] || set -v

  export PREPARE_BASH_RUN=true
fi
