#!/usr/bin/env bash
echo "--- [script:spec]"
. ./script/prepare_ruby.sh

echo "--- Run specs"
bundle exec rspec spec/
