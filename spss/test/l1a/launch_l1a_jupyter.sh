#!/bin/bash

JUPYTER_PORT=8888

# Source common variables
. $(dirname $0)/../common/setup_env.sh $(dirname $0)

interface_dir=$($READLINK_BIN -f "$(dirname $0)/../../interface")

docker run --rm \
    --user $(id -u $USER) \
    -e HOME=/pge/interface \
    -v ${PGE_IN_DIR}:/pge/in \
    -v ${PGE_OUT_DIR}:/pge/out \
    -v ${interface_dir}:/pge/interface \
    -v ${PGE_STATIC_DIR}/dem:/peate/support/static/dem \
    -v ${PGE_STATIC_DIR}/mcf:/ref/devstable/STORE/mcf \
    -p 127.0.0.1:$JUPYTER_PORT:$JUPYTER_PORT \
    unity-sds/sounder_sips_l1a_pge:${DOCKER_TAG} \
    jupyter notebook --ip 0.0.0.0 --port $JUPYTER_PORT --notebook-dir=/pge/interface