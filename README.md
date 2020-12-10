# Overview


# Installation

TODO

# Usage

TODO

# Contributing

## Testing plugin locally

`nvim --cmd "set rtp+=$(pwd)" README.md`

## Setup hererocks

```
pip3 install hererocks # use sudo if this doesn't work
hererocks -j 2.1.0-beta3 -r latest env
source env/bin/activate
```

## Run tests

Installs test dependencies if not already installed and runs unit tests.

`luarocks test`

## Deactivate hererocks

`lua-deactivate`

