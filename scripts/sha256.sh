#!/usr/bin/env bash

# Usage: sha256.sh <tag>

if [[ $# -eq 0 ]]; then
  echo "Usage: sha256.sh <tag>"
  exit 1
fi

tag="$1"
dir=/tmp/redot_sha256
mkdir -p $dir

src_filename="redot-${tag}.tar.gz"
src_url="https://github.com/Redot-Engine/redot-engine/archive/refs/tags/$src_filename"
build_filename="Redot_v${tag}_linux.x86_64.zip"
build_url="https://github.com/Redot-Engine/redot-engine/releases/download/redot-${tag}/$build_filename"

verify_sha256() {
  filename="$1"
  url="$2"

  if [[ ! -f "$dir/$filename" ]]; then
    echo -e "\e[33mDownloading $filename...\e[0m"
    curl -L "$url" -o "$dir/$filename"
    echo
  fi

  echo -e "\e[36mSummary of $filename:\e[0m"
  echo "URL:      $url"
  echo "SHA256:   $(sha256sum "$dir/$filename" | awk '{print $1}')"
}

verify_sha256 "$src_filename" "$src_url"
echo
verify_sha256 "$build_filename" "$build_url"
