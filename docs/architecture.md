# リポジトリアーキテクチャ

## 概要

このリポジトリは、chezmoiによるファイル展開と、mise bootstrapによるHomebrewパッケージ・ランタイム管理を組み合わせています。

```text
install.sh
  ├─ mise.runからmiseを準備
  └─ Homebrew
      ├─ chezmoi、ghを準備
      ├─ gh auth login（未ログインの場合）
      └─ chezmoi init/update --apply
          ├─ mise bootstrapでパッケージとランタイムを収束
          ├─ home/ の設定をホームディレクトリへ展開
          └─ run_before/run_once/run_onchangeで周辺ツールを準備
```

## 主要ファイル

| パス | 役割 |
| --- | --- |
| `install.sh` | mise、Homebrew、chezmoi、ghを準備し、初期化または更新を実行 |
| `.chezmoiroot` | chezmoiのsource rootを `home/` に設定 |
| `home/` | ホームディレクトリへ展開する設定と実行スクリプト |
| `home/.chezmoi.toml.tmpl` | OS判定と端末ごとのGitユーザー情報をテンプレートデータとして定義 |
| `home/.chezmoiignore` | OS別の除外と生成キャッシュの除外を定義 |
| `mise.toml` | Homebrew formula、macOS cask、ランタイム、リポジトリタスク |
| `docs/` | 実装仕様と保守手順 |

## chezmoiのマッピング

`.chezmoiroot` の値は `home` です。このため、chezmoiは `home/` をsource rootとして解釈します。

代表的なマッピングは次のとおりです。

| source | 展開先 |
| --- | --- |
| `home/dot_zshenv` | `~/.zshenv` |
| `home/dot_config/git/config.tmpl` | `~/.config/git/config` |
| `home/dot_config/nvim/` | `~/.config/nvim/` |
| `home/run_before_*.sh.tmpl` | 各適用のファイル展開前に実行 |
| `home/run_once_*.sh.tmpl` | テンプレート展開後に初回実行 |
| `home/run_onchange_*.sh.tmpl` | 内容の変更時に実行 |

ホームディレクトリ側の展開済みファイルは生成物であり、リポジトリでは `home/` 配下を正本とします。

## 適用ライフサイクル

### 管理ファイル

通常の設定ファイルはchezmoiがホームディレクトリへ展開します。既存ファイルとの差分は `chezmoi diff` で確認できます。

### `run_once`

初回導入だけが必要なbootstrapに使います。このリポジトリではzinit、TPM、lazy.nvim、GitHub用SSH鍵を対象にしています。

スクリプトの実行後に内容を変更しても、既存環境での再実行は保証されません。継続的に同期すべき処理には使用しません。

### `run_onchange`

スクリプトやテンプレート入力が変更されたときに再実行します。fzfセットアップに使っています。

### `run_before`

`run_before_20_bootstrap-packages.sh.tmpl` はchezmoiを適用するたびに、ファイル展開より先に `mise bootstrap --only packages,tools` を実行します。処理は冪等で、導入済みの項目はmiseがスキップします。

`install.sh` はchezmoi適用前にmise、chezmoi、ghとGitHub認証を準備します。パッケージ処理には `before_20` プレフィックスを付け、その他の周辺ツールが必要とするコマンドを先に用意します。SSH鍵処理には `after_30` を付けています。

## OS分岐

`home/.chezmoi.toml.tmpl` はchezmoiのOS情報から、次の値を生成します。

- `.is_darwin`
- `.is_linux`

加えて初回の設定生成時にGitのユーザー情報を入力し、端末ごとのchezmoi設定へ保存します。

- `.git.name`
- `.git.email`

これらは `home/dot_config/git/config.tmpl` の展開に使われ、
会社用PCと自宅PCの値をリポジトリへ含めずに切り替えます。

macOS専用パッケージは `mise.toml` の `os = "macos"` で切り替えます。
`.chezmoiignore` はmacOS以外で `dot_config/wezterm/**` を除外します。

OS固有の設定を追加するときは、miseのOS条件、テンプレート、ignoreのどこで分岐するかを明確にしてください。

## 依存関係の責務

### Homebrew

mise bootstrapの `brew:` と `brew-cask:` managerがHomebrew互換のプレフィックスを使用します。既存のHomebrewと併存でき、`install.sh` はchezmoiとghの初期導入、fzfの補完生成にもHomebrewコマンドを使用します。

### mise

リポジトリ直下の `mise.toml` は、chezmoi適用中のHomebrew formula、macOS cask、ランタイムの導入と `up` タスクに使われます。ホームへ展開される
`home/dot_config/mise/config.toml` は、利用者のグローバルmise設定です。
両者は用途が異なります。

`install.sh` は初回セットアップの前提としてmise.runから `~/.local/bin/mise` を導入します。mise自体は `[bootstrap.packages]` に含めません。パッケージスクリプトは、miseコマンドが利用可能な場合に対象をパッケージとツールへ限定して `mise bootstrap` を実行します。

### アプリケーションbootstrap

zinitとlazy.nvimは `run_once` による導入に加え、それぞれの設定側にも
未導入時のbootstrapがあります。通常は `run_once` が先に導入し、
設定側の処理はフォールバックとして機能します。

## 管理対象外

- 秘密鍵、アクセストークン、Cookie
- シェルや補完が生成するキャッシュ
- Neovimプラグイン本体など、各ツールのデータディレクトリ
- 端末ごとのローカルなzsh追加設定

生成物や秘密情報を新たに管理対象へ加える場合は、必要性と安全性を先に確認してください。
