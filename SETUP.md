# ⚙️ Setup: choose your mode

Run these from your `git-rescue-lab` folder, and pick **one** option.

---

## Option A: Offline (everything on your laptop)

```bash
cd ~/path/to/git-rescue-lab        # your lab folder
./setup.sh --force                 # build the practice repo
cd ~/brewly-lab/brewly             # go into it
git status                         # start Task 1
```

- **Pushes go to:** a folder on your laptop (`~/brewly-lab/origin.git`)
- **Task 6 backup link:** `cat ~/brewly-lab/backup-url.txt`, which is a folder path
- **Needs:** nothing extra, and no internet

---

## Option B: Real GitHub

```bash
gh auth status                     # already logged in? If not:
gh auth login                      #   GitHub.com → HTTPS → browser

gh repo create brewly --private    # empty brewly repo (or use New repository on the website)

cd ~/path/to/git-rescue-lab
./setup.sh --force --github https://github.com/<your-username>/brewly.git
cd ~/brewly-lab/brewly
git status                         # start Task 1
```

- **Pushes go to:** `github.com/<your-username>/brewly`, so refresh the page to see them
- **Task 6 backup link:** `cat ~/brewly-lab/backup-url.txt`, which will be `https://github.com/<your-username>/brewly-backup.git`. Setup creates that repo for you.
- **Needs:** internet and `gh` logged in (install it from https://cli.github.com or with `brew install gh`)

---

## Same in both modes

| What | Where to run it |
|---|---|
| Doing tasks | `~/brewly-lab/brewly` |
| `./check.sh 1` … `./check.sh all` | your `git-rescue-lab` folder |
| `./teammate-push.sh` (Task 15) | your `git-rescue-lab` folder |
| Start again | the same setup command again (it already has `--force`) |

To switch modes, just run the other option's setup command. `--force` wipes the old one.

💡 **Tip:** open two terminals, one in `git-rescue-lab` for checking and one in `~/brewly-lab/brewly` for doing the tasks.