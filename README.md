# Daily Notes

A simple bash-based daily notes system backed by git.

## Folder Structure

Notes live at `daily/YYYY/MM/DD/main.md`. Each day's folder is created automatically when you open that day's notes.

## Note Format

```markdown
# March 18, 2026

## Todo ✓

- x Buy groceries
- x Check email
- ✓ Write blog post

## Work Notes

Worked on XYZ project, had a meeting with the team, etc.

## Personal Project notes

Discovered a new library, made progress on my side project, etc.
```

_Copy the ✓ from the todo header to mark items as done. The script will automatically carry over any incomplete (prefixed with a `- x`) items to the next day._

## Setup

1. Clone or init a git repo (I recommend a private one for personal notes)
2. Place `Taskfile.sh` at the root
3. Run `./Taskfile.sh notes` to create your first day

## Commands

Run with `./Taskfile.sh <command>`:

| Command | Description |
|---|---|
| `next` | Commit yesterday's notes to git, then open today's |
| `notes` | Create today's note file and open it |
| `commit` | Stage and push all changes to git |
| `open-last-week [n]` | Open notes from `n` weeks ago (default: 1) |

## Daily Workflow

1. Start your day by running:
   ```bash
   ./Taskfile.sh next
   ```
2. This commits whatever you wrote yesterday and opens a fresh `main.md` for today, pre-filled with your incomplete todos from the day before.
3. Write notes and todos throughout the day.
4. Include any interesting links or other files in the same folder (e.g. `daily/2026/03/18/links.md`).
5. Repeat tomorrow.

## Extending

The script has commented placeholders for adding more note sections (e.g. `projects/`, `work/`). Look for the comments in `commit` and at the bottom of `Taskfile.sh`.

## Further Reading

The Taskfile is based on [Adrian Cooney's Taskfile](https://github.com/adriancooney/Taskfile). See this repo for tips but I recommend using `task` not `run` for any aliases, as you can see in my [dotfiles](https://github.com/zinefer/dotfiles/blob/f40c0bc2840badf9a41954c935be49b8db52c803/fish/config/functions/task.fish)