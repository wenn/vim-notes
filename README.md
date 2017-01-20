# Vim Notes
Manage notes with vim.

## Setup
`bash <(curl -s -m 10 https://raw.githubusercontent.com/wenn/vim-notes/master/install.bash)`

_Avoid using relative or "~/" home operator in paths. Instead use $HOME instead of "~/"_

## Usage
- `notes` open notes prompt
- `notes view|v <name|number>` cat a note
- `notes last|l` edit last note
- `notes cat|c` concatenate all notes

## Git Sync
Sync notes between machines with Git.


#### Create Repo

1. Create a repo for storing notes with any name on a Git host ( Github or Bitbucket )
2. Make sure you have ssh key store on the Git host; [Using ssh uri](https://help.github.com/articles/generating-an-ssh-key/)
3. Copy repo's ssh uri, e.g: git@bitbucket.org:username/notes-store.git

#### Enable Note Sync

1. Update variable **NOTES\_GIT\_URL** in **$NOTES\_ROOT\_PATH/.config**: ~/.notes/.confg
2. Run `notes-sync`
