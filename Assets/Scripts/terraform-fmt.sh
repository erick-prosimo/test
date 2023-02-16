terraform fmt -recursive

sleep 5

git config --global --add safe.directory '*'
git config user.name github-actions
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
git add -A
git pull
git commit -m "Automated commit - TF Format"
git push --set-upstream origin $BRANCH