#!/usr/bin/env bash
set -euo pipefail

if [ -z "$FORMULA_VERSION_NO_V" ]; then
  echo "missing FORMULA_VERSION_NO_V"
  exit 1
fi
if [ -z "$FORMULA_TGZ_SHA256" ]; then
  echo "missing FORMULA_TGZ_SHA256"
  exit 1
fi

cat <<EOF
# typed: true
# frozen_string_literal: true

# This file was automatically generated. DO NOT EDIT.
class Newt < Formula
  desc "Git worktree manager"
  homepage "https://github.com/cdzombak/newt"
  url "https://github.com/cdzombak/newt/releases/download/v${FORMULA_VERSION_NO_V}/newt-${FORMULA_VERSION_NO_V}-all.tar.gz"
  sha256 "${FORMULA_TGZ_SHA256}"
  license "LGPL-3.0"

  def install
    bin.install "newt"
  end

  test do
    assert_match("${FORMULA_VERSION_NO_V}", shell_output("#{bin}/newt --version"))
  end
end
EOF
