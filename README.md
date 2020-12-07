# Overview


# Installation

TODO

# Usage

TODO

# Contributing

## Testing plugin locally
At root of repo, run

`nvim --cmd "set rtp+=$(pwd)" README.md`

## Setup hererocks
```
pip3 install hererocks # use sudo if this doesn't work
hererocks -j 2.1.0-beta3 -r latest env
source env/bin/activate
luarocks install busted penlight
```

## Run tests

Ensure `VIMRUNTIME` enviroment variable is set.

`busted --lpath=lua/?.lua`

## Deactivate hererocks

`lua-deactivate`

