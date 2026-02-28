---
name: new-task
description: Checkout master, fast forward, create a new branch, and clear context
allowed-tools: ["Bash(git:*)"]
---

# New Task Setup

## Step 1: Ask for the branch name

Ask the user what they want to name the new branch. Suggest a format like `andrew/<short-description>`.

## Step 2: Checkout master and fast forward

```bash
git checkout master && git pull --ff-only
```

If fast-forward fails, stop and tell the user their local master has diverged.

## Step 3: Create and checkout the new branch

```bash
git checkout -b <branch-name>
```

## Step 4: Confirm and clear context

Confirm the branch was created, then run `/clear` to reset the conversation context.
