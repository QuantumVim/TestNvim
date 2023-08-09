#!/usr/bin/env bash
set -eo pipefail

export TESTNVIM_APPNAME=${TESTNVIM_APPNAME:-"tvim"}

function tvim_tmp(){
    local path
    path=$(mktemp -d --suffix="${TESTNVIM_APPNAME}")
    mkdir -p "${path}/${TESTNVIM_APPNAME}"
    echo "${path}/${TESTNVIM_APPNAME}"
}

init_file="tvim"
disable_appname=false
plenary_url="https://github.com/nvim-lua/plenary.nvim.git"
structlog_url="https://github.com/Tastyep/structlog.nvim.git"

while (( "$#" )); do
    case "$1" in
        --init-file)
            if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
                init_file=$2
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        --disable-appname)
            disable_appname=true
            shift
            ;;
        *)
            PARAMS="$PARAMS $1"
            shift
    esac
done

if [ "$disable_appname" = false ]; then
    export NVIM_APPNAME=${TESTNVIM_APPNAME}
fi

## TODO do we need to set this?
export XDG_STATE_HOME="${XDG_STATE_HOME:-"$HOME/.local/state"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"

export TESTNVIM_LOG_DIR="${TESTNVIM_LOG_DIR:-"$(tvim_tmp)"}"
export TESTNVIM_STATE_DIR="${TESTNVIM_STATE_DIR:-"$XDG_STATE_HOME/$TESTNVIM_APPNAME"}"
export TESTNVIM_CONFIG_DIR="${TESTNVIM_CONFIG_DIR:-"$(tvim_tmp)"}"
export TESTNVIM_DATA_DIR="${TESTNVIM_DATA_DIR:-"$(tvim_tmp)"}"
export TESTNVIM_CACHE_DIR="${TESTNVIM_CACHE_DIR:-"$(tvim_tmp)"}"


cp -r "${TESTNVIM_STATE_DIR}/utils/ci/conf"/* "${TESTNVIM_CONFIG_DIR}"

TESTNVIM_PACK_DIR="${TESTNVIM_DATA_DIR}/after/pack/lazy/opt"
TESTNVIM_PLENARY_DIR="${TESTNVIM_PACK_DIR}/plenary"
TESTNVIM_STRUCTLOG_DIR="${TESTNVIM_PACK_DIR}/structlog"

declare -xr TESTNVIM_PACK_DIR TESTNVIM_PLENARY_DIR TESTNVIM_STRUCTLOG_DIR

# clone the plugins when they don't exist yet
mkdir -p "${TESTNVIM_PACK_DIR}"
if [ ! -d "${TESTNVIM_PLENARY_DIR}" ]; then
    git clone "$plenary_url" "${TESTNVIM_PLENARY_DIR}"
fi
if [ ! -d "${TESTNVIM_STRUCTLOG_DIR}" ]; then
    git clone "$structlog_url" "${TESTNVIM_STRUCTLOG_DIR}"
fi

function test_tvim() {
    # shellcheck disable=SC2086
    nvim -u "${TESTNVIM_STATE_DIR}/tests/${init_file}_init.lua" \
        "$@"
}

echo "appname: $TESTNVIM_APPNAME"
echo "config: $TESTNVIM_CONFIG_DIR"
echo "data: $TESTNVIM_DATA_DIR"
echo "cache: $TESTNVIM_CACHE_DIR"
echo "state: $TESTNVIM_STATE_DIR"
echo "log: $TESTNVIM_LOG_DIR"

if [ -n "$1" ]; then
    test_tvim --headless -c "lua require('plenary.busted').run('$1')"
else
    test_tvim --headless -c "PlenaryBustedDirectory tests/specs { minimal_init = './tests/${init_file}_init.lua' }"
fi
