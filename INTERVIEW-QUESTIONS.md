# 🎤 Git Interview Questions

Each question links back to a lab task. Answer out loud first, then click to check.

---

**1. In `git log --oneline` you see `(HEAD -> main, origin/main)`. What does that mean?** *(Tasks 1, 2)*
<details><summary>Answer</summary>

`HEAD` is where you are now. `HEAD -> main` means you're on the `main` branch. `origin/main` is where `main` was on GitHub the last time you fetched, pulled or pushed. Both labels on the same commit means your local `main` is in sync with GitHub. If `origin/main` is on a lower line, you have commits that haven't been pushed.
</details>

**2. What's the difference between the working folder, the staging area and a commit?** *(Task 1)*
<details><summary>Answer</summary>

The **working folder** is the files you edit. The **staging area** holds the changes you've picked for the next commit (`git add`). A **commit** is a saved snapshot of what was staged (`git commit`).
</details>

**3. What's the difference between `git fetch`, `git pull` and `git push`?** *(Task 2)*
<details><summary>Answer</summary>

`fetch` downloads the team's new commits without changing your branch. `pull` is fetch plus a merge into your branch. `push` uploads your commits to origin.
</details>

**4. When would you use `git stash`?** *(Task 3)*
<details><summary>Answer</summary>

When you have unfinished changes but need to switch to something else. `stash` puts them to one side and cleans your folder. `git stash pop` brings them back and removes them from the list. `git stash apply` brings them back and keeps a copy in the list.
</details>

**5. What does `git commit --amend` do, and when shouldn't you use it?** *(Task 4)*
<details><summary>Answer</summary>

It replaces your last commit, so you can fix the message or add a forgotten file. Don't use it on commits you've already pushed. It creates a new commit ID, and the team's copy would no longer match yours.
</details>

**6. What does `-u` do in `git push -u origin <branch>`?** *(Task 5)*
<details><summary>Answer</summary>

It links your local branch to the branch on origin (the "upstream"). After that, a plain `git push` or `git pull` works without typing the names.
</details>

**7. What is a remote? Can a repo have more than one?** *(Task 6)*
<details><summary>Answer</summary>

A remote is a named link to another copy of the repo, such as GitHub. `origin` is just the default name for the first one. You can add more with `git remote add <name> <url>` (a backup, or a fork's `upstream`) and push to one with `git push <name> <branch>`.
</details>

**8. A teammate pushed a new branch, but you can't see it. What do you do?** *(Task 7)*
<details><summary>Answer</summary>

Run `git fetch` to download the new branch information. It then appears in `git branch -a` as `remotes/origin/<branch>`. `git switch <branch>` creates a local copy that tracks it. You can then commit and `git push` on top of their work. Never force-push a branch someone else owns.
</details>

**9. A file was deleted a few commits ago. How do you get it back?** *(Task 8)*
<details><summary>Answer</summary>

Use `git log --oneline -- <file>` to find a commit where the file still existed. Then run `git checkout <hash> -- <file>`, and add and commit it.
</details>

**10. What's a merge conflict, and how do you fix one?** *(Task 9)*
<details><summary>Answer</summary>

A conflict happens when two branches change the same lines and Git can't decide which to keep. Open the file, choose the right content and delete the `<<<<<<<`, `=======` and `>>>>>>>` markers. Then `git add` the file and `git commit`. To cancel, use `git merge --abort`.
</details>

**11. `git revert` vs `git reset`. Which is safe on a shared branch?** *(Tasks 10, 12)*
<details><summary>Answer</summary>

`revert` is the safe one. It adds a **new** commit that undoes an old one, so history stays intact. `reset` **removes** commits, which rewrites history. Use it only on branches nobody else has.
</details>

**12. What's the difference between `reset --soft`, a plain `reset` and `reset --hard`?** *(Tasks 12, 13)*
<details><summary>Answer</summary>

All three remove commits. `--soft` keeps the changes **staged**. A plain `reset` keeps them in your files but **unstaged**. `--hard` **throws the changes away**.
</details>

**13. What is `git cherry-pick`?** *(Task 11)*
<details><summary>Answer</summary>

It copies one specific commit from another branch onto your current branch. It's useful for grabbing a single fix without merging everything else.
</details>

**14. What does squashing mean, and why do it?** *(Task 13)*
<details><summary>Answer</summary>

Squashing combines several small commits into one. It makes the history clean and readable before a pull request: one "Add menu search" instead of "wip", "fix" and "actually works now".
</details>

**15. How do you undo a merge that's already been pushed?** *(Task 14)*
<details><summary>Answer</summary>

`git revert -m 1 <merge-hash>`. A merge has two parents, and `-m 1` tells Git to go back to parent 1, the main branch.
</details>

**16. What's the difference between merge and rebase?** *(Tasks 15, 16)*
<details><summary>Answer</summary>

Both bring work from one branch into another. **Merge** joins the branches with a merge commit and keeps history exactly as it happened. **Rebase** replays your commits on top of the other branch, which gives a straight-line history but creates **new commit IDs**. So only rebase branches nobody else uses.
</details>

**17. What's a fast-forward merge?** *(Task 15)*
<details><summary>Answer</summary>

When the branch you're merging into hasn't moved since your branch started, Git just slides the pointer forward. No merge commit is needed.
</details>

**18. What's a pull request, and why do teams use them?** *(Task 17)*
<details><summary>Answer</summary>

A PR is a request to merge your branch into `main`, usually on GitHub. Teammates can review the code, comment, run automated checks and approve before it's merged. It keeps `main` stable and shares knowledge across the team.
</details>

**19. What makes a good pull request?** *(Task 17)*
<details><summary>Answer</summary>

It's small and focused on one change, with a clear title, a description of what changed and why, and passing checks. A good PR author also responds to review comments politely and updates the PR by pushing more commits to the same branch.
</details>

---

🏆 If you can answer all 19 without peeking, you're ready.
