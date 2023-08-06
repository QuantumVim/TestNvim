export NVIM_APPNAME=${NVIM_APPNAME:-"tvim"}

function tvim_tmp(){
    mktemp -d --suffix="${NVIM_APPNAME}"
}

export TESTNVIM_LOG_DIR="${TESTNVIM_LOG_DIR:-"$(tvim_tmp)"}"
export XDG_STATE_HOME="${TESTNVIM_STATE_DIR:-"$HOME/.local/state"}"
export XDG_CONFIG_HOME="${TESTNVIM_CONFIG_DIR:-"$(tvim_tmp)"}"
export XDG_DATA_HOME="${TESTNVIM_DATA_DIR:-"$(tvim_tmp)"}"
export XDG_CACHE_HOME="${TESTNVIM_CACHE_DIR:-"$(tvim_tmp)"}"
export TESTNVIM_RTP_DIR="${XDG_STATE_HOME}/${NVIM_APPNAME}"

declare -xr TESTNVIM_RTP_DIR TESTNVIM_LOG_FILE TESTNVIM_CONFIG_DIR XDG_STATE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME NVIM_APPNAME

mkdir -p "$XDG_CONFIG_HOME/$NVIM_APPNAME"
mkdir -p "$XDG_DATA_HOME/$NVIM_APPNAME"
cp -r "$XDG_STATE_HOME/$NVIM_APPNAME/utils/conf"/* "$XDG_CONFIG_HOME/$NVIM_APPNAME/"

# clone the plugins when they don't exist yet
mkdir -p "${XDG_DATA_HOME}/${NVIM_APPNAME}/after/pack/lazy/opt"
if [ ! -d "${XDG_DATA_HOME}/${NVIM_APPNAME}/after/pack/lazy/opt/plenary" ]; then
    git clone https://github.com/nvim-lua/plenary.nvim.git "${XDG_DATA_HOME}/${NVIM_APPNAME}/after/pack/lazy/opt/plenary"
fi
if [ ! -d "${XDG_DATA_HOME}/${NVIM_APPNAME}/after/pack/lazy/opt/structlog" ]; then
    git clone https://github.com/Tastyep/structlog.nvim.git "${XDG_DATA_HOME}/${NVIM_APPNAME}/after/pack/lazy/opt/structlog"
fi


function test_tvim() {
    # shellcheck disable=SC2086
    nvim -u "${TESTNVIM_RTP_DIR}/tests/tvim_init.lua" \
        --cmd "set runtimepath+=${XDG_CONFIG_HOME}/${NVIM_APPNAME}" \
        --cmd "set runtimepath+=${TESTNVIM_RTP_DIR}" \
        --cmd "set runtimepath+=${TESTNVIM_RTP_DIR}/site/after" \
        --cmd "set runtimepath+=${TESTNVIM_RTP_DIR}/after" \
        --cmd "set runtimepath+=${XDG_DATA_HOME}/${NVIM_APPNAME}/after/pack/lazy/opt/plenary" \
        --cmd "set runtimepath+=${XDG_DATA_HOME}/${NVIM_APPNAME}/after/pack/lazy/opt/structlog" \
        --cmd "set runtimepath+=${TESTNVIM_CONFIG_DIR}/${NVIM_APPNAME}/" \
        --cmd "set runtimepath+=${TESTNVIM_CONFIG_DIR}/${NVIM_APPNAME}/after" \
        --cmd "set runtimepath+=${TESTNVIM_CONFIG_DIR}/${NVIM_APPNAME}/site/after" \
        "$@"
}

echo "appname: $NVIM_APPNAME"
echo "rtp: $TESTNVIM_RTP_DIR"
echo "config: $XDG_CONFIG_HOME"
echo "data: $XDG_DATA_HOME"
echo "cache: $XDG_CACHE_HOME"
echo "state: $XDG_STATE_HOME"
echo "log: $TESTNVIM_LOG_DIR"

if [ -n "$1" ]; then
    test_tvim --headless -c "lua require('plenary.busted').run('$1')"
else
    test_tvim --headless -c "PlenaryBustedDirectory tests/specs { minimal_init = './tests/tvim_init.lua' }"
fi
