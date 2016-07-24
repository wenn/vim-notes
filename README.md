# Simple Vim Notes
A simple note cli bash script

## Installation
Add to _~/.bash_profile_ or _~/.bash_rc_
```
if [[ ! -f ~/.notes/note.bash ]]; then
  curl -o ~/.notes/note.bash <fill-me-on>
  chmod a+x ~/.notes/note.bash
fi
alias notes="~/.notes/note.bash"
```
## Usage
- `notes` edit last note
- `notes <name|number>` edit a note
- `notes rm <name|number>` delete a note
- `notes list|l` list notes
