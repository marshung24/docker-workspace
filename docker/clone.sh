#!/bin/bash
set -e

# 參數：
# - REPO_URL: Git repository URL
#   - 必須設定環境變數，否則會顯示錯誤訊息
# - BRANCH: Git branch name
#   - 先讀環境變數，預設值： main
# - TARGET_DIR: Target directory to clone the repository
#   - 先讀環境變數，預設值： /srv/app/
: "${REPO_URL:?❌ REPO_URL 環境變數未設定！請設定後再執行。}"
BRANCH="${BRANCH:-main}"
TARGET_DIR="${TARGET_DIR:-/srv/app/}"

# 檢查目標目錄是否已經存在 Git repository
if [ -d "$TARGET_DIR/.git" ]; then
  # 存在，不處理，直接顯示訊息
  echo "✅ Repo already exists at $TARGET_DIR"
else
  # 不存在，進行 clone
  echo "📥 Cloning $BRANCH from $REPO_URL into $TARGET_DIR"
  git clone -b "$BRANCH" --single-branch "$REPO_URL" "$TARGET_DIR"
fi
