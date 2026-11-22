# 🧰 Git Cheat Sheet

Each task has a toolbox. **One command in each toolbox is the one you need.** The others are real, useful commands, so read them all. That's how you learn the options.

`<things in angle brackets>` are placeholders. Replace them, including the `< >`.
Example: `git switch <branch>` becomes `git switch main`.

---

## 🔑 Every-day commands (use these all the time)

| Command | What it does |
|---|---|
| `git status` | Shows which branch you're on, what has changed and what's staged. **Run it constantly.** |
| `git log` | Shows the commit history (full detail) |
| `git log --oneline` | The history with one short line per commit |
| `git diff` | Shows changes you haven't staged yet |
| `git branch` | Lists your branches. The one with `*` is where you are. |

**Words to know**
- **Working folder**: the files you edit
- **Staging area**: changes you've chosen to go into the next commit (`git add` puts them there)
- **Commit**: a saved snapshot with a message
- **Branch**: a separate line of work
- **origin**: the shared copy, like GitHub
- **Hash**: a commit's ID, like `1c77f6a`. You can copy just the first 7 characters.

---

## 👀 How to read `git log --oneline`

This is the first thing you'll see in the lab:

```
06436d2 (HEAD -> main) Update README
8d1ea27 (origin/main) Add contributing guide
25bdbed Update greeting
94f1cea (tag: v1.0) Add more menu items
```

Each line is **one commit**: `<short hash> (labels) <message>`. The newest commit is at the top.

The labels in brackets tell you **where things point**:

| Label | What it means |
|---|---|
| `HEAD` | **You are here.** The commit you're currently on. |
| `HEAD -> main` | You're on the branch `main`, and `main` is at this commit |
| `main` | Your **local** branch, on your laptop |
| `origin/main` | Where `main` was on **GitHub** (origin) the last time you talked to it |
| `HEAD -> main, origin/main` | Your `main` and GitHub's `main` are the **same**, so you're in sync ✅ |
| `tag: v1.0` | A permanent name stuck on one commit, usually a release |
| `origin/feature/x` | A branch that exists on GitHub |
| `backup/main` | `main` on a **second** remote called `backup` (Task 6) |

**Reading the example above:**
- You're on `main` at `06436d2`.
- GitHub's `main` is one commit behind, at `8d1ea27`.
- So you have **1 commit that isn't pushed yet** ("Update README"). `git status` says the same: *"Your branch is ahead of 'origin/main' by 1 commit"*.

**Watch the labels move**
```
After you commit:   0b84403 (HEAD -> main) Add Amina to team
                    8d1ea27 (origin/main) Add contributing guide   ← GitHub is behind

After you push:     0b84403 (HEAD -> main, origin/main) Add Amina to team   ← in sync
```

**Good to know**
- `master` vs `main`: they're just names. Older repos call the main branch `master` and newer ones call it `main`. `HEAD -> master` means exactly the same thing.
- `origin/main` only updates when you `fetch`, `pull` or `push`. It isn't live. It's the last thing you heard from GitHub.
- No `HEAD ->` arrow, just `(HEAD)`? That's a **detached HEAD**: you're looking at an old commit, not a branch. Run `git switch main` to go back.
- Want to see every branch as a picture? Run `git log --oneline --graph --all`.
- On real GitHub it works **exactly the same**. Only the address of `origin` changes. (Run `git remote -v` to see where origin points.)

---

## Task 1: Your first commit

| Command | What it does |
|---|---|
| `git add <file>` | Stages one file for the next commit |
| `git add .` | Stages **every** changed file in the folder |
| `git commit -m "<message>"` | Saves the staged changes as a commit with a message |
| `git commit` | Same, but opens an editor for you to type the message |
| `git restore <file>` | ⚠️ Throws away your changes to a file |
| `git restore --staged <file>` | Un-stages a file. The changes stay in the file. |
| `git rm <file>` | Deletes a file and stages the deletion |

---

## Task 2: Push to origin

| Command | What it does |
|---|---|
| `git push` | Sends your commits to origin, for a branch that's already linked |
| `git pull` | Downloads the team's new commits and merges them into your branch |
| `git fetch` | Downloads new commits but **doesn't** change your branch |
| `git remote -v` | Shows where origin points |
| `git status` | Tells you if you're "ahead of origin" (you have commits to push) |

---

## Task 3: Stash unfinished work

| Command | What it does |
|---|---|
| `git stash` | Puts all your uncommitted changes to one side and cleans your folder |
| `git stash -m "<note>"` | Same, with a note so you remember what it was |
| `git stash list` | Shows everything you've stashed |
| `git stash pop` | Brings back the latest stash and removes it from the list |
| `git stash apply` | Brings back the latest stash and **keeps** it in the list |
| `git stash drop` | ⚠️ Deletes the latest stash |

