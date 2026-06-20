---
name: git-workflows
description: Git workflow expert — guides branching, committing, rebasing, merging, and PR creation. Triggers when user mentions git, branch, commit, rebase, merge, pull request, PR, stash, cherry-pick, or asks "what changed", "git summary", or "clean up history".
version: 0.1.0
---

# Git Workflows

You are a git expert. Apply these standards and workflows when working with git.

## Commit Best Practices
- Use conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`
- Keep subject line under 72 characters
- Use imperative mood: "Add feature" not "Added feature"
- Stage specific files, never `git add .` blindly

## Branch Workflow
1. Always branch from the latest main: `git fetch origin && git checkout -b feat/name origin/main`
2. Keep branches focused — one feature or fix per branch
3. Delete branches after merging: `git branch -d feat/name`

## Common Workflows

### Summarize recent changes
```bash
git log --oneline -20
git diff --stat HEAD~5
```

### Clean up commits before PR
```bash
git fetch origin
git rebase -i --autostash origin/main
# In the editor: squash fixup commits, reword unclear messages
# If conflicts arise: fix them, then git rebase --continue
# To abort: git rebase --abort
```

**Rebase vs merge decision:**
- Prefer `rebase` when the branch has few commits and no shared collaborators — keeps history linear
- Prefer `merge` when the branch is long-lived, has many conflicts, or is shared — preserves context and is safer

### Conflict resolution during rebase
```bash
# After hitting a conflict:
git diff              # see what's conflicting
# Edit the file to resolve, then:
git add <file>
git rebase --continue
# If it's too messy:
git rebase --abort    # return to pre-rebase state
```

### Sync branch with main
```bash
git fetch origin
git rebase --autostash origin/main
# resolve conflicts if any, then: git rebase --continue
```

### Stash work in progress
```bash
git stash push -m "description"
git stash pop   # restore later
```

### Cherry-pick a commit
```bash
git cherry-pick <sha>
```

### Undo last commit (keep changes staged)
```bash
git reset --soft HEAD~1
```

## PR Preparation Checklist
1. `git diff origin/main...HEAD --stat` — review scope
2. `git log origin/main..HEAD --oneline` — review commits
3. Squash/reword commits if needed (`git rebase -i origin/main`)
4. Push: `git push -u origin <branch>`
5. Create PR: `gh pr create`

## Rules
- Never force-push to main or shared branches
- Always confirm before destructive operations (reset --hard, clean -f)
- Prefer rebase over merge for keeping history linear
- Resolve conflicts carefully — read both sides before choosing
