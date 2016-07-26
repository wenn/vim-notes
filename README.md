# Simple Vim Notes
A simple note cli bash script

## Installation
Avoid using relative or "~/" home operator in paths. Instead use $HOME instead of "~/".

`bash <(curl -s -m 10 https://github.kdc.capitalone.com/raw/cun824/vim-notes/master/install.bash)`

## Usage
- `notes` edit last note
- `notes <name|number>` edit a note
- `notes rm <name|number>` delete a note
- `notes view|v <name|number>` cat a note
- `notes list|l` list notes
- `notes prompt|p` interactive prompt
