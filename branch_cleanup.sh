#!/bin/bash

# List of branches to exclude from deletion
excluded_branches=("main" "branch14")

# Fetch all remote branches
git fetch --all --prune

# Get a list of local branches to delete
branches_to_delete=$(git branch --merged | grep -vE "main|branch14" | sed 's/^\*\?\s*//' | tr '\n' ' ')

# Confirm the branches to be deleted
echo "The following branches will be deleted:"
echo "$branches_to_delete"
echo "Are you sure you want to proceed? (y/n)"
read -r confirm

if [[ $confirm == "y" || $confirm == "Y" ]]; then
  # Delete the branches
  for branch in $branches_to_delete; do
    git branch -D "$branch"
  done

  # Push the deletion changes to the remote repository
  git fetch --prune
  remote_branches=$(git branch -r | awk -F/ '!/'$(git branch --show-current)'/ {print $2}')
  for remote_branch in $remote_branches; do
    if [[ ! " ${excluded_branches[@]} " =~ " $remote_branch " ]]; then
      git push origin --delete "$remote_branch"
    fi
  done
else
  echo "Deletion canceled."
fi
