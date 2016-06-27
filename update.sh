#!/bin/bash

rm -rf content/post/*.md
cp -r ${GOPATH}/src/k8s.io/kubernetes/docs/proposals/*.md content/post/

for f in $(find content/post -name *.md); do
  name=$(grep -i '^# ' "${f}" | head -n 1 | sed -e 's/^# //')
  filename=$(echo "${f}" | sed -e "s/.*\/\(.*\).md$/\1/")
  if [[ -z "${name}" ]]; then
    name="${filename}"
  fi
  echo "Processing ${name} ..."
read -r -d '' HEADER <<- EOF
+++
date = "$(date +'%FT%T+02:00')"
draft = false
toc = "true"

title = "${name}"

+++
EOF
echo "${HEADER}" > /tmp/_header.md
cat /tmp/_header.md ${f} > "${f}.new"
mv "${f}.new" "${f}"
done
