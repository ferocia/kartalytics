#!/usr/bin/env bash
echo "--- [script:bootstrap]"

brew bundle

. ./script/prepare_ruby.sh
