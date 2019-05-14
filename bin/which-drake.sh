#!/bin/bash

DRAKE_VERSION_FILE="${DRAKE_RESOURCE_ROOT}/doc/drake/VERSION.TXT"
if [ -f "${DRAKE_VERSION_FILE}" ]; then
    echo "$(cat ${DRAKE_VERSION_FILE})"
else
    echo "Cannot fetch drake version"
fi
