#!/usr/bin/env bash

set -euo pipefail

log() {
  printf '[install] %s\n' "$*"
}

die() {
  printf '[install] %s\n' "$*" >&2
  exit 1
}

detect_os() {
  case "$(uname -s)" in
    Darwin) printf 'darwin' ;;
    Linux) printf 'linux' ;;
    *) die "未対応のOSです: $(uname -s)" ;;
  esac
}

brew_candidates() {
  case "$(detect_os)" in
    darwin)
      printf '%s\n' \
        /opt/homebrew/bin/brew \
        /usr/local/bin/brew
      ;;
    linux)
      printf '%s\n' /home/linuxbrew/.linuxbrew/bin/brew
      ;;
  esac
}

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return 0
  fi

  local candidate
  for candidate in $(brew_candidates); do
    if [ -x "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

install_homebrew() {
  local os
  os="$(detect_os)"

  log "Homebrew をインストールします (${os})"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

ensure_brew() {
  local brew_bin

  if brew_bin="$(find_brew)"; then
    eval "$("$brew_bin" shellenv)"
    return 0
  fi

  install_homebrew

  brew_bin="$(find_brew)" || die "Homebrew のインストール後に brew が見つかりません"
  eval "$("$brew_bin" shellenv)"
}

ensure_command() {
  local command_name=$1
  local formula=$2

  if command -v "$command_name" >/dev/null 2>&1; then
    return 0
  fi

  log "${command_name} を brew でインストールします"
  brew install "$formula"
}

ensure_github_auth() {
  if gh auth status -h github.com >/dev/null 2>&1; then
    log "GitHub CLI はログイン済みです"
    return 0
  fi

  if ! (: </dev/tty) 2>/dev/null; then
    die "GitHub CLIが未ログインです。対話可能な端末で gh auth login -h github.com -p ssh --skip-ssh-key を実行してから、再度セットアップしてください"
  fi

  log "GitHub CLIでgithub.comへログインします"
  gh auth login \
    --hostname github.com \
    --git-protocol ssh \
    --skip-ssh-key \
    --web </dev/tty

  gh auth status -h github.com >/dev/null 2>&1 ||
    die "GitHub CLIのログインを確認できませんでした"
}

main() {
  ensure_brew
  ensure_command chezmoi chezmoi
  ensure_command mise mise
  ensure_command gh gh
  ensure_github_auth

  if [ -d "${HOME}/.local/share/chezmoi" ]; then
    log "既存の chezmoi リポジトリを update --apply します"
    chezmoi update --apply
  else
    log "chezmoi init --apply hidetoshing を実行します"
    chezmoi init --apply hidetoshing
  fi
}

main "$@"
