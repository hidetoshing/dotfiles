# リポジトリアーキテクチャ

## 概要

このリポジトリは、chezmoiによるファイル展開、Homebrewによるパッケージ管理、miseによるランタイム管理を組み合わせています。

```text
install.sh
  └─ Homebrew
      └─ chezmoi init/update --apply
          ├─ home/ の設定をホームディレクトリへ展開
          ├─ Brewfileからパッケージを導入
          ├─ 利用可能な場合はmise install
          └─ run_once/run_onchangeで周辺ツールを準備
```

## 主要ファイル

| パス | 役割 |
| --- | --- |
| `install.sh` | Homebrewとchezmoiを準備し、初期化または更新を実行 |
| `.chezmoiroot` | chezmoiのsource rootを `home/` に設定 |
| `home/` | ホームディレクトリへ展開する設定と実行スクリプト |
| `home/.chezmoi.toml.tmpl` | `is_darwin`、`is_linux` のテンプレートデータを定義 |
| `home/.chezmoiignore` | OS別の除外と生成キャッシュの除外を定義 |
| `Brewfile` | macOS/Linux共通のHomebrewパッケージ |
| `Brewfile.darwin` | macOS専用のcask |
| `mise.toml` | リポジトリのセットアップで使うランタイムとタスク |
| `docs/` | 実装仕様と保守手順 |

## chezmoiのマッピング

`.chezmoiroot` の値は `home` です。このため、chezmoiは `home/` をsource rootとして解釈します。

代表的なマッピングは次のとおりです。

| source | 展開先 |
| --- | --- |
| `home/dot_zshenv` | `~/.zshenv` |
| `home/dot_config/git/config` | `~/.config/git/config` |
| `home/dot_config/nvim/` | `~/.config/nvim/` |
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

スクリプトやテンプレート入力が変更されたときに再実行します。パッケージ導入とfzfセットアップに使っています。

パッケージ処理には `before_20` プレフィックスを付け、周辺ツールが必要とするコマンドを先に用意します。SSH鍵処理には `after_30` を付けています。

## OS分岐

`home/.chezmoi.toml.tmpl` はchezmoiのOS情報から、次の値を生成します。

- `.is_darwin`
- `.is_linux`

パッケージ導入テンプレートは `.chezmoi.os` を直接参照して、
macOS専用Brewfileを切り替えます。`.chezmoiignore` はmacOS以外で
`dot_config/wezterm/**` を除外します。

OS固有の設定を追加するときは、Brewfile、テンプレート、ignoreのどこで分岐するかを明確にしてください。

## 依存関係の責務

### Homebrew

OSで直接使用するCLI、エディタ、ターミナル、Docker関連ツールを管理します。macOSのGUIアプリは `Brewfile.darwin` に分離します。

### mise

リポジトリ直下の `mise.toml` は、chezmoi適用中のランタイム導入と
`up` タスクに使われます。ホームへ展開される
`home/dot_config/mise/config.toml` は、利用者のグローバルmise設定です。
両者は用途が異なります。

現状のパッケージスクリプトは、miseコマンドが既に利用可能な場合だけ `mise install` を実行します。

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
