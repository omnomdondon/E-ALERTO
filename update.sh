#!/bin/bash

# Configuration
UPSTREAM_REPO="https://github.com/frnzyng/E-ALERTO"
UPSTREAM_BRANCH="branch-6"
YOUR_REPO="https://github.com/omnomdondon/E-ALERTO"
YOUR_BRANCH="branch-6"

echo "🔍 Checking remote configurations..."
git remote -v

# Add upstream if not already configured
if ! git remote | grep -q "upstream"; then
    echo "➕ Adding upstream remote..."
    git remote add upstream $UPSTREAM_REPO
fi

# Fetch latest changes
echo "📥 Fetching changes..."
git fetch upstream
git fetch origin

# Checkout your working branch
echo "🌿 Checking out your branch..."
git checkout $YOUR_BRANCH

# Commit any local changes before merging
if [[ -n $(git status --porcelain) ]]; then
    echo "📝 Local changes detected. Committing before merge..."
    git add .
    git commit -m "Auto-save: Committing local changes before upstream merge"
else
    echo "✅ No local changes to commit."
fi

# Merge upstream branch
echo "🔀 Merging upstream changes..."
if ! git merge upstream/$UPSTREAM_BRANCH --no-edit; then
    echo "❗ Merge conflict detected! Please resolve conflicts manually."
    read -p "⚠️ Press Enter to close this message..."
    exit 1
fi

# Push changes to origin (your fork)
echo "🚀 Pushing to your fork (origin)..."
git push origin $YOUR_BRANCH

# Push changes to upstream
echo "🚀 Pushing to upstream repository..."
git push upstream $YOUR_BRANCH

echo "✅ Update complete!"
read -p "💖 Press Enter to close..."

# #!/bin/bash

# # Configuration
# UPSTREAM_REPO="https://github.com/frnzyng/E-ALERTO"
# UPSTREAM_BRANCH="branch-6"
# YOUR_REPO="https://github.com/omnomdondon/E-ALERTO"
# YOUR_BRANCH="branch-6"

# # Step 1: Verify remote configurations
# echo "Checking remote configurations..."
# git remote -v

# # Add upstream if not already configured
# if ! git remote | grep -q "upstream"; then
#     echo "Adding upstream remote..."
#     git remote add upstream $UPSTREAM_REPO
# fi

# # Step 2: Fetch latest changes from both repositories
# echo "Fetching changes from both repositories..."
# git fetch upstream
# git fetch origin

# # Step 3: Checkout your branch
# echo "Checking out your branch..."
# git checkout $YOUR_BRANCH

# # Step 4: Merge upstream changes
# echo "Merging upstream changes..."
# if ! git merge upstream/$UPSTREAM_BRANCH --no-edit; then
#     echo "Merge conflict detected! Please resolve conflicts manually."
#     exit 1
# fi

# # Step 5: Add all changes
# echo "Staging changes..."
# git add .

# # Step 6: Commit changes if there are any
# if [[ -n $(git status --porcelain) ]]; then
#     echo "Committing changes..."
#     git commit -m "Auto-update: Merged upstream changes and local modifications"
# else
#     echo "No changes to commit."
# fi

# # Step 7: Push changes to both repositories
# echo "Pushing to your fork (origin)..."
# git push origin $YOUR_BRANCH

# echo "Pushing to upstream repository..."
# git push upstream $YOUR_BRANCH

# echo "Update complete!"