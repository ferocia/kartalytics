#!/bin/bash
set -e

if [ -z "$PREPARE_RUBY_SCRIPT_RUN" ]; then
  EXPECTED_RUBY_VERSION=$(cat ./.ruby-version)

  if [[ `ruby --version | grep "ruby ${EXPECTED_RUBY_VERSION}p"` ]]; then
    echo "Already present: ruby-$EXPECTED_RUBY_VERSION" >&2

  else
    if ! [ -x "$(command -v rbenv)" ]; then
      echo '--- Installing rbenv' >&2
      brew update
      brew install rbenv
      export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
      rbenv init
    else
      echo '--- Already present: rbenv' >&2
      rbenv rehash
      rbenv versions
    fi

    if [[ ! `rbenv versions | grep "$EXPECTED_RUBY_VERSION"` ]]; then
      if [[ ! `rbenv install --list | grep "$EXPECTED_RUBY_VERSION"` ]]; then
        echo "--- [Homebrew] Updating rbenv + ruby-build versions" >&2
        brew upgrade rbenv ruby-build
      fi

      echo "--- Installing ruby version: $EXPECTED_RUBY_VERSION" >&2
      rbenv install $EXPECTED_RUBY_VERSION
      rbenv rehash
    fi
  fi

  if [[ ! `gem list bundler | grep "bundler"` ]]; then
    echo 'Installing latest bundler' >&2
    gem install --no-document bundler
  else
    ## each separate version number must be less than 3 digit wide !
    function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
    MINIMUM_BUNDLER_VERSION=$(cat ./.bundler-version)
    CURRENT_BUNDLER_VERSION=$(bundle --version | head -n 1 | cut -f3 -d ' ')

    if [ "$(version "$MINIMUM_BUNDLER_VERSION")" -gt "$(version "$CURRENT_BUNDLER_VERSION")" ]; then
      echo "Minimum bundler expected: $MINIMUM_BUNDLER_VERSION - has $CURRENT_BUNDLER_VERSION. Updating to latest bundler."
      gem install --no-document bundler
    fi
  fi

  echo "--- bundling"
  BUNDLE_OPTIONS=''
  if [ -z "$CI" ]; then
    BUNDLE_OPTIONS='--quiet'
  fi
  if [ -n "$OFFLINE" ]; then
    BUNDLE_OPTIONS="$BUNDLE_OPTIONS --local"
  fi

  bundle $BUNDLE_OPTIONS
  export PREPARE_RUBY_SCRIPT_RUN=true
fi
