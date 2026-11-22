# ✅ Solutions

> Try each task with the [cheat sheet](CHEATSHEET.md) first. Only look here if you're really stuck.

Run everything inside `~/brewly-lab/brewly`.

---

### Task 1: Your first commit
```bash
# edit TEAM.md and add a line:  - Your Name
git status                         # TEAM.md is "modified"
git add TEAM.md
git status                         # now it's staged ("Changes to be committed")
git commit -m "Add Your Name to team"
```
**Why:** `add` chooses what goes into the commit, and `commit` saves it.

### Task 2: Push
```bash
git push
```
**Why:** `main` is already linked to `origin/main`, so a plain `push` knows where to go.

### Task 3: Stash
```bash
echo "# TODO: add matcha" >> menu.py   # or edit the file
git stash
git stash list                         # stash@{0}: WIP on main ...
git status                             # clean
```
**Why:** `stash` puts the change to one side. Later, `git stash pop` brings it back.

### Task 4: Fix a commit message
```bash
git switch feature/receipts
git commit --amend -m "Add receipt printing"
git log --oneline -2
```
**Why:** `--amend` replaces the last commit. That's fine because it was never pushed.

### Task 5: Create and push a branch
```bash
git switch main
git switch -c feature/student-discount
echo "STUDENT_DISCOUNT = 0.10" > student.py
git add student.py
git commit -m "Add student discount"
git push -u origin feature/student-discount
```
**Why:** `-c` creates the branch, and `-u` links it to origin so a plain `git push` works from now on.

### Task 6: Push to a second remote
```bash
git switch main
git remote -v                                    # only origin
git remote add backup ~/brewly-lab/backup.git
git remote -v                                    # origin and backup
git push backup main
```
**Why:** you can have as many remotes as you like. `git push <remote> <branch>` says exactly where to send it.

### Task 7: Finish a teammate's branch
```bash
git branch -a                     # no opening-hours yet
git fetch                         # * [new branch] feature/opening-hours -> origin/feature/opening-hours
git branch -a                     # now it's listed under remotes/origin/
git switch feature/opening-hours  # "set up to track 'origin/feature/opening-hours'"
echo "Sat 08:00-14:00" >> hours.txt
git add hours.txt
git commit -m "Add Saturday hours"
git push
```
**Why:** `fetch` tells your laptop what's new on origin. `switch` makes a local copy of the remote branch that's already linked, so `push` adds your commit on top of Tom's.

### Task 8: Bring back a deleted file
```bash
git switch main
git log --oneline -- prices.csv
#   81409fc Clean up old files       ← deleted here
#   1c77f6a Add prices.csv export    ← the file exists here
git checkout 1c77f6a -- prices.csv
git add prices.csv
git commit -m "Bring back prices.csv"
```
**Why:** `checkout <hash> -- <file>` copies one file from an old commit into your folder.

### Task 9: Fix a merge conflict
```bash
git switch main
git merge feature/loyalty          # CONFLICT in app.py
# edit app.py so the greeting part is just:
#   GREETING = "Welcome back to Brewly, loyalty member!"
# and delete the <<<<<<< ======= >>>>>>> lines
git add app.py
git commit                         # save and close the editor (vim: :wq)
```
**Why:** Git can't choose between two edits to the same line, so you choose. `git add` marks the file as fixed.

### Task 10: Undo a pushed commit
```bash
git log --oneline -- banner.txt    # 913b69f Update banner text
git revert 913b69f                 # save and close the editor
git push
```
**Why:** `revert` adds a new commit, so nobody's history breaks. Never `reset` a shared branch.

### Task 11: Copy one commit
```bash
git switch main
git log --oneline dan/experiments  # ea40288 Fix typo in receipt footer
git cherry-pick ea40288
```
**Why:** `cherry-pick` copies one commit. `merge` would have brought in the drones too.

### Task 12: Throw away local commits
```bash
git switch feature/reports
git reset --hard HEAD~2
git log --oneline -1               # Add weekly report
```
**Why:** `--hard` removes the commits **and** their changes. That's fine because nobody else has this branch.

### Task 13: Squash
```bash
git switch feature/search
git reset --soft HEAD~4
git commit -m "Add menu search"
```
**Why:** `--soft` removes the 4 commits but keeps all their code staged, so one commit saves it all again.

### Task 14: Undo a merge
```bash
git switch main
git log --oneline --merges         # cb002e4 Merge branch 'feature/discount-codes'
git revert -m 1 cb002e4            # save and close the editor
git push
```
**Why:** a merge has two parents. `-m 1` says "go back to parent 1", which is `main`.

### Task 15: Rebase, then merge
```bash
git log --oneline --graph --all      # hot-chocolate branches off an OLD main
git switch feature/hot-chocolate
git rebase main                      # "Successfully rebased"
git switch main
git merge feature/hot-chocolate      # "Fast-forward"
git log --oneline --graph -6         # straight line
```
**Why:** rebase moved Tom's 2 commits on top of the latest `main`, so `main` could just slide forward. No merge commit was needed.

### Task 16: Merge without rebase
```bash
git switch main
git merge feature/iced-coffee        # editor opens: save and close (vim: :wq)
git log --oneline --graph -8         # see the bubble and the merge commit
```
**Why:** both `main` and `iced-coffee` had new commits, so Git tied them together with a merge commit. Compare this with Task 15's straight line.

### Task 17: Your first pull request
```bash
cd ~/path/to/git-rescue-lab          # your own GitHub copy
git switch main
git pull
git switch -c add-my-name
echo "- Your Name" >> GRADUATES.md
git add GRADUATES.md
git commit -m "Add Your Name to graduates"
git push -u origin add-my-name
```
On github.com: **Compare & pull request**, write a title and description, then **Create pull request**. Check **Files changed**, click **Merge pull request** and **Confirm merge**, then **Delete branch**.
```bash
git switch main
git pull                             # brings down "Merge pull request #1 ..."
git branch -d add-my-name            # optional tidy-up
```
**Why:** this is how real teams work. Nobody pushes straight to `main`. Changes go through a PR so they can be reviewed first.

---

🎉 Run `./check.sh all` from the lab folder and enjoy the **17 / 17**.
