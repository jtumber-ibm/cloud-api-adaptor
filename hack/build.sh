#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

script_dir=$(dirname "$(readlink -f "$0")")

registry="${registry:-quay.io/confidential-containers/cloud-api-adaptor-${CLOUD_PROVIDER}}"

if [[ "$CLOUD_PROVIDER" == "ibmcloud" ]]; then
	supported_arches=(
        "linux/amd64"
        "linux/s390x"
    )
else
	supported_arches=(
        "linux/amd64"
    )
fi

function build_caa_payload() {
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
    build_caa_payload
    # TODO: kustomize with the tag
}

main "$@"
