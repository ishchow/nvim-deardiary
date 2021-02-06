# Overview

deardiary is a plugin that makes journaling in neovim easy and convenient.

Features:
- Manage multiple journals
- Set different frequencies of entries per journal (ex. daily, weekly)
- Custom frequencies of journal entries (ex. can add quarterly frequencies)
- Control filesystem paths of new entries
- Templating of new entires

Requirements:
- neovim 0.5+
    - Currently requires latest neovim nightly since 0.5 isn't released yet

# Quickstart

## Installation

deardiary can be installed just like any other neovim plugin.

Plug: 

```
Plug 'ishchow/deardiary'
```

Packer:

``` 
use 'ishchow/deardiary' 
```

## Configuration

Add the following to a file under `$XDG_CONFIG_HOME/nvim/lua` (ex.
~/.config/nvim/lua/diary.lua)

```lua
local config = require("deardiary.config")

config.journals = {
    {
        path = "~/journals/personal",
        frequencies = {"daily", "weekly"},
    },
    {
        path = "~/journals/work",
        frequencies = {"daily", "weekly", "monthly", "yearly"},
    },
}
```

Then, in your init.vim file, add this to use your configuration:

```viml
lua require("diary")
```

## Usage
### Basic Usage
Run the following command to set the active journal from `config.journals`.

`:DearDiarySelectJournal` or `<Leader>js`.

A menu will open up like this:

```
1    ~/journals/personal
2    ~/journals/work
Type in journal index and press <Enter> (empty cancels): 
```

Enter a number to pick the desired journal.

Then, open todays entry using:

`:DearDiaryToday` or `<Leader>jdc`.

Today's entry will be opened in a new buffer and filled with the contents from
a template.

`# Saturday, December 26, 2020`

Save the file and the contents of this buffer will be saved to:

`~/journals/personal/daily/2020/12/26.md`

### Set current journal based on cwd
If the current working directory has a common path prefix with any of the
configured journals, you can automatically using this command:

`:DearDiarySetCurrentJournalCwd` or `<Leader>jsc`

To automatically set the current journal based on the current working
directory upon entering vim, add the following to your init.vim:

```viml
augroup deardiary
    autocmd!
    autocmd VimEnter * lua require("deardiary").set_current_journal_cwd()
augroup end
```

## Commands and Mappings
The following commands and mappings are provided by the plugin. The mappings
simply execute the commands and are provided for convenience.

```vimhelp
:DearDiarySelectJournal | <Plug>(DearDiarySelectJournal) | <Leader>js
    Selects current journal

:DearDiarySetCurrentJournalCwd | <Plug>(DearDiarySetCurrentJournalCwd) |
<Leader>jsc
    Sets the current journal based on the current working directory

:DearDiaryToday | <Plug>(DearDiaryToday) | <Leader>jdc
    Go to entry for today

:DearDiaryTomorrow | <Plug>(DearDiaryTomorrow) | <Leader>jdn
    Go to entry for tomorrow

:DearDiaryYesterday | <Plug>(DearDiaryYesterday) | <Leader>jdp
    Go to entry for yesterday

:DearDiaryThisWeek | <Plug>(DearDiaryThisWeek) | <Leader>jwc
    Go to entry for this week

:DearDiaryNextWeek | <Plug>(DearDiaryNextWeek) | <Leader>jwn
    Go to entry for next week

:DearDiaryLastWeek | <Plug>(DearDiaryLastWeek) | <Leader>jwp
    Go to entry for last week

:DearDiaryThisMonth | <Plug>(DearDiaryThisMonth) | <Leader>jmc
    Go to entry for this month

:DearDiaryNextMonth | <Plug>(DearDiaryNextMonth) | <Leader>jmn
    Go to entry for next month

:DearDiaryLastMonth | <Plug>(DearDiaryLastMonth) | <Leader>jmp
    Go to entry for last month

:DearDiaryThisYear | <Plug>(DearDiaryThisYear) | <Leader>jyc
    Go to entry for this year

:DearDiaryNextYear | <Plug>(DearDiaryNextYear) | <Leader>jyn
    Go to entry for next year

:DearDiaryLastYear | <Plug>(DearDiaryLastYear) | <Leader>jyp
    Go to entry for last year
```

Default mappings can be overriden if a mapping to the mapping name already
exists in your init.vim file.

For example:

```viml
nmap <silent> <Leader>ds <Plug>(DearDiarySelectJournal)
```

To completely disable all default mappings, add the following line to your
init.vim.

```viml
let g:deardiary_use_default_mappings = 0
```

## Documentation

Open the [help file](https://github.com/ishchow/deardiary/blob/main/doc/deardiary.txt)
for complete documentation. Help file contains examples of advanced
configuration such as custom frequencies and templating.

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

After test dependencies are installed, the above command can be used to re-run
tests or you can run tests directly using busted.

`busted`

## Deactivate hererocks

`lua-deactivate`