---

## Task 4: Fix a commit message

| Command | What it does |
|---|---|
| `git switch <branch>` | Moves you to another branch |
| `git commit -m "<message>"` | Makes a **new** commit |
| `git commit --amend -m "<message>"` | **Replaces** your last commit with one that has the new message |
| `git commit --amend` | Same, but opens an editor for the message |
| `git log -1` | Shows only the latest commit |
| `git show` | Shows the latest commit and exactly what it changed |

💡 Only amend commits you **haven't pushed** yet.

---

## Task 5: Create and push a branch

| Command | What it does |
|---|---|
| `git branch <name>` | Creates a branch but **doesn't** move you to it |
| `git switch <name>` | Moves you to an existing branch |
| `git switch -c <name>` | **Creates** a branch and moves you to it in one step |
| `git branch -d <name>` | Deletes a branch (only if it's been merged) |
| `git push` | Pushes a branch that's already linked to origin |
| `git push -u origin <name>` | Pushes a **new** branch and links it (`-u` = set upstream) |
| `git branch -vv` | Shows which origin branch each branch is linked to |

---

## Task 6: Push to a second remote

| Command | What it does |
|---|---|
| `git remote -v` | Lists your remotes and their addresses |
| `git remote add <name> <address>` | Adds a new remote with a name you choose |
| `git remote remove <name>` | Removes a remote (only the link, not the repo) |
| `git remote rename <old> <new>` | Renames a remote |
| `git push` | Pushes to the branch's linked remote (usually origin) |
| `git push <remote> <branch>` | Pushes a branch to **a specific remote** |
| `git ls-remote <remote>` | Lists the branches on a remote, straight from the terminal |
| `cat <file>` | Prints a file in the terminal (handy for reading a saved link) |

💡 Addresses look like `https://github.com/user/repo.git` or `git@github.com:user/repo.git`. GitLab and Bitbucket URLs work exactly the same way.

**Where you'll meet more than one remote at work**
- **Forks:** `origin` = your fork, `upstream` = the original project you pull updates from
- **Backups or mirrors:** the same project on GitHub *and* GitLab
- **Deploys:** some hosting platforms deploy when you push to their remote

---

## Task 7: Finish a teammate's branch

| Command | What it does |
|---|---|
| `git branch` | Lists **local** branches only |
| `git branch -r` | Lists **remote** branches only |
| `git branch -a` | Lists **all** branches, local and remote |
| `git fetch` | Downloads new branches and commits from origin, **without** changing your files |
| `git pull` | Fetch **and** merge into the branch you're on |
| `git switch <branch>` | If the branch only exists on origin, creates a local copy that tracks it |
| `git push` | Pushes a branch that's already linked |
| `git push --force` | ⚠️ Overwrites the remote branch. ❌ Never on someone else's branch. |

---

## Task 8: Bring back a deleted file

| Command | What it does |
|---|---|
| `git log --oneline` | The history of the whole project |
| `git log --oneline -- <file>` | The history of **one file** only |
| `git show <hash>` | Shows what a commit changed |
| `git checkout <hash> -- <file>` | Brings back a file **exactly as it was** in that commit |
| `git restore <file>` | Undoes changes to a file that still exists |
| `git add <file>` then `git commit -m "<message>"` | Saves it |

💡 The `--` means "file names come after this".

---

## Task 9: Fix a merge conflict

| Command | What it does |
|---|---|
| `git merge <branch>` | Brings another branch's work into the branch you're on |
| `git status` | During a conflict, lists the files marked "both modified" |
| `git diff` | Shows the conflict |
| `git add <file>` | Tells Git "I've fixed this file" |
| `git commit` | Finishes the merge (the message is already written, so just save and close) |
| `git merge --abort` | 🆘 Cancels the merge and goes back to before you started |

**Conflict markers**
```
<<<<<<< HEAD          ← your branch's version starts here
...
=======               ← divider
...
>>>>>>> other-branch  ← the other branch's version ends here
```
Edit the file so it looks exactly how you want, **delete all three marker lines**, then add and commit.

---

## Task 10: Undo a pushed commit

| Command | What it does |
|---|---|
| `git log --oneline -- <file>` | Find the commit that changed a file |
| `git revert <hash>` | Makes a **new** commit that undoes that commit. ✅ Safe for shared branches. |
| `git reset --hard <hash>` | ⚠️ Deletes commits. ❌ Never use it on shared branches. |
| `git restore <file>` | Undoes uncommitted changes only |
| `git push` | Sends your fix to origin |

💡 If an editor opens after `revert`, the message is already written. Just save and close. In vim, type `:wq` and press Enter.

---

## Task 11: Copy one commit

| Command | What it does |
|---|---|
| `git log --oneline <branch>` | Shows the commits on another branch without switching to it |
| `git merge <branch>` | Brings in **all** of a branch's commits |
| `git cherry-pick <hash>` | Copies **one** commit onto the branch you're on |
| `git revert <hash>` | Undoes a commit |
| `git show <hash>` | Peeks inside a commit before you copy it |

---

## Task 12: Throw away local commits

`HEAD` means "where I am now". `HEAD~1` means one commit back, and `HEAD~2` means two commits back.

| Command | What it does |
|---|---|
| `git reset --soft HEAD~2` | Removes the last 2 commits. Their changes stay **staged**. |
| `git reset HEAD~2` | Removes the last 2 commits. Their changes stay in your files, **unstaged**. |
| `git reset --hard HEAD~2` | Removes the last 2 commits **and throws away their changes** |
| `git revert <hash>` | Adds a new commit that undoes one (for shared branches) |
| `git log --oneline -3` | Shows only the last 3 commits |

💡 `reset` is only OK on branches **nobody else has**.

---

## Task 13: Squash messy commits

| Command | What it does |
|---|---|
| `git log --oneline -5` | Counts how many commits you want to squash |
| `git reset --soft HEAD~4` | Removes the last 4 commits but keeps all their changes **staged** |
| `git reset --hard HEAD~4` | ⚠️ Removes the last 4 commits **and their code** |
| `git commit -m "<message>"` | Saves everything that's staged as one new commit |
| `git rebase -i HEAD~4` | (Advanced) Opens a list where you can mark commits to squash |

💡 Think it through: which reset keeps the code, and what do you do straight after it?

---

## Task 14: Undo a merge

| Command | What it does |
|---|---|
| `git log --oneline --merges` | Shows only the merge commits |
| `git revert <hash>` | Undoes a normal commit. On a merge, Git says you need `-m`. |
| `git revert -m 1 <hash>` | Undoes a **merge** and keeps parent 1 (the branch it was merged into) |
| `git reset --hard <hash>` | ⚠️ Deletes history. ❌ Never use it on shared branches. |
| `git push` | Sends your fix to origin |

---

## Task 15: Rebase onto the team's main

| Command | What it does |
|---|---|
| `git fetch` | Downloads the team's new commits and updates `origin/main`. Your branches don't change. |
| `git pull` | Fetch **and** merge into the branch you're on |
| `git log --oneline --graph --all` | Draws all the branches, so you can see where yours started |
| `git rebase origin/main` | Replays **your** commits on top of the latest `origin/main` (new commit IDs) |
| `git rebase --continue` | Carries on after you've fixed a conflict during a rebase |
| `git rebase --abort` | 🆘 Cancels the rebase and puts everything back |
| `git push -u origin <branch>` | Pushes a **new** branch and links it |

💡 **Fetch first, then rebase.** `origin/main` is only as fresh as your last `fetch`.

💡 You'll often meet rebase in a team in another place too. If `git push` is **rejected** because someone pushed first, `git pull --rebase` puts your commits on top of theirs. Then `git push` works.

---

## Task 16: Update a branch with merge

| Command | What it does |
|---|---|
| `git merge origin/main` | Brings the latest `origin/main` **into** the branch you're on, with a merge commit |
| `git merge --abort` | 🆘 Cancels the merge |
| `git rebase origin/main` | Not this time 😉 |
| `git log --oneline --graph -5` | Shows the "bubble" where the two lines join |
| `git log --oneline --merges` | Lists only the merge commits |
| `git push -u origin <branch>` | Pushes a **new** branch and links it |

**Fast-forward vs merge commit**
- **Fast-forward**: the branch you're merging into hasn't moved, so Git just slides it forward. No merge commit.
- **Merge commit**: both sides have new commits, so Git ties them together with a commit that has **two parents**.

---

## Task 17: Your first pull request

**In the terminal**

| Command | What it does |
|---|---|
| `git pull` | Gets the latest `main` from GitHub before you start |
| `git switch -c <name>` | Creates your branch and moves you to it |
| `git add <file>` then `git commit -m "<message>"` | Saves your change |
| `git push` | Pushes a branch that's already linked |
| `git push -u origin <name>` | Pushes a **new** branch to GitHub and links it |
| `git branch -d <name>` | Deletes a local branch once it's merged |

**On github.com**

| Button / tab | What it's for |
|---|---|
| **Compare & pull request** | Starts a PR from the branch you just pushed |
| **base: main ← compare: your-branch** | Where the change is going ← where it comes from |
| **Conversation** | Where you discuss and review the PR |
| **Files changed** | The diff. Click `+` on a line to comment. |
| **Merge pull request** | Merges the branch into `main` on GitHub |
| **Delete branch** | Tidies up the branch on GitHub after merging |

💡 A good PR has a clear title, a short "what and why" description, and a small focused change.
