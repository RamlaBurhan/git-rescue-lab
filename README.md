# ☕ Brewly Git Rescue Lab

A beginner-friendly, hands-on Git lab. There's one story and one messy repo, and you fix it in **17 tasks**, finishing with a real pull request on GitHub. They start very easy and build up slowly. A checker script grades each task.

---

## The story

You've just joined **Brewly**, a small coffee startup. On your first morning the CTO, Priya, sends you a message:

> *"Welcome aboard! 🎉 First, add yourself to the team list. Then I need your help. Dan left last week and the repo is a bit of a mess: the website says we're closed, a discount code is giving away free coffee, a file has gone missing, and Tom is off sick with a branch half-finished. Take it one step at a time. Just remember: **never delete commits from `main`**, because the whole team uses it."*

| Person | Role |
|---|---|
| **Priya Shah** | CTO |
| **Tom Okafor** | Engineer |
| **Dan Mercer** | Left the company… and left the mess |

---

## Before you start

You need:
- **Git** (check with `git --version`)
- A free **GitHub account** (for Task 17)
- A terminal: Mac, Linux, WSL or Git Bash on Windows

Tell Git who you are (one time only):
```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

## Start the lab

**1. Make your own copy on GitHub.** On this repo's page, click **Use this template**, then **Create a new repository**. Give it a name and make it public or private. You need your own copy so you can open a pull request in Task 17.

**2. Clone your copy of the lab:**
```bash
git clone https://github.com/<your-username>/git-rescue-lab.git
cd git-rescue-lab
chmod +x setup.sh check.sh
```

**3. Create an empty `brewly` repo on GitHub.** On github.com click **New repository**, name it `brewly` and **don't** tick "Add a README" (it must be empty). Copy its URL.

**4. Build the practice repo and push it to your GitHub:**
```bash
./setup.sh --github https://github.com/<your-username>/brewly.git
```
GitHub may ask you to log in. The easiest way is to run `gh auth login` first, or to use the SSH URL (`git@github.com:<your-username>/brewly.git`) if you have SSH keys set up.

Refresh your `brewly` page on GitHub. You'll see Dan's messy history and Tom's and Priya's branches. That's your starting point.

> **No internet or no GitHub login?** Run plain `./setup.sh` instead. It uses a stand-in "GitHub" folder on your laptop. All the tasks work the same, you just won't see `brewly` on github.com.

## Two repos: which is which?

| | What it is | Where it lives | Used in |
|---|---|---|---|
| 📘 **The lab** (`git-rescue-lab`) | These instructions + `setup.sh` + `check.sh`. The "textbook". | Your GitHub, cloned to your laptop | Task 17 (your pull request) |
| ☕ **Brewly** (`brewly`) | Dan's messy coffee app, the repo you fix. The "exercise". | Your GitHub (`origin`) and `~/brewly-lab/brewly` on your laptop | Tasks 1–16 |

`setup.sh` creates this on your laptop:
```
~/brewly-lab/
├── brewly/        ← you work here. Its origin is your GitHub brewly repo.
└── backup.git/    ← a second remote, used in Task 6
```

When you `git push` in `brewly`, it goes to **your real GitHub**. Refresh the page after each push to watch your work appear. 👀

Then go into the practice repo and look around:
```bash
cd ~/brewly-lab/brewly
git status
```

## How it works

1. Open **[TASKS.md](TASKS.md)** and read Task 1.
2. Stuck? Open **[CHEATSHEET.md](CHEATSHEET.md)**. Each task has a toolbox with the command you need hidden among others.
3. Check your work from the `git-rescue-lab` folder:
   ```bash
   ./check.sh 1       # one task
   ./check.sh all     # everything
   ```
4. Really stuck? **[SOLUTIONS.md](SOLUTIONS.md)** has the answers.
5. Made a mess? Start again: `./setup.sh --github <same-url> --force`. This resets your GitHub `brewly` repo back to the beginning.

## Tasks

| # | Task | Level |
|---|---|---|
| 1 | Your first commit | 🟢 |
| 2 | Push to origin | 🟢 |
| 3 | Stash unfinished work | 🟢 |
| 4 | Fix a commit message | 🟢 |
| 5 | Create and push a branch | 🟢 |
| 6 | Push to a second remote | 🟢 |
| 7 | Finish a teammate's branch | 🟡 |
| 8 | Bring back a deleted file | 🟡 |
| 9 | Fix a merge conflict | 🟡 |
| 10 | Undo a pushed commit | 🟡 |
| 11 | Copy one commit | 🟡 |
| 12 | Throw away local commits | 🟠 |
| 13 | Squash messy commits | 🟠 |
| 14 | Undo a merge | 🟠 |
| 15 | Rebase, then merge | 🟠 |
| 16 | Merge without rebase (spot the difference) | 🟠 |
| 17 | Your first pull request on GitHub | 🔴 |

Finished? Test yourself with **[INTERVIEW-QUESTIONS.md](INTERVIEW-QUESTIONS.md)**.

---

*Mess up `brewly` as much as you like. `--force` puts it back. Only Task 17 touches the lab repo itself.*
