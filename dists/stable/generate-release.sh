#!/bin/sh
set -e

do_hash() {
    HASH_NAME=$1
    HASH_CMD=$2
    echo "${HASH_NAME}:"
    for f in $(find -type f); do
        f=$(echo $f | cut -c3-) # remove ./ prefix
        if [ "$f" = "Release" ]; then
            continue
        fi
        echo " $(${HASH_CMD} ${f}  | cut -d" " -f1) $(wc -c $f)"
    done
}

cat << EOF
Origin: Test Repo
Label: Test
Suite: stable
Codename: stable
Version: 1.0
Architectures: amd64
Components: main
Description: An example software repository
Date: $(date -Ru)
EOF
do_hash "MD5Sum" "md5sum"
do_hash "SHA1" "sha1sum"
do_hash "SHA256" "sha256sum"

cat ~/projelerimiz2/yazilim/bash/apt_repo_test/apt-repo/dists/stable/Release | gpg --default-key "Muhammet Halak" -abs --clearsign > ~/projelerimiz2/yazilim/bash/apt_repo_test/dists/stable/InRelease

cat ~/projelerimiz2/yazilim/bash/apt_repo_test/dists/stable/Release | gpg --default-key "Muhammet Halak" -abs > ~/projelerimiz2/yazilim/bash/apt_repo_test/dists/stable/Release.gpg

echo "deb [arch=amd64 signed-by=$HOME/example/pgp-key.public] http://127.0.0.1:8000/apt-repo stable main" | sudo tee /etc/apt/sources.list.d/example.list

sudo echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/Release.gpg] https://halak0013.github.io/apt_repo_test/ stable main" | sudo tee /etc/apt/sources.list.d/testrepo.list