# インストール・更新仕様

## 目的

この文書は、`install.sh` とchezmoiのスクリプトが行う処理、前提条件、副作用、再実行時の挙動を説明します。

## 対応OS

`install.sh` が受け付けるOSは次のとおりです。

- Apple Silicon搭載macOS:
  `/opt/homebrew/bin/brew` を探索し、macOS用caskとWezTerm設定を適用します。
- Linux:
  `/home/linuxbrew/.linuxbrew/bin/brew` を探索し、
  caskとWezTerm設定を除外します。

Intel Mac、DarwinとLinux以外では、未対応環境としてインストールを終了します。

## 前提条件

- `bash`
- `curl`
- `git`
- mise.runへ接続できるネットワーク
- Homebrewの導入に必要な権限
- GitHubおよびHomebrewへ接続できるネットワーク

Homebrewがない場合は、公式インストールスクリプトを `NONINTERACTIVE=1` で実行します。

## `install.sh` の処理

### 1. miseの確認

mise.runの公式インストーラーを実行し、`~/.local/bin/mise` を導入または更新します。
既に同じバージョンがある場合は `MISE_INSTALL_SKIP_IF_EXISTS=1` により再導入を
スキップします。インストール後は `~/.local/bin` を現在のプロセスの `PATH`
先頭へ追加し、以降の処理ではこのmiseを使用します。

既存のHomebrew版miseは自動削除しません。新しいシェルでも
`~/.local/bin` がHomebrewのパスより優先されるため、動作確認後に不要であれば
`brew uninstall mise` で削除できます。

### 2. Homebrewの確認

現在の `PATH` にある `brew` を優先し、見つからなければOS別の既定パスを
探索します。見つからない場合はHomebrewを導入し、`brew shellenv` を
現在のプロセスへ反映します。

### 3. セットアップ用コマンドの確認

`chezmoi` と `gh` がなければ、それぞれHomebrewで導入します。

mise本体はHomebrewの管理対象に含めません。Node.jsとPythonは、後続のchezmoi適用時に `mise bootstrap` で導入します。

### 4. GitHub CLIの認証

`gh auth status -h github.com` でログイン状態を確認します。未ログインの場合は、SSH鍵の生成・登録を後続スクリプトに任せるため、次のコマンドでログインします。

```bash
gh auth login -h github.com -p ssh --skip-ssh-key --web
```

対話可能な端末がない場合は、復旧コマンドを表示してセットアップを中断します。対象マシンの対話可能な端末で次を実行してから、セットアップを再実行してください。

```bash
gh auth login -h github.com -p ssh --skip-ssh-key
```

### 5. sourceの初期化または更新

- `~/.local/share/chezmoi` が存在する場合: `chezmoi update --init --apply`
- 存在しない場合: `chezmoi init --apply hidetoshing`

初回の設定生成時に、Gitの `user.name` と `user.email` を入力します。
入力値は端末ごとのchezmoi設定へ保存され、Git設定テンプレートの展開に使われます。
既存のchezmoi設定に値がない場合は、`update --init` による設定再生成時に入力します。
この入力には対話可能な端末が必要です。

既存ディレクトリがこのリポジトリを指しているかは判定しません。
別のchezmoi sourceを利用している場合は、インストール前に
`chezmoi source-path` などで確認してください。

## chezmoi適用時の自動処理

### パッケージ

`run_before_20_bootstrap-packages.sh.tmpl` が、chezmoiを適用するたびに次を実行します。

1. リポジトリルートと `mise.toml` の検出
2. `~/.local/bin/mise` を優先したmiseコマンドの検出
3. `mise bootstrap --only packages,tools --yes` によるパッケージとランタイムの収束

`[bootstrap.packages]` にはmacOS/Linux共通のHomebrew formulaと、macOSだけを対象にしたcaskを定義します。miseまたは `mise.toml` が見つからない場合はログを出してスキップします。

一時的に処理を止める場合は `CHEZMOI_SKIP_MISE_BOOTSTRAP=1` を指定します。旧変数 `CHEZMOI_SKIP_MISE_INSTALL=1` も互換オプションとして受け付けます。

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
chezmoi update --init --apply
```

`mise.toml` には同じ処理を実行する `up` タスクがあります。

```bash
mise run up
```

Gitのユーザー名またはメールアドレスを変更する場合は、設定ファイルを再生成してから適用します。

```bash
chezmoi init --prompt
chezmoi apply
```

適用前の差分確認には `chezmoi diff` を使用します。

## 再実行と復旧

- `run_onchange` はスクリプトまたはテンプレート入力の変更時に再実行されます。
- `run_before` のパッケージ処理は適用のたびに実行され、導入済みの項目はmiseがスキップします。
- `run_once` は適用履歴に記録され、通常の再適用では実行されません。
- 周辺ツールを再導入する場合は、chezmoiの実行履歴と対象ディレクトリの状態を確認してから個別に復旧してください。
- 適用に失敗した場合はログの最初のエラーを確認し、`chezmoi diff` で未適用差分を確認してから再実行してください。

このリポジトリには一括アンインストール処理はありません。設定を外す場合は、chezmoiの管理状態とHomebrewで導入されたパッケージを分けて確認してください。
