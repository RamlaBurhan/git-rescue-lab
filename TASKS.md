# 🧾 Tasks

Work inside `~/brewly-lab/brewly`. After each task, go back to the lab folder and run `./check.sh <number>`.

🧰 **Stuck?** Open **[CHEATSHEET.md](CHEATSHEET.md)**. Each task has a toolbox of commands there. One of them is the one you need. Read them all and pick the right one.

> **Priya's golden rule:** `main` is shared with the whole team. Never delete commits from it. To undo something on `main`, add a *new* commit that undoes it.

---

## 🟢 Task 1: Your first commit

Welcome to the team! Add yourself to the team list.

1. Open `TEAM.md` and add a new line at the bottom: `- Your Name`
2. Save the file.
3. Commit it to `main` with the message `Add <your name> to team`.

Run `git status` before and after each step to see what changes.

👀 **Before and after you commit, run `git log --oneline -3`.** Watch where `HEAD -> main` and `origin/main` are. Which one moved? Not sure what the labels mean? Read [How to read git log](CHEATSHEET.md#-how-to-read-git-log---oneline).

**Check:** `./check.sh 1`  🧰 [Toolbox](CHEATSHEET.md#task-1-your-first-commit)

---

## 🟢 Task 2: Push to origin

Your commit only exists on your laptop. Send it to `origin` (our "GitHub") so the team can see it.

👀 Run `git log --oneline -3` again after pushing. `HEAD -> main` and `origin/main` should now be on the **same line**. That means you're in sync.

👀 Now refresh your `brewly` repo on **github.com**. Your commit is at the top of the commit list, with your name next to it.

**Check:** `./check.sh 2`  🧰 [Toolbox](CHEATSHEET.md#task-2-push-to-origin)

---

## 🟢 Task 3: Stash unfinished work

You start adding a new drink. Add this line to the bottom of `menu.py`:

```python
# TODO: add matcha
```

Just then, Priya needs you on something urgent. You're not ready to commit, but you don't want to lose the change either. **Put it to one side** so your folder is clean again.

**Check:** `./check.sh 3`  🧰 [Toolbox](CHEATSHEET.md#task-3-stash-unfinished-work)

---

## 🟢 Task 4: Fix a commit message

Priya made a typo. On the branch `feature/receipts`, her last commit is called **"Add recipt printing"**.

Switch to that branch and change the message to **"Add receipt printing"**. Fix the existing commit. Don't make a new one.

👀 Run `git log --oneline -3` first. The label now says `HEAD -> feature/receipts`. Can you spot `origin/feature/receipts`? It's one commit lower, which tells you the typo commit was **never pushed**. That's why it's safe to amend.

**Check:** `./check.sh 4`  🧰 [Toolbox](CHEATSHEET.md#task-4-fix-a-commit-message)

---

## 🟢 Task 5: Create and push a branch

Marketing wants a student discount.

1. Go back to `main`.
2. Create a new branch called `feature/student-discount` and switch to it.
3. Create a file called `student.py` containing any text, then commit it.
4. Push the branch to `origin` so that it's linked (tracked).

👀 Before and after the push, run `git log --oneline -2`. Before: only `HEAD -> feature/student-discount`. After: `origin/feature/student-discount` appears next to it.

**Check:** `./check.sh 5`  🧰 [Toolbox](CHEATSHEET.md#task-5-create-and-push-a-branch)

---

## 🟢 Task 6: Push to a second remote

Priya: *"Last month GitHub went down for a whole afternoon and we couldn't ship anything. So we now keep a **backup** copy of the repo somewhere else. Can you connect it and push `main` there?"*

A repo can have **more than one remote**. `origin` is just the default name for the first one.

1. Go back to `main`.
2. See your current remotes: `git remote -v`. Right now there's only `origin`.
3. Add a new remote called **`backup`** that points to `~/brewly-lab/backup.git`
4. Run `git remote -v` again. You should now see two.
5. Push `main` to **backup**. This time you have to tell `push` which remote to use.

👀 Run `git log --oneline -3`. You'll see a new label: `backup/main`. 

**Check:** `./check.sh 6`  🧰 [Toolbox](CHEATSHEET.md#task-6-push-to-a-second-remote)

---

## 🟡 Task 7: Finish a teammate's branch

Tom: *"I'm off sick today 🤒 I pushed a branch called `feature/opening-hours` last night. Could you add the Saturday hours and push it for me? Thank you!"*

Tom's branch is on GitHub (origin), but **not on your laptop yet**. On github.com, open the **branches** dropdown in your `brewly` repo. You can see it there!

1. Run `git branch -a`. Can you see `feature/opening-hours`? (You can't, because your laptop doesn't know about it yet.)
2. Download the latest information from origin (without changing your files).
3. Run `git branch -a` again. Now you'll see `remotes/origin/feature/opening-hours`, plus some other teammates' branches.
4. Switch to `feature/opening-hours`. Git will create a local copy that tracks Tom's branch.
5. Open `hours.txt` and add a new line: `Sat 08:00-14:00`
6. Add and commit it.
7. Push it. Your local branch already tracks origin, so a plain push works.

👀 Run `git log --oneline -3`. Your commit sits on top of Tom's, with `HEAD -> feature/opening-hours, origin/feature/opening-hours`.

> 💡 You **added** to Tom's work, you didn't replace it. Never force-push someone else's branch.

**Check:** `./check.sh 7`  🧰 [Toolbox](CHEATSHEET.md#task-7-finish-a-teammates-branch)

---

## 🟡 Task 8: Bring back a deleted file

Finance is panicking: `prices.csv` has gone! Someone deleted it during a "clean-up".

1. Go back to `main`.
2. Look at the history of that one file to find the commit called **"Add prices.csv export"**.
3. Bring the file back from that commit.
4. Commit it.

**Check:** `./check.sh 6`  🧰 [Toolbox](CHEATSHEET.md#task-8-bring-back-a-deleted-file)

---

## 🟡 Task 9: Fix a merge conflict

On `main`, merge in Tom's branch `feature/loyalty`. Git will stop and tell you there's a **conflict** in `app.py`, because you both changed the same line.

Open `app.py`. You'll see something like this:

```
<<<<<<< HEAD
GREETING = "Welcome to Brewly - the best coffee in town!"
=======
GREETING = "Welcome back to Brewly, loyalty member!"
>>>>>>> feature/loyalty
```

**Keep only the loyalty line.** Delete the other greeting and the three marker lines (`<<<<<<<`, `=======` and `>>>>>>>`). Then save the file, add it, and commit to finish the merge.

**Check:** `./check.sh 7`  🧰 [Toolbox](CHEATSHEET.md#task-9-fix-a-merge-conflict)

---

## 🟡 Task 10: Undo a pushed commit

The website says **"BREWLY IS CLOSED. GO HOME."** 😱 Dan changed `banner.txt`, and his commit **"Update banner text"** is already on `origin`.

Undo his commit the safe way, by making a new commit that reverses it. Then push.

**Check:** `./check.sh 8`  🧰 [Toolbox](CHEATSHEET.md#task-10-undo-a-pushed-commit)

---

## 🟡 Task 11: Copy one commit

Dan's branch `dan/experiments` is full of silly ideas (drones 🚁, blockchain). But **one** commit is useful: **"Fix typo in receipt footer"**.

Copy **just that one commit** onto `main`. Don't bring in the drones.

**Check:** `./check.sh 9`  🧰 [Toolbox](CHEATSHEET.md#task-11-copy-one-commit)

---

## 🟠 Task 12: Throw away local commits

Switch to `feature/reports`. It has never been pushed. Dan added 2 junk commits on top: **"debug: print everything"** and **"more debug"**.

Delete those 2 commits **and** their changes, so the branch ends on **"Add weekly report"**.

**Check:** `./check.sh 10`  🧰 [Toolbox](CHEATSHEET.md#task-12-throw-away-local-commits)

---

## 🟠 Task 13: Squash messy commits

Switch to `feature/search`. Tom has 4 messy commits: `add search`, `wip`, `fix`, `actually works now`.

Turn them into **one** commit called **"Add menu search"**. The code itself mustn't change.

**Check:** `./check.sh 11`  🧰 [Toolbox](CHEATSHEET.md#task-13-squash-messy-commits)

---

## 🟠 Task 14: Undo a merge

Disaster! A merge on `main` called **"Merge branch 'feature/discount-codes'"** added a code that gives **100% off everything**. It's already on `origin`.

Undo the whole merge the safe way, then push.

> A merge commit has **two parents**, so Git needs you to say which side to keep. You want to keep `main`, which is parent **1**.

**Check:** `./check.sh 12`  🧰 [Toolbox](CHEATSHEET.md#task-14-undo-a-merge)

---

## 🟠 Task 15: Rebase, then merge

Tom's branch `feature/hot-chocolate` started from an **old** version of `main`. Since then, `main` has moved on with lots of your fixes.

**Rebase** picks up Tom's commits and replays them on top of the **latest** `main`, as if he'd started today.

1. Before you start, look at the picture: `git log --oneline --graph --all`
2. Switch to `feature/hot-chocolate`.
3. Rebase it onto `main`.
4. Switch back to `main` and merge `feature/hot-chocolate`.
5. 👀 Look at what Git prints: it says **"Fast-forward"**. No merge commit was needed.
6. Look at the picture again: `git log --oneline --graph -6`. It's a straight line.

> ⚠️ Rule: only rebase branches that **only you** have. Rebasing changes commit IDs.

**Check:** `./check.sh 13`  🧰 [Toolbox](CHEATSHEET.md#task-15-rebase-then-merge)

---

## 🟠 Task 16: Merge without rebase

Priya's branch `feature/iced-coffee` **also** started from the old `main`. This time, **don't rebase**. Just merge it.

1. Make sure you're on `main`.
2. Merge `feature/iced-coffee`. An editor opens with a message already written. Save and close it (in vim, type `:wq` and press Enter).
3. 👀 This time Git says **"Merge made by..."**. It created a **merge commit**.
4. Look at the picture: `git log --oneline --graph -8`

**Spot the difference:**
```
*   Merge branch 'feature/iced-coffee'     ← Task 16: merge commit, two lines join
|\
| * Add ice options
| * Add iced coffee
* | Add marshmallow topping               ← Task 15: rebased, straight line
* | Add hot chocolate
```

| | Rebase (Task 15) | Merge (Task 16) |
|---|---|---|
| History | One straight line | Lines join with a merge commit |
| Commit IDs | **Change** (new copies) | Stay the same |
| Safe on shared branches? | ❌ No | ✅ Yes |

**Check:** `./check.sh 14`  🧰 [Toolbox](CHEATSHEET.md#task-16-merge-without-rebase)

---

## 🔴 Task 17: Your first pull request (on real GitHub!)

In a real job you **never** push straight to `main`. You push a branch and open a **pull request (PR)**. The team reviews it, then it's merged on GitHub.

This task happens in **your own GitHub copy of this lab** (the `git-rescue-lab` folder, not `brewly`).

1. Go to your lab folder: `cd` to the `git-rescue-lab` folder you cloned.
2. Make sure you're up to date: `git switch main`, then `git pull`.
3. Create a branch called `add-my-name`.
4. Open `GRADUATES.md` and add a line: `- Your Name`. Save, add and commit it.
5. Push the branch to GitHub (it's new, so remember `-u`).
6. On **github.com**, open your repo. You'll see a yellow bar saying **"add-my-name had recent pushes"**. Click **Compare & pull request**.
7. Write a clear **title** (e.g. `Add Your Name to graduates`) and a short **description** of what you changed and why. Click **Create pull request**.
8. Look around the PR: the **Conversation**, **Commits** and **Files changed** tabs. On Files changed you can click a line to leave a comment, just like a reviewer would.
9. Click **Merge pull request**, then **Confirm merge**. Then click **Delete branch**.
10. Back in your terminal, bring the merged work down: `git switch main`, then `git pull`.

**Check:** `./check.sh 15`  🧰 [Toolbox](CHEATSHEET.md#task-17-your-first-pull-request)

---

When `./check.sh all` shows **17 / 17**, Brewly is saved ☕
Next: **[INTERVIEW-QUESTIONS.md](INTERVIEW-QUESTIONS.md)**
