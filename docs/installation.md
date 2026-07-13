# インストール・更新仕様

## 目的

この文書は、`install.sh` とchezmoiのスクリプトが行う処理、前提条件、副作用、再実行時の挙動を説明します。

## 対応OS

`install.sh` が受け付けるOSは次のとおりです。

- macOS:
  `/opt/homebrew/bin/brew`、`/usr/local/bin/brew` の順に探索し、
  `Brewfile.darwin` とWezTerm設定を適用します。
- Linux:
  `/home/linuxbrew/.linuxbrew/bin/brew` を探索し、
  caskとWezTerm設定を除外します。

DarwinとLinux以外では、未対応OSとしてインストールを終了します。

## 前提条件

- `bash`
- `curl`
- `git`
- Homebrewの導入に必要な権限
- GitHubおよびHomebrewへ接続できるネットワーク

Homebrewがない場合は、公式インストールスクリプトを `NONINTERACTIVE=1` で実行します。

## `install.sh` の処理

### 1. Homebrewの確認

現在の `PATH` にある `brew` を優先し、見つからなければOS別の既定パスを
探索します。見つからない場合はHomebrewを導入し、`brew shellenv` を
現在のプロセスへ反映します。

### 2. セットアップ用コマンドの確認

`chezmoi`、`mise`、`gh` がなければ、それぞれHomebrewで導入します。

ここで導入するmiseはコマンド本体です。Node.jsとPythonは、後続のchezmoi適用時に `mise install` で導入します。

### 3. GitHub CLIの認証

`gh auth status -h github.com` でログイン状態を確認します。未ログインの場合は、SSH鍵の生成・登録を後続スクリプトに任せるため、次のコマンドでログインします。

```bash
gh auth login -h github.com -p ssh --skip-ssh-key --web
```

対話可能な端末がない場合は、復旧コマンドを表示してセットアップを中断します。別の対話可能な端末で次を実行してから、セットアップを再実行してください。

```bash
gh auth login -h github.com -p ssh --skip-ssh-key
```

### 4. sourceの初期化または更新

- `~/.local/share/chezmoi` が存在する場合: `chezmoi update --apply`
- 存在しない場合: `chezmoi init --apply hidetoshing`

既存ディレクトリがこのリポジトリを指しているかは判定しません。
別のchezmoi sourceを利用している場合は、インストール前に
`chezmoi source-path` などで確認してください。

## chezmoi適用時の自動処理

### パッケージ

`run_onchange_before_20_install-packages.sh.tmpl` が次を実行します。

1. `Brewfile` を使った共通パッケージの導入
2. macOSのみ `Brewfile.darwin` を使ったGUIアプリなどの導入
3. リポジトリの `mise.toml` を指定した `mise install`

HomebrewまたはBrewfileが見つからない場合、該当処理はログを出してスキップします。`install.sh` を経由しないchezmoi適用ではmiseがない場合もスキップします。miseの処理は `CHEZMOI_SKIP_MISE_INSTALL=1` でもスキップできます。

### 周辺ツール

次の処理は初回適用時に実行されます。

- `run_once_install-zinit.sh.tmpl`:
  `${XDG_DATA_HOME:-$HOME/.local/share}/zinit/bin` がなければcloneします。
- `run_once_install-tpm.sh.tmpl`:
  `~/.config/tmux/plugins/tpm` がなければcloneします。
- `run_once_install-lazy-nvim.sh.tmpl`:
  `~/.local/share/nvim/lazy/lazy.nvim` がなければcloneします。

これらは `run_once` のため、スクリプトの内容を更新しても適用済み環境では自動的に再実行されません。なお、zinitとlazy.nvimにはアプリケーション起動時のbootstrap処理もあります。

### fzf

`run_onchange_install-fzf.sh.tmpl` は、Homebrew配下のfzfインストーラーを次のオプションで実行します。

```text
--key-bindings --completion --no-fish --no-update-rc
```

Homebrewまたはfzfのインストーラーが見つからない場合はスキップします。

### GitHub用SSH鍵

`run_once_after_30_setup-github-ssh-key.sh.tmpl` は次の処理を行います。

1. `~/.ssh` を作成し、権限を `700` にする
2. `~/.ssh/id_ed25519_github` がなければed25519鍵を作成する
3. 利用可能なssh-agentへ鍵を追加する
4. GitHub CLIのログインを確認し、公開鍵が未登録の場合だけGitHubへ追加する

鍵のコメントにはグローバルGit設定のメールアドレスを使います。取得できない場合は `${USER}@$(hostname)` を使います。秘密鍵はパスフレーズなしで作成されるため、端末とホームディレクトリの保護が前提です。

`install.sh` を経由した初回セットアップでは、GitHub CLIの導入とログインを済ませてからこの処理へ進みます。`install.sh` を経由しないchezmoi適用では、GitHub CLIがない、または未ログインの場合、GitHubへの登録だけをスキップします。ssh-agentがない場合もagentへの追加だけをスキップします。

## 更新

通常の更新は次のコマンドで行います。

```bash
chezmoi update --apply
```

`mise.toml` には同じ処理を実行する `up` タスクがあります。

```bash
mise run up
```

適用前の差分確認には `chezmoi diff` を使用します。

## 再実行と復旧

- `run_onchange` はスクリプトまたはテンプレート入力の変更時に再実行されます。
- `run_once` は適用履歴に記録され、通常の再適用では実行されません。
- 周辺ツールを再導入する場合は、chezmoiの実行履歴と対象ディレクトリの状態を確認してから個別に復旧してください。
- 適用に失敗した場合はログの最初のエラーを確認し、`chezmoi diff` で未適用差分を確認してから再実行してください。

このリポジトリには一括アンインストール処理はありません。設定を外す場合は、chezmoiの管理状態とHomebrewで導入されたパッケージを分けて確認してください。
