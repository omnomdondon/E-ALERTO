#!/bin/bash

# Step 1: Fetch latest changes from the original repository (upstream)
echo "Fetching latest changes from upstream..."
git fetch upstream branch-6

# Step 2: Merge upstream changes into your local branch
echo "Merging upstream changes into branch-6..."
git merge upstream/branch-6 --no-edit

# Step 3: Add all modified and untracked files
echo "Staging all changes..."
git add .

# Step 4: Commit changes with a message
echo "Committing changes..."
git commit -m "Auto-update from upstream and local changes"

# Step 5: Push changes to your fork (origin) and the original repo (upstream)
echo "Pushing changes to origin (your fork)..."
git push origin branch-6

echo "Pushing changes to upstream (original repo)..."
git push upstream branch-6

echo "Update complete!"
