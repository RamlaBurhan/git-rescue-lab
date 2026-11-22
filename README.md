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
- A free **GitHub account**
- The **GitHub CLI** (`gh`), logged in with `gh auth login`. Setup uses it to create your backup repo for Task 6. Install it from https://cli.github.com
- A terminal: Mac, Linux, WSL or Git Bash on Windows

Tell Git who you are (one time only):
```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

## The big idea: two repos

| | Think of it as | What's in it |
|---|---|---|
| 📘 **git-rescue-lab** | The **textbook** | The instructions and scripts. You read this. |
| ☕ **brewly** | The **exercise book** | The messy coffee app. You fix this. |

You'll have **your own copy of both** on GitHub.

---

## Start the lab on GitHub (do this once)

These steps set up the lab on **real GitHub**, which is the recommended way.

> 💻 **Want to run it offline on your laptop instead?** Follow **Option B** in **[SETUP.md](SETUP.md)**. SETUP.md also has a quick list of the commands for both ways.

**Step 1: Log in to GitHub** · 💻 *Terminal*
```bash
gh auth login
```
Choose **GitHub.com**, then **HTTPS**, then **Login with a web browser**, and follow the prompts.

**Step 2: Get your own copy of the textbook** · 🌐 *GitHub website*

Go to **https://github.com/RamlaBurhan/git-rescue-lab** (the link I sent you). Near the top right, click the green **Use this template** button, then **Create a new repository**. Call it `git-rescue-lab`.

**Step 3: Download your textbook to your laptop** · 💻 *Terminal*
```bash
git clone https://github.com/<your-username>/git-rescue-lab.git
cd git-rescue-lab
chmod +x *.sh
```
(`chmod +x` lets you run the scripts.)

**Step 4: Create an empty exercise book** · 🌐 *GitHub website*

On github.com, click **New repository** and call it `brewly`. **Don't** tick "Add a README". It must be completely empty.

**Step 5: Fill the exercise book with Dan's mess** · 💻 *Terminal, inside the `git-rescue-lab` folder (where you ended up after Step 3)*

Replace `<your-username>` with your GitHub username:
```bash
./setup.sh --github https://github.com/<your-username>/brewly.git
```
This builds the messy project and puts it on your GitHub. It also creates `brewly-backup`, which you'll need in Task 6.

**Step 6: Go into the exercise book and start** · 💻 *Terminal*
```bash
cd brewly-lab/brewly
git status
```
Then open **[TASKS.md](TASKS.md)** and do Task 1. 🎉

---

**Where do you type each command?**
Everything happens in **one folder**. Open `git-rescue-lab` in VS Code and you'll see:
```
git-rescue-lab/            ← the textbook
├── TASKS.md, CHEATSHEET.md ...
├── check.sh ...
└── brewly-lab/
    └── brewly/            ← the exercise book: do the tasks in here
```
- **Doing a task:** inside `brewly-lab/brewly`
- **Checking your answer:** from the same place, run `./check.sh 1`

> No internet? Run `./setup.sh` on its own in Step 5 and skip Step 4. Everything still works, it just stays on your laptop.

## How it works

1. Open **[TASKS.md](TASKS.md)** and read Task 1.
2. Stuck? Open **[CHEATSHEET.md](CHEATSHEET.md)**. Each task has a toolbox with the command you need hidden among others.
3. Check your work from inside `brewly-lab/brewly`:
   ```bash
   ./check.sh 1       # one task
   ./check.sh all     # everything
   ```
4. Really stuck? **[SOLUTIONS.md](SOLUTIONS.md)** has the answers.
5. Made a mess? Go back to the `git-rescue-lab` folder and run `./setup.sh --github <same-url> --force`. This resets your GitHub `brewly` repo back to the beginning.

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
| 15 | Rebase onto the team's main | 🟠 |
| 16 | Update a branch with merge (spot the difference) | 🟠 |
| 17 | Your first pull request on GitHub | 🔴 |

Finished? Test yourself with **[INTERVIEW-QUESTIONS.md](INTERVIEW-QUESTIONS.md)**.

---

*Mess up `brewly` as much as you like. `--force` puts it back. Only Task 17 touches the lab repo itself.*
