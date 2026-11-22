# ⚙️ Setup: choose your mode

Open your `git-rescue-lab` folder in a terminal, and pick **one** option.

---

## Option A: Real GitHub (recommended)

```bash
gh auth status                     # already logged in? If not:
gh auth login                      #   GitHub.com → HTTPS → browser

gh repo create brewly --private    # empty brewly repo (or use New repository on the website)

./setup.sh --github https://github.com/<your-username>/brewly.git
cd brewly-lab/brewly
git status                         # start Task 1
```

- **Pushes go to:** `github.com/<your-username>/brewly`, so refresh the page to see them
- **Task 6 backup link:** `cat backup-url.txt`, which will be `https://github.com/<your-username>/brewly-backup.git`. Setup creates that repo for you.
- **Needs:** internet and `gh` logged in (install it from https://cli.github.com or with `brew install gh`)

---

## Option B: Offline (everything on your laptop)

```bash
./setup.sh
cd brewly-lab/brewly
git status                         # start Task 1
```

- **Pushes go to:** a folder on your laptop (`brewly-lab/origin.git`)
- **Task 6 backup link:** `cat backup-url.txt`, which is a folder path
- **Needs:** nothing extra, and no internet

---

## Same in both modes

Everything happens inside **`brewly-lab/brewly`**:

| What | Command |
|---|---|
| Do a task | `git ...` commands |
| Check a task | `./check.sh 1` … `./check.sh all` |
| Task 15 | `./teammate-push.sh` |

`check.sh` and `teammate-push.sh` in there are shortcuts to the real scripts. Git ignores them, so they never get committed.

**Start again from scratch:** go back to the `git-rescue-lab` folder and run the same setup command with `--force` on the end.
