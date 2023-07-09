#!/bin/bash

# Fetch all remote branches
git fetch --all --prune

# Get a list of local branches
branches=$(git branch | sed 's/^\*\?\s*//' | tr '\n' ' ')

# Confirm the branches to keep
echo "The following branches are available:"
echo "$branches"
echo "Please enter the branches you want to keep (space-separated):"
read -r branches_to_keep

# Delete the branches
branches_to_delete=$(comm -23 <(echo "$branches" | tr ' ' '\n' | sort) <(echo "$branches_to_keep" | tr ' ' '\n' | sort))

if [[ -n "$branches_to_delete" ]]; then
  echo "The following branches will be deleted:"
  echo "$branches_to_delete"
  echo "Are you sure you want to proceed? (y/n)"
  read -r confirm

  if [[ $confirm == "y" || $confirm == "Y" ]]; then
    for branch in $branches_to_delete; do
      if [[ ! " ${branches_to_keep[@]} " =~ " $branch " ]]; then
        git branch -D "$branch"
        git push origin --delete "$branch"
      fi
    done
    echo "Branches successfully deleted."
  else
    echo "Deletion canceled."
  fi
else
  echo "No branches selected for deletion."
fi
