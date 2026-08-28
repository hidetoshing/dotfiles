# 開発・検証ガイド

## 基本方針

このリポジトリの変更は、複数の端末やOSへ波及します。ホームディレクトリの展開済みファイルではなく、リポジトリの `home/` 配下を編集してください。

変更前に、対象設定の読み込み元、展開先、OS条件、自動実行のタイミングを確認します。

## 変更の流れ

1. `git status --short` で既存の作業差分を確認する
2. 対象のsourceと関連文書を確認する
3. `home/`、mise設定などの正本を変更する
4. 変更種別に応じた静的検証を行う
5. `chezmoi diff` で展開結果を確認する
6. 安全な場合だけdry-runまたは実適用を行う
7. READMEまたは `docs/` の対応文書を同期する
8. `git diff --check` と最終差分確認を行う

## chezmoiの確認

### 差分確認

```bash
chezmoi diff
```

このコマンドは、sourceと現在のホームディレクトリとの差分を表示します。意図しない既存差分が含まれる場合は、今回の変更と区別してください。

### dry-run

```bash
chezmoi apply --dry-run --verbose
```

実行スクリプト、パッケージ導入、SSH鍵などの副作用を伴う可能性があるため、出力を確認してから実適用してください。dry-runで外部コマンドの実際の動作までは保証できません。

### OS分岐

macOS固有の変更では次を確認します。

- `mise.toml` で `os = "macos"` を指定すべき依存か
- `home/.chezmoiignore` でLinuxから除外すべきか
- テンプレート内で `.chezmoi.os` またはデータ変数を使うべきか

両OSを用意できない場合は、未確認側の展開結果とリスクを作業報告へ記載します。

## Shellスクリプト

テンプレート構文を含まないBashスクリプトは構文確認します。

```bash
bash -n install.sh
```

ShellCheckが利用可能な場合は、対象ファイルへ実行します。

```bash
shellcheck install.sh
```

`.tmpl` はGo template構文を含むため、そのまま `bash -n` に渡せない場合があります。chezmoiで展開した結果を確認し、生成されたShellを検証してください。

スクリプトでは次を重点的に確認します。

- `set -euo pipefail`
- 引数とパスのquote
- コマンドがない場合の挙動
- 再実行時の挙動
- エラー時のログ
- macOS/Linuxのコマンド差
- 外部サービスや認証情報への副作用

## mise

リポジトリ直下の `mise.toml` と、ホームへ展開する `home/dot_config/mise/config.toml` は用途が異なります。

- 直下: dotfiles適用中に使うHomebrewパッケージ、ランタイム、リポジトリタスク
- `home/dot_config/mise/config.toml`: 利用者のグローバル設定

変更時は、どちらへ置く設定かを確認し、利用可能であれば次を実行します。

```bash
mise bootstrap plan
mise bootstrap --only packages,tools --dry-run
mise tasks validate
```

`mise bootstrap` の実適用はパッケージやアプリを導入するため、検証目的ではdry-runに留めてください。

## Neovim

利用可能であればLuaのフォーマットとlintを実行します。

```bash
stylua --check home/dot_config/nvim
selene home/dot_config/nvim
```

Neovimの起動確認は高い検証効果がありますが、lazy.nvimやMasonがプラグイン・ツールをダウンロードする可能性があります。ネットワークとホームディレクトリへの変更を許容できる環境で行ってください。

## Markdown

- 相対リンクのリンク先が存在することを確認する
- READMEには利用者の導入・更新・復旧に必要な内容だけを置く
- 実装構造や詳細設定は対応する `docs/` へ置く
- コマンド例が現在のスクリプトや設定と一致することを確認する

## ドキュメントの更新先

- `install.sh`、自動実行スクリプト:
  `README.md`、`docs/installation.md`、必要に応じて `docs/architecture.md`
- `.chezmoiroot`、`.chezmoiignore`、テンプレートデータ:
  `docs/architecture.md`
- Shell、Git、tmux、starship、WezTerm、mise:
  `docs/configuration.md`
- `home/dot_config/nvim/`:
  `docs/neovim.md`
- 検証手順や開発規約:
  `AGENTS.md`、`docs/development.md`

## 最終確認

最低限、次を実行します。

```bash
git diff --check
git status --short
```

最終報告には、変更概要、検証したコマンドと結果、未確認事項、既存環境への影響を含めます。
