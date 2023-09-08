#!/bin/sh

arch=$1
shift 1
packages="$*"
for p in $packages; do
    apt-get install -y "$p:$arch"
    files=$(dpkg -L "$p:$arch")
    for file in $files; do
        if [ -f "$file" ]; then
            tar rfv install.tar "${file}"
        fi
    done
done

cp install.tar /output
