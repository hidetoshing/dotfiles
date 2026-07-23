# dotfiles

macOSとLinuxの開発環境を、[chezmoi](https://www.chezmoi.io/)でセットアップ・管理するための個人用dotfilesです。

HomebrewによるCLI導入、Shell、Git、tmux、Herdr、Neovimなどの設定をまとめて適用します。既存のホームディレクトリへ設定ファイルを展開するため、内容を確認した上で使用してください。

## 対応環境

- macOS
- Linux
- `bash`、`curl`、`git`を実行できる環境
- Homebrewの導入に必要な権限とネットワーク接続

macOSではCLIに加えてWezTerm、Docker Desktop、NeovideなどのGUIアプリも導入します。LinuxではcaskとWezTerm設定を適用しません。

## インストール前の注意

インストールすると、次の変更が行われます。

- Homebrewがない場合は、公式インストーラーでHomebrewを導入します。
- chezmoiからホームディレクトリへ設定ファイルを適用します。
- Brewfileに定義されたパッケージを導入します。
- zinit、TPM、lazy.nvimをそれぞれのデータディレクトリへcloneします。
- `~/.ssh/id_ed25519_github` がなければ、パスフレーズなしのGitHub用SSH鍵を作成します。
- GitHub CLIでGitHubへログインしてから、作成した公開鍵をGitHubへ登録します。

既存のchezmoi sourceが `~/.local/share/chezmoi` にある場合、
インストーラーはそのsourceに対して `chezmoi update --init --apply` を実行します。
別のdotfilesをchezmoiで管理している環境では、実行前にsourceを確認してください。

## クイックスタート

```bash
curl -fsSL \
  https://raw.githubusercontent.com/hidetoshing/dotfiles/master/install.sh | bash
```

インストーラーは次の順序で処理します。

1. OSを判定し、必要であればHomebrewを導入する
2. `chezmoi`、`mise`、`gh` コマンドをHomebrewで導入する
3. GitHub CLIが未ログインなら `gh auth login` を実行する
4. 新規環境ではGitのユーザー名とメールアドレスを入力し、`chezmoi init --apply hidetoshing` を実行する
5. 既存環境では `chezmoi update --init --apply` を実行し、未設定の場合はGitのユーザー名とメールアドレスを入力する
6. chezmoiのスクリプトからパッケージや関連ツールをセットアップする
7. `mise.toml` に定義されたNode.jsとPythonを `mise install` で導入する

GitHub CLIのログインとGitユーザー情報の初回入力には、対話可能な端末が必要です。非対話環境だけでは初期設定を完了できないため、対象マシンの対話可能な端末から実行してください。詳細は[インストール仕様](docs/installation.md)を参照してください。

## インストール後の確認

新しいシェルを起動して、主要ツールを確認します。

```bash
chezmoi --version
git --version
nvim --version
tmux -V
herdr --version
```

GitHubに `~/.ssh/id_ed25519_github.pub` が登録されていることも確認してください。

## 設定を更新する

リモートの変更を取得して適用するには、次のいずれかを実行します。

```bash
chezmoi update --init --apply
```

```bash
mise run up
```

適用前に差分だけを確認する場合は、次を実行します。

```bash
chezmoi diff
```

Gitのユーザー名とメールアドレスは各端末のchezmoi設定に保存されます。
値を変更する場合は `chezmoi init --prompt` を実行して再入力してから、
`chezmoi apply` を実行してください。

chezmoiのパッケージ処理は `mise.toml` に定義されたランタイムを導入します。一時的にスキップするには、次のように適用します。

```bash
CHEZMOI_SKIP_MISE_INSTALL=1 chezmoi apply
```

## ローカル固有の設定

管理対象の設定を上書きせずに端末固有の設定を追加できます。

- `~/.zprofile`: zshログイン時のローカル設定
- `~/.zshrc`: zsh対話起動時のローカル設定
- `~/.zshalias`: ローカルのzshエイリアス

これらは管理対象の共通設定から、存在する場合だけ読み込まれます。

## ドキュメント

- [インストール・更新仕様](docs/installation.md)
- [リポジトリアーキテクチャ](docs/architecture.md)
- [各設定の仕様](docs/configuration.md)
- [Neovim設定](docs/neovim.md)
- [開発・検証ガイド](docs/development.md)

## ライセンス

[MIT License](LICENSE)
