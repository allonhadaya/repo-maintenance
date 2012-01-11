#!/bin/bash
# Removes each pattern from every branch in the repository and force pushes the rewritten commits to the server.
# All collaborators must commit and push their work to origin before remove.sh is executed.
# All collaborators must clone the repository from origin after remove.sh is executed.
# Usage: ./remove.sh 'PATTERN 1' 'PATTERN 2' ... 'PATTERN n'
echo "Removing: ${@}"
read -p "ARE YOU SURE? (y/N) " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  git fetch
  git branch -a | grep '/.*$' - | sed -e '/HEAD/ d' -e 's|.*/origin/\(.*\)|\1|' | while read branch
  do
    git pull origin "${branch}"
    git checkout "${branch}"
    for ARG in "${@}"
    do
      echo "Removing pattern (${ARG}) from branch (${branch})."
      git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch '"${ARG}"
    done
    git push -f origin "${branch}"
  done
fi