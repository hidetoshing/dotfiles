# dotfiles

macOSとLinuxの開発環境を、[chezmoi](https://www.chezmoi.io/)でセットアップ・管理するための個人用dotfilesです。

HomebrewによるCLI導入、Shell、Git、tmux、Neovimなどの設定をまとめて適用します。既存のホームディレクトリへ設定ファイルを展開するため、内容を確認した上で使用してください。

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
- GitHub CLIがログイン済みの場合は、作成した公開鍵をGitHubへ登録します。

既存のchezmoi sourceが `~/.local/share/chezmoi` にある場合、
インストーラーはそのsourceに対して `chezmoi update --apply` を実行します。
別のdotfilesをchezmoiで管理している環境では、実行前にsourceを確認してください。

## クイックスタート

```bash
curl -fsSL \
  https://raw.githubusercontent.com/hidetoshing/dotfiles/master/install.sh | bash
```

インストーラーは次の順序で処理します。

1. OSを判定し、必要であればHomebrewを導入する
2. chezmoiをHomebrewで導入する
3. 新規環境では `chezmoi init --apply hidetoshing` を実行する
4. 既存環境では `chezmoi update --apply` を実行する
5. chezmoiのスクリプトからパッケージや関連ツールをセットアップする

miseによるランタイム導入やGitHubへの公開鍵登録など、前提条件を満たさない処理はエラーにせずスキップされる場合があります。詳細は[インストール仕様](docs/installation.md)を参照してください。

## インストール後の確認

新しいシェルを起動して、主要ツールを確認します。

```bash
chezmoi --version
git --version
nvim --version
tmux -V
```

GitHubへのSSH鍵登録がスキップされた場合は、`gh auth login` 後にインストール時のログに表示されたコマンドを実行してください。

## 設定を更新する

リモートの変更を取得して適用するには、次のいずれかを実行します。

```bash
chezmoi update --apply
```

```bash
mise run up
```

適用前に差分だけを確認する場合は、次を実行します。

```bash
chezmoi diff
```

miseが利用可能な場合、chezmoiのパッケージ処理は `mise.toml` に定義されたランタイムを導入します。一時的にスキップするには、次のように適用します。

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
