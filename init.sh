#!/bin/bash

# SSH 키 생성 (이미 있으면 건너뜀)
if [ ! -f ~/.ssh/id_rsa ]; then
  echo "🚀 SSH key 생성 중..."
  ssh-keygen -t rsa -b 4096 -C "parkpark79@github.com" -N "" -f ~/.ssh/id_rsa
else
  echo "✅ 이미 SSH key 존재"
fi

# GitHub 지문 등록 (known_hosts에)
if ! grep github.com ~/.ssh/known_hosts > /dev/null 2>&1; then
  echo "🚀 github.com known_hosts 등록"
  ssh-keyscan github.com >> ~/.ssh/known_hosts
fi

# GitHub API로 SSH key 등록 (GH_TOKEN 필요)
if [ -n "$GH_TOKEN" ]; then
  PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
  echo "🚀 GitHub에 SSH key 등록 요청 중..."
  curl -s -H "Authorization: token $GH_TOKEN" \
       -d "{\"title\":\"Gitpod SSH $(date)\",\"key\":\"$PUB_KEY\"}" \
       https://api.github.com/user/keys
else
  echo "⚠ GH_TOKEN 환경변수가 없어서 SSH key를 GitHub에 등록하지 못했습니다."
fi
