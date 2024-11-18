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
  label="$2"
  url="$3"

  if [[ ! -f "$dir/$filename" ]]; then
    echo -e "\e[33mDownloading $filename...\e[0m"
    curl -L "$url" -o "$dir/$filename"
    echo
  else
    echo -e "\e[36mFile $dir/$filename already exists.\e[0m"
  fi

  echo -e "\e[36mSummary of $filename ($label):\e[0m"
  echo
  echo "URL:      $url"
  echo -e "SHA256:   \e[32m$(sha256sum "$dir/$filename" | awk '{print $1}')\e[0m"
}

echo -e "\e[34mChecking SHA256 sums for Redot Engine v$tag...\e[0m"
echo "Directory: $dir"
echo "Tag:       $tag"
echo "Source:    $src_url"
echo "Binary:    $build_url"
echo

echo -e -n "\e[35mWould you like to continue? (Y/n)\e[0m "
read -r answer

if [[ -n "$answer" && "$answer" != "y" ]]; then
  echo -e "\e[31mAborted.\e[0m"
  exit 1
fi

echo
verify_sha256 "$src_filename" "Source code tarball" "$src_url"
echo
verify_sha256 "$build_filename" "Binary taball" "$build_url"
