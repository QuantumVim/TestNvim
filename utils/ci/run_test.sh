#!/usr/bin/env bash
set -eo pipefail

export TESTNVIM_APPNAME=${TESTNVIM_APPNAME:-"tvim"}

profile=${TESTNVIM_USER_PROFILE:-"default"}
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

source "./scripts/vars"
source "./scripts/messages"
function tvim_tmp(){
    mktemp -d --suffix="-${TESTNVIM_APPNAME}-$profile-$1"
}

tmp_log="$(tvim_tmp "log")"
tmp_config="$(tvim_tmp "config")"
tmp_data="$(tvim_tmp "data")"
tmp_cache="$(tvim_tmp "cache")"

export TESTNVIM_LOG_PROFILE=${tmp_log}
export TESTNVIM_CONFIG_PROFILE=${tmp_config}
export TESTNVIM_DATA_PROFILE=${tmp_data}
export TESTNVIM_CACHE_PROFILE=${tmp_cache}

cp -r "${TESTNVIM_STATE_DIR}/utils/conf"/* "${TESTNVIM_CONFIG_PROFILE}"

TESTNVIM_PACK_DIR="${TESTNVIM_DATA_PROFILE}/after/pack/lazy/opt"
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

info_msg "TestNvim configuration:"
compact_info_msg "  Profile: ${TESTNVIM_USER_PROFILE}"
compact_info_msg "  Cache dir: $TESTNVIM_CACHE_PROFILE"
compact_info_msg "  State dir: $TESTNVIM_STATE_DIR"
compact_info_msg "  Data dir: $TESTNVIM_DATA_PROFILE"
compact_info_msg "  Config dir: $TESTNVIM_CONFIG_PROFILE"
compact_info_msg "  Log dir: $TESTNVIM_LOG_PROFILE\n"


if [ -n "$1" ]; then
    test_tvim --headless -c "lua require('plenary.busted').run('$1')"
else
    test_tvim --headless -c "PlenaryBustedDirectory tests/specs { minimal_init = './tests/${init_file}_init.lua' }"
fi
