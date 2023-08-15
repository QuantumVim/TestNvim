# TestVim

![Build Status](https://github.com/quantumfate/TestNvim/actions/workflows/install.yaml/badge.svg)

TestVim is a minimal neovim configuration for plugin testing. It behaves like any other neovim instance by utilizing the [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME) feature that was added in [NVIM 0.9.0](https://github.com/neovim/neovim/releases/tag/v0.9.0).

## Features

- no conflicts with existing neovim configuration thanks to [NVIM 0.9.0](https://github.com/neovim/neovim/releases/tag/v0.9.0)
- test plugin functionality in a neovim instance
- automatic cleanup thanks to `/tmp`
- write test cases for specific functions with [Plenary](https://github.com/nvim-lua/plenary.nvim)
- use logging statements in your plugin thanks to [Structlog](https://github.com/Tastyep/structlog.nvim)

## Requirements

- any UNIX like operating system
- [NVIM 0.9.0](https://github.com/neovim/neovim/releases/tag/v0.9.0) _See [I don't have NVIM v.0.9](#i-dont-have-nvim-v09) for earlier versions_

## Install

The [install script](./scripts/install) clones this repository and initializes the minimal neovim configuration for the first time. The [tvim script](./scripts/tvim) will be linked to your path which is the entry point for this tool. The script will backup existing neovim configurations should [NVIM 0.9.0](https://github.com/neovim/neovim/releases/tag/v0.9.0) not be satisfied.

- clone with https

```bash
bash <(curl -s https://raw.githubusercontent.com/quantumfate/TestVim/main/scripts/install)
```

- clone with ssh

```bash
bash <(curl -s https://raw.githubusercontent.com/quantumfate/TestVim/main/scripts/install) --ssh
```

## Usage

I recommend to create a branch for each plugin you are developing to keep the main branch clean for any updates. Read more about [Git Workflows](https://docs.github.com/en/get-started/quickstart/github-flow).

- print the help message to see the full capabilities of the script

```bash
tvim -h
```

### I don't have NVIM v.0.9

Run the script with `nvim` as an app name. Note: This is going to conflict with any neovim configuration in `~/.config/nvim`.

```bash
tvim --appname 'nvim'
```

### Run TestVim

Run neovim in headful mode to test your plugin functionality. This will initialize the runtime files in `/tmp` which are reused between subsequent calls of the script.

```bash
tvim
```

#### You like what you see?

Freeze the most recent state of the `/tmp` directories to neovim's default [standard paths](https://neovim.io/doc/user/starting.html#standard-path) to keep these files after logout.

```bash
tvim --freeze
```

### Run your tests

If you implemented tests for your plugin you can run these with plenary.

```bash
tvim --testing
```

### I don't want to use temp directories

Sometimes it might be inconvenient to have the files in a volatile directory. In that case you can use a persisted session by using neovim's [standard paths](https://neovim.io/doc/user/starting.html#standard-path). Note: Existing directories won't be touched.

```bash
tvim --persist
```

## Developing a plugin

You can use [Structlog](https://github.com/Tastyep/structlog.nvim) calls if the plugin you are currently developing is in any of the runtime paths of TestVim. You probably don't want to push your changes to source control every time you make changes just to install your plugin via a plugin manager.

### Method 1: Symlink your plugin into TestVim (Recommended)

```bash
ln -s /my/cool/plugin $HOME/.config/<appname>/after
```

### Method 2: Develop your plugin in a runtime path (Not recommended)

No seriously, don't do that.

### Usage of structlog

The logs are located in `$HOME/.local/log/<appname>`

```lua
local logger = log.get_logger("tvim")

logger:info("Called a function")
logger:debug(vim.inspect(my_data))
logger:trace(string.format("Something is happening with: %s", my_node))
logger:trace("Who calls this function)

```

## Special Thanks

- [Lazy](https://github.com/folke/lazy.nvim) _For the minimal init.lua_
- [Plenary](https://github.com/nvim-lua/plenary.nvim) _For lua functions I don't want to write twice_
- [Structlog](https://github.com/Tastyep/structlog.nvim) _For less painful logging_
