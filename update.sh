#!/bin/bash
set -ex

current=$(grep -Po '(?<=ReviewBoard==)(.+)$' Dockerfile)
url=https://pypi.org/pypi/ReviewBoard/json
latest=$(curl -s $url | jq -r '.releases | keys[]' | sort -V | tail -n 1)

echo "Current version: $current"
echo "Latest version: $latest"

[ "$latest" = "$(echo -e "$latest\n$current" | sort -V | head -n 1)" ] && exit

sed -i "s/ReviewBoard==$current/ReviewBoard==$latest/" Dockerfile
sed -i "s/:$current/:$latest/" dev/Dockerfile
git commit -a -m "Update ReviewBoard to $latest"

url=$(git config remote.origin.url)
git config remote.origin.url ${url/github.com/$GH_TOKEN@github.com}
git push origin HEAD:master
git tag $latest
git push origin $latest

echo "Updated to: $latest" | heirloom-mailx -s "alpine-reviewboard" \
    -r travis@easyb.ch -S smtp=smtp://smtp.gmail.com:587 -S smtp-use-starttls \
    -S smtp-auth=login -S smtp-auth-user=travis@easyb.ch \
    -S smtp-auth-password=$SMTP_PW spam@easyb.ch
