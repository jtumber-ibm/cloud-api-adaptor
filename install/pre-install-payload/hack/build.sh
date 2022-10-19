#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

script_dir=$(dirname "$(readlink -f "$0")")

registry="${registry:-quay.io/confidential-containers/peer-pods-pre-install-payload}"

supported_arches=(
	"linux/amd64"
	"linux/s390x"
)

function build_preinstall_payload() {
    pushd "${script_dir}/.."

    tag=$(date +%Y%m%d%H%M%s)

    platform=$(IFS=, ; echo "${supported_arches[*]}")

    docker buildx build \
        --push \
        --platform ${platform} \
        --tag "${registry}:${tag}" --tag "${registry}:latest" -f Dockerfile \
        .

    popd
}

function main() {
	build_preinstall_payload
}

main "$@"
