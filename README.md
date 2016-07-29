# Simple Vim Notes
A simple note cli bash script

## Installation
Avoid using relative or "~/" home operator in paths. Instead use $HOME instead of "~/".

`bash <(curl -s -m 10 https://raw.githubusercontent.com/wenn/vim-notes/master/install.bash)`

## Usage
- `notes` edit last note
- `notes <name|number>` edit a note
- `notes rm <name|number>` delete a note
- `notes mv <name|number> <new name>` rename a note
- `notes view|v <name|number>` cat a note
- `notes list|l` list notes
- `notes prompt|p` interactive prompt
- `notes cat|c` concatenate all notes

## Git Sync
Sync notes between machines with Git.

1. Create a repo for storing notes with any name on a Git host ( Github or Bitbucket )
2. Make sure you have ssh key store on the Git host; [Using ssh uri](https://help.github.com/articles/generating-an-ssh-key/)
3. Copy repo's ssh uri, e.g: git@bitbucket.org:username/notes-store.git
4. Update variable **NOTES\_GIT\_URL** in **$NOTES\_ROOT\_PATH/.config**: ~/.notes/.confg
5. Run `note-sync`
