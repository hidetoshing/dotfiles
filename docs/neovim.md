# Neovim設定

## 概要

Neovim設定は `home/dot_config/nvim/` で管理し、`~/.config/nvim/` へ展開します。プラグイン管理にはlazy.nvim、外部開発ツールの管理にはMasonを使用します。

## 起動処理

`init.lua` は次の順で初期化します。

1. 利用可能な場合はLua module loaderを有効化
2. 使用しない組み込みプラグインとproviderを無効化
3. `config.settings` を読み込む
4. `config.lazy` からプラグインを読み込む

lazy.nvimがデータディレクトリにない場合、stable branchを
`~/.local/share/nvim/lazy/lazy.nvim` へcloneします。chezmoiの
`run_once_install-lazy-nvim.sh.tmpl` も同じ場所へ導入するため、
起動時処理はフォールバックとして機能します。

## ディレクトリ構成

```text
home/dot_config/nvim/
├─ init.lua
├─ after/lsp/            # LSP server固有設定
└─ lua/
   ├─ config/            # 共通設定とlazy.nvim初期化
   └─ plugins/
      ├─ automation/     # タスク実行
      ├─ coding/         # LSP、補完、診断、品質管理
      ├─ editor/         # 編集とsyntax
      ├─ git/            # Git連携
      ├─ integrations/   # AI・Obsidianなど外部連携
      ├─ navigation/     # ファイル探索と移動
      └─ ui/             # テーマと表示
```

プラグインは製品名ではなく責務で分類します。新しいプラグインは最も近い責務のファイルへ追加し、責務が独立している場合だけファイルを増やしてください。

## OS分岐

Obsidian関連のプラグインはmacOSでのみ読み込みます。その他のプラグインカテゴリは共通です。

## AIエージェント

`agentic.nvim`をACPクライアントとして使用します。既定では`codex-acp`が
実行可能な場合はCodexを選択し、それ以外ではClaude Agent ACPを選択します。

端末ごとに使用可能なエージェントが異なる場合は、chezmoiで管理しない次の
ローカル設定ファイルを作成します。

```text
~/.config/nvim/local/agentic.lua
```

このファイルは`agentic.nvim`の部分設定をLua tableとして返します。共通設定へ
deep mergeされるため、端末固有のproviderだけを指定できます。

```lua
return {
    provider = "opencode-acp",
}
```

ファイルが存在しない場合は既定のprovider選択を使用します。ファイルの読み込み、
実行、または戻り値に問題がある場合は警告を表示し、既定の設定へフォールバック
します。API keyなどの秘密情報はファイルへ直接記述せず、必要な場合は環境変数を
参照してください。

### Ollamaを使用する場合

`agentic.nvim`からOllamaを利用する場合は、ACP providerとしてOpenCodeを介します。
OllamaとOpenCodeは端末固有の依存関係とし、共通の `mise.toml` では導入しません。

```bash
ollama --version
ollama list
opencode --version
```

OpenCodeを導入していない端末では、公式の導入方法に従ってインストールします。
Homebrewを使用する場合は次のコマンドで導入できます。

```bash
brew install opencode
```

Ollama providerと既定モデルは`~/.config/opencode/opencode.json`で設定します。
`<ollama-model-id>`は`ollama list`に表示される、tool callingに対応したモデルIDへ
置き換えてください。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/<ollama-model-id>",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "<ollama-model-id>": {
          "name": "Ollama local model"
        }
      }
    }
  }
}
```

コーディングエージェントは長いcontextを必要とします。モデルが対応する範囲で
Ollamaのcontext lengthを十分に確保してください。設定後はNeovimを再起動し、
次のコマンドでproviderと実行ファイルを確認します。

```vim
:checkhealth agentic
```

## LSP

Masonとmason-lspconfigで次の代表的なserverを導入・有効化します。

- Autotools
- Bash
- GitHub Copilot
- Docker / Docker Compose
- HTML
- Lua
- Markdown
- Python
- Rust
- JavaScript / TypeScript
- Vue

Go用のgoplsは現在コメントアウトされています。server固有の調整は `after/lsp/` に配置します。

補完プラグインが利用可能な場合は、そのcapabilitiesをLSPへ渡します。

## Formatter

conform.nvimを使用し、主に次を対応付けています。

| 種別 | Formatter |
| --- | --- |
| Python | Ruff |
| Lua | StyLua |
| Shell | shfmt |
| HTML / JavaScript / TypeScript / Vue | Prettier |
| YAML | yamlfmt |
| Markdown | Prettier |

保存時の自動フォーマットは既定で無効です。

| コマンド | 動作 |
| --- | --- |
| `:Format` | 現在のbufferを同期的にフォーマット |
| `:Format!` | 現在のbufferを非同期にフォーマット |
| `:FormatEnable` | 自動フォーマットを再度有効化 |
| `:FormatDisable` | 全体の自動フォーマットを無効化 |
| `:FormatDisable!` | 現在のbufferだけ無効化 |

## Linter

nvim-lintを使用し、buffer保存後に対象filetypeのLinterを実行します。手動実行には `:Lint` を使用します。

主な対応はRuff、Selene、ShellCheck、zsh、markuplint、eslint_d、hadolint、yamllint、markdownlint-cli2、checkmakeです。

Goには `golangcilint` の対応付けがありますが、Masonの自動導入リストでは現在コメントアウトされています。

## Masonによるツール導入

FormatterとLinterの設定読込時にMason registryを更新し、未導入の対象パッケージを非同期で導入します。registryの更新に失敗した場合は警告を表示し、その回の自動導入をスキップします。

Neovim初回起動時はプラグインや外部ツールの取得にネットワークアクセスが発生します。

## 基本設定

- leader keyは `,`
- Neovim 0.9以降ではLua module loaderを有効化
- netrwなど、代替プラグインを使う組み込み機能を無効化
- PerlとRuby providerを無効化

通常起動時はneo-treeのファイルツリーを左側へ自動表示します。標準入力を
読み込む場合、diffモード、およびGitのコミットやrebaseなどで一時エディタ
として起動された場合は、編集を妨げないように自動表示しません。ファイルを
指定して起動した場合は、ファイルツリーを表示しつつ編集bufferへフォーカスを
残します。

| キーマップ | 動作 |
| --- | --- |
| `<leader>ee` | 左側にファイルツリーを表示 |
| `<leader>ef` | フローティング表示でファイルツリーを表示 |
| `<leader>eq` | ファイルツリーを閉じる |
| `<leader>eb` | bufferツリーを表示 |
| `<leader>eg` | Git statusツリーをフローティング表示 |

具体的なキーマップは複数のプラグインファイルに分散しています。Neovim内でキーマップ一覧を参照する場合は、設定済みのTelescope keymapsなどを利用してください。

## 変更時の確認

変更内容に応じて次を確認します。

```bash
stylua --check home/dot_config/nvim
selene home/dot_config/nvim
```

これらのコマンドが利用できない環境では、NeovimのMason管理下にだけ存在する可能性があります。ヘッドレス起動はプラグイン導入やregistry更新を発生させることがあるため、外部通信を許容できる環境で実施してください。
