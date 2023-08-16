# TestNvim

<div align="center"><p>

<p align="center">
	<a href="https://github.com/quantumfate/TestNvim/stargazers">
		<img alt="Stargazers" src="https://img.shields.io/github/stars/quantumfate/TestNvim?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41">
    </a>
	<a href="https://github.com/quantumfate/TestNvim/releases/tag/v0.0.1">
		<img alt="Releases" src="https://img.shields.io/github/v/release/quantumfate/TestNvim.svg?style=for-the-badge&logo=github&color=F2CDCD&logoColor=D9E0EE&labelColor=302D41"/>
    </a>
	<a href="https://github.com/quantumfate/TestNvim/issues">
		<img alt="Issues" src="https://img.shields.io/github/issues/quantumfate/TestNvim?style=for-the-badge&logo=gitbook&color=B5E8E0&logoColor=D9E0EE&labelColor=302D41">
    </a>
    <a href="https://github.com/quantumfate/TestNvim/pulse">
        <img alt="Last commit" src="https://img.shields.io/github/last-commit/quantumfate/TestNvim?style=for-the-badge&logo=starship&color=cba6f7&logoColor=D9E0EE&labelColor=302D41"/>
    </a>
    <a href="https://github.com/quantumfate/TestNvim/blob/main/LICENSE">
        <img alt="License" src="https://img.shields.io/github/license/lunarvim/lunarvim?style=for-the-badge&logo=starship&color=ee999f&logoColor=D9E0EE&labelColor=302D41" />
    </a>
</p>

</div>

TestNvim is a minimal neovim configuration for plugin testing. It behaves like
any other neovim instance without causing conflicts with other neovim configurations.

## Disclaimer

TestNvim is in early development. Although it seems to work pretty well there might be issues.
In depth documentation follows soon.

## Features

- no conflicts with existing neovim configuration
- test plugin functionality in a minimal neovim instance
- automatic cleanup thanks to `/tmp`
- write test cases for specific functions - [Plenary](https://github.com/nvim-lua/plenary.nvim)
- use logging statements in your plugin - [Structlog](https://github.com/Tastyep/structlog.nvim)

## Requirements

- any UNIX like operating system
- [NVIM 0.8.0](https://github.com/neovim/neovim/releases/tag/v0.8.0)

## Install

The [install script](./scripts/install) clones this repository and initializes
the minimal neovim configuration for the first time.
The [tvim script](./scripts/tvim) will be linked to your path which is the entry
point for this tool.

```bash
bash <(curl -s https://raw.githubusercontent.com/quantumfate/TestVim/main/scripts/install)
```

## Uninstall

```bash
bash <(curl -s https://raw.githubusercontent.com/quantumfate/TestVim/main/scripts/uninstall)
```

## Special Thanks

- [Lazy](https://github.com/folke/lazy.nvim) _For the minimal init.lua and an aweosom package manager_
- [Plenary](https://github.com/nvim-lua/plenary.nvim) _For lua functions I don't want to write twice_
- [Structlog](https://github.com/Tastyep/structlog.nvim) _For less painful logging_
