#! /bin/bash

DRAKE_INSTALL_PREFIX=${DRAKE_INSTALL_PREFIX:-/opt/drake}

DRAKE_VENDOR_PACKAGE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)"

EXPECTED_DRAKE_VERSION_FILE="${DRAKE_VENDOR_PACKAGE_ROOT}/drake_version.txt"
read -r EXPECTED_DRAKE_RELEASE_DATE EXPECTED_DRAKE_VERSION < ${EXPECTED_DRAKE_VERSION_FILE}

INSTALLED_DRAKE_VERSION_FILE="${DRAKE_INSTALL_PREFIX}/share/doc/drake/VERSION.TXT"
if [ -d "${DRAKE_INSTALL_PREFIX}" ]; then
    if [ ! -f "${INSTALLED_DRAKE_VERSION_FILE}" ]; then
        echo "${DRAKE_INSTALL_PREFIX} is not empty and it's not a drake installation!"
        exit 1
    fi
    read -r FOUND_DRAKE_RELEASE_DATE FOUND_DRAKE_VERSION < "${INSTALLED_DRAKE_VERSION_FILE}"
    if [ "${FOUND_DRAKE_RELEASE_DATE}" -eq "${EXPECTED_DRAKE_RELEASE_DATE}" ] ||
       [ "${FOUND_DRAKE_VERSION}" -eq "${EXPECTED_DRAKE_VERSION}" ]; then
        exit 0
    fi
fi

echo "Installing drake nightly into '${DRAKE_INSTALL_PREFIX}'"
sudo mkdir -p ${DRAKE_INSTALL_PREFIX}

echo "Downloading drake nightly tarball..."
WHICH_DRAKE_TARBALL_SCRIPT="${DRAKE_VENDOR_PACKAGE_ROOT}/bin/which-drake-tarball.py"
DRAKE_NIGHTLY_URL=$(python3 ${WHICH_DRAKE_TARBALL_SCRIPT} ${EXPECTED_DRAKE_VERSION})
if curl -o /tmp/drake.tar.gz ${DRAKE_NIGHTLY_URL}; then
    echo "Extracting drake nightly tarball..."
    sudo tar xvz -f /tmp/drake.tar.gz -C /opt/drake --strip 1
    echo "Deleting drake nightly tarball..."
    rm /tmp/drake.tar.gz
else
    echo "Failed to pull drake nightly tarball from ${DRAKE_NIGHTLY_URL}"
    exit 1
fi

read -r PULLED_DRAKE_RELEASE_DATE PULLED_DRAKE_VERSION < "${INSTALLED_DRAKE_VERSION_FILE}"
if [ "${PULLED_DRAKE_RELEASE_DATE}" -ne "${EXPECTED_DRAKE_RELEASE_DATE}" ] ||
   [ "${PULLED_DRAKE_VERSION}" -ne "${EXPECTED_DRAKE_VERSION}" ]; then
    cat <<EOF "
Pulled drake nightly version (${PULLED_DRAKE_RELEASE_DATE}:${PULLED_DRAKE_VERSION}) does not
match expected version (${EXPECTED_DRAKE_RELEASE_DATE}:${EXPECTED_DRAKE_VERSION})."
EOF
    exit 1
fi
