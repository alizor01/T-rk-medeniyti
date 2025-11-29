#!/bin/sh
# Usage: ./git_push_setup.sh YOUR_GITHUB_REPO_URL
if [ -z "$1" ]; then echo "Usage: $0 git@github.com:username/repo.git"; exit 1; fi
url=$1
git init
git add .
git commit -m "Initial commit - Türk Medeniyeti"
git branch -M main
git remote add origin $url
git push -u origin main
