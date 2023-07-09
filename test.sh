#!/bin/bash

# Create and push branches
for ((i=1; i<=10; i++)); do
  branch_name="branch$i"

  # Create the local branch
  git branch "$branch_name"

  # Switch to the newly created branch
  git checkout "$branch_name"

  # Make some changes or add commits if desired
  # ...

  # Push the branch to the remote repository
  git push origin "$branch_name"

  # Switch back to the main branch
  git checkout main
done
