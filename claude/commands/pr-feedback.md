---
name: pr-feedback
description: Address PR feedback, commit changes, rebase on master, and force push
allowed-tools: ["Bash(gh pr:*)", "Glob", "Grep", "Read", "Edit", "Write"]
---

# Address PR Feedback

## Step 1: Get Current Branch and PR Info

```bash
git branch --show-current
```

## Step 2: Fetch PR Details, Comments, and Check Status

Use `gh` CLI to get PR information for the current branch:

```bash
gh pr view --json number,title,body,reviews,comments,reviewRequests
gh pr view --comments
gh api repos/{owner}/{repo}/pulls/{number}/comments
```

Get all review comments and requested changes:
```bash
gh pr view --json reviews --jq '.reviews[] | select(.state == "CHANGES_REQUESTED" or .state == "COMMENTED") | {author: .author.login, state: .state, body: .body}'
```

Get failed checks and CI status:
```bash
gh pr checks
gh pr view --json statusCheckRollup --jq '.statusCheckRollup[] | select(.conclusion == "FAILURE" or .conclusion == "ACTION_REQUIRED") | {name: .name, conclusion: .conclusion, detailsUrl: .detailsUrl}'
```

For failed checks, get the logs:
```bash
gh run view <run-id> --log-failed
```

## Step 3: Analyze Feedback and Failures

For each piece of feedback and failed check:
1. Understand what change is being requested or what failed
2. Locate the relevant code
3. Determine the fix

Group by priority:
- **Must address**: Failed checks (CI/tests), changes requested, blocking comments
- **Should address**: Suggestions, improvements
- **Optional**: Nitpicks, style preferences

For failed checks specifically:
- Identify which check failed (lint, typecheck, tests, build)
- Read the failure logs to understand the error
- Fix the underlying issue, don't just silence the check

## Step 4: Make the Changes

Address each piece of feedback:
1. Read the relevant files
2. Make the requested changes
3. Keep changes focused and minimal

Do NOT:
- Over-engineer the fix
- Add unrelated changes
- Refactor beyond what's requested

## Step 5: Commit the Changes

After making all changes:

```bash
git add -A
git commit -m "Address PR feedback

- [summarize changes made]

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
```

## Step 6: Rebase on Origin Master

```bash
git fetch origin master
git rebase origin/master
```

If conflicts occur:
1. Resolve conflicts
2. `git add` resolved files
3. `git rebase --continue`

## Step 7: Force Push with Lease

```bash
git push --force-with-lease
```

## Step 8: Respond to PR

After pushing, leave a comment on the PR summarizing what was addressed:

```bash
gh pr comment --body "Addressed feedback:
- [list of changes]

Ready for re-review."
```

## Output

After completing all steps, provide a summary:
- Failed checks fixed (lint, typecheck, tests, build)
- Review feedback addressed
- Files modified
- Any feedback intentionally not addressed (with reasoning)
- Link to the updated PR
