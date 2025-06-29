#!/bin/bash

echo "[Gitpod Init] SSH 키를 생성하고 GitHub에 등록합니다."

# SSH 키 생성
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519 -N ""

# GitHub Personal Access Token 입력 받기 (숨김 입력)
echo "GitHub Personal Access Token을 입력하세요:"
read -s GH_TOKEN

# GitHub에 SSH 키 등록
curl -H "Authorization: token $GH_TOKEN" \
     --data "{\"title\":\"Gitpod SSH $(date)\",\"key\":\"$(cat ~/.ssh/id_ed25519.pub)\"}" \
     https://api.github.com/user/keys

# SSH 설정
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "[Gitpod Init] SSH 키 등록과 SSH-agent 설정이 완료되었습니다."
