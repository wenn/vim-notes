# Simple Vim Notes
A simple note cli bash script

## Installation
Avoid using relative or "~/" home operator in paths. Instead use $HOME instead of "~/".

`curl -m 10 -o /tmp/note_install <install url> && bash /tmp/note_install`

## Usage
- `notes` edit last note
- `notes <name|number>` edit a note
- `notes rm <name|number>` delete a note
- `notes view|v <name|number>` cat a note
- `notes list|l` list notes
