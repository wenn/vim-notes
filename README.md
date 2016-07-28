# Simple Vim Notes
A simple note cli bash script

## Installation
Avoid using relative or "~/" home operator in paths. Instead use $HOME instead of "~/".

`bash <(curl -s -m 10 https://raw.githubusercontent.com/wenn/vim-notes/master/install.bash)`

## Usage
- `notes` edit last note
- `notes <name|number>` edit a note
- `notes rm <name|number>` delete a note
- `notes mv <name|number>` rename a note
- `notes view|v <name|number>` cat a note
- `notes list|l` list notes
- `notes prompt|p` interactive prompt
- `notes cat|c` concatenate all notes

## Git Sync
You can have notes sync between machines
