# 各設定の仕様

## Shell共通環境

### 読み込み経路

Shellに依存しない環境変数とPATHは `home/dot_config/sh/env` に集約しています。

```text
~/.zshenv
  └─ ~/.config/sh/env
      └─ ZDOTDIR=~/.config/zsh
          ├─ ~/.config/zsh/.zprofile
          └─ ~/.config/zsh/.zshrc

~/.bash_profile
  └─ ~/.profile
      └─ ~/.config/sh/env
```

zshの対話機能、補完、プラグイン、プロンプトは `~/.config/zsh/.zshrc` で設定します。Bashは `~/.bashrc` でエイリアスとmiseの有効化を行います。

### XDG Base Directory

値が未設定の場合、次の既定値を設定します。

| 変数 | 既定値 |
| --- | --- |
| `XDG_CONFIG_HOME` | `~/.config` |
| `XDG_CACHE_HOME` | `~/.cache` |
| `XDG_DATA_HOME` | `~/.local/share` |
| `XDG_STATE_HOME` | `~/.local/state` |

Node.js、npm、Rust、各種データベースクライアントなどの履歴やデータも、可能な範囲でXDG配下へ配置します。

### PATH

PATH追加処理は、存在するディレクトリだけを重複しないように先頭へ追加します。Homebrewは次の順に探索します。

1. `/opt/homebrew/bin/brew`
2. `/usr/local/bin/brew`
3. `/home/linuxbrew/.linuxbrew/bin/brew`
4. 現在の `PATH`

Homebrewが見つかった場合は、OpenSSL、GNU coreutils、MySQL Clientのパスも利用可能な範囲で追加します。

### ローカル拡張

管理対象外の次のファイルを、存在する場合だけ読み込みます。

- `~/.zprofile`
- `~/.zshrc`
- `~/.zshalias`

端末固有、勤務先固有、秘密情報を含む設定はこれらへ配置します。

## zsh

設定元は `home/dot_config/zsh/` です。

- `dot_zprofile`: ログインShell用のローカル拡張を読み込む
- `dot_zshrc`: 履歴、補完、starship、zoxide、miseなどを初期化する
- `dot_zshalias`: 共通エイリアス
- `dot_zinit`: zinit本体とzshプラグインを初期化する

履歴は `~/.local/state/zsh/history` に保存し、最大100,000件を共有します。
zinitは `${XDG_DATA_HOME}/zinit/bin` を使用します。

主なエイリアスは次のとおりです。

| エイリアス | 内容 |
| --- | --- |
| `vim` | `nvim` |
| `dots` | `chezmoi` |
| `tree` | `eza -T` |
| `use-pyenv` | 必要なセッションだけpyenvを有効化 |

## miseとpyenv

グローバルmise設定は `home/dot_config/mise/config.toml` です。
Node.js、Python、watchexecを `latest` として定義し、
Python仮想環境作成用のタスクを提供します。

zshとBashはmiseコマンドが利用可能な場合だけShell統合を有効化します。

pyenvは通常のShell起動では初期化しません。既存の `.python-version` を必要とする作業では、zshの `use-pyenv` エイリアス、または次のコマンドで明示的に有効化します。

```bash
source ~/.config/shell/pyenv.sh
```

## Git

設定元は `home/dot_config/git/config` と `home/dot_config/git/ignore`、
展開先は `~/.config/git/` です。

主な方針は次のとおりです。

- 既定ブランチ名は `main`
- `git pull` はrebase-mergesとauto-stashを使用
- fetch時に削除済みremote branchをprune
- push時にupstreamを自動設定
- rerereを有効化
- conflict markerは `zdiff3`
- ghq rootは `~/projects` と `~/src`

設定にはブランチ削除、pull、push、ブラウザ起動など副作用を伴うエイリアスも含まれます。使用前に `git aliases` で内容を確認してください。

### セキュリティ上の注意

現状のGit設定には次の値が含まれます。

- `[http] sslVerify = false`
- credential helperとして `osxkeychain` と `store`
- 固定のuser nameとemail

TLS検証の無効化と平文保存になり得るcredential helperはセキュリティリスクがあります。また、`osxkeychain` はmacOS固有です。この文書は現状を説明するものであり、これらの設定を一般利用に推奨するものではありません。

## tmux

設定元は `home/dot_config/tmux/tmux.conf`、展開先は `~/.config/tmux/tmux.conf` です。

- prefixは `C-t`
- マウス、クリップボード連携、ウィンドウ番号の詰め直しを有効化
- copy modeはviキーバインド
- TPMでプラグインを管理
- `prefix + r` で設定を再読み込み
- `prefix + g` で現在のディレクトリ用popup sessionを表示
- `prefix + G` でグローバルpopup sessionを表示

TPM本体は `~/.config/tmux/plugins/tpm` に導入します。プラグインの初回インストールはtmux内でTPMの操作が必要になる場合があります。

## starship

設定元は `home/dot_config/starship.toml`、展開先は `~/.config/starship.toml` です。zsh起動時にstarshipが利用可能な場合だけ初期化します。

プロンプトはGitリポジトリ情報を左側、コマンド時間や言語ランタイムなどを右側に表示する構成です。

## fzf

Homebrewのfzfインストーラーを使用し、zsh/tmux向けキーバインドと補完を生成します。Shellのrcファイルはインストーラーから直接更新しません。

## WezTerm

設定元は `home/dot_config/wezterm/wezterm.lua`、展開先は
`~/.config/wezterm/wezterm.lua` です。macOS以外ではchezmoiのignore対象です。

- フォントは `moralerspace argon`、サイズ14
- color schemeは `tokyonight_night`
- 背景透過率は0.85
- macOSの背景blurは20
- 設定変更の自動再読み込みを有効化
- タブ数が1つの場合はタブバーを非表示

フォントはmacOS用Brewfileの `font-moralerspace` に依存します。

## パッケージ管理

### 共通

`Brewfile` はGit/gh、検索・移動系CLI、基本ユーティリティ、chezmoi、Neovim、tmux、starship、Docker CLIなどを管理します。

### macOS

`Brewfile.darwin` はWezTerm、Docker Desktop、Moralerspaceフォント、Neovideを管理します。

ツールを設定から新たに参照するときは、対象OSのパッケージ定義にも導入方法を追加してください。
