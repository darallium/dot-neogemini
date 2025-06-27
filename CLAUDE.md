# プロジェクトの進行について
CLAUDE.ja.mdにすべて記載されているのでそれを最優先で進行しなさい。ultrathink


# lspconfigの変更点

## 概要
`nvim-lspconfig`のAPIが非推奨となり、Neovim 0.11からコア機能として提供される`vim.lsp.config()`と`vim.lsp.enable()`の使用が推奨されています。
また、`vim.lsp.diagnostic`関連の関数は`vim.diagnostic`モジュールに移行しました。

## 主な変更点

### 1. `nvim-lspconfig` APIの非推奨化

`nvim-lspconfig`のプログラマティックAPIは非推奨となりました。
これには、`util`モジュール内の以下の関数などが含まれます。

- `util.get_lsp_clients`
- `util.add_hook_before/after`
- `util.get_active_client_by_name`
- `util.path.join`
- `util.path.path_separator`
- `util.path.iterate_parents`

### 2. Neovim 0.11での`vim.lsp.config`の導入

Neovim 0.11以降、LSPの設定は`vim.lsp.config()`と`vim.lsp.enable()`で行うことが推奨されています。
これにより、LSPのセットアップが簡素化されます。

### 3. `mason.nvim`と`mason-lspconfig.nvim`禁止

`mason.nvim`と`mason-lspconfig.nvim`のメジャーアップデートにより、破壊的変更が加えられました。
使用は禁止です。
ただし、メジャーなlspに関する部分は実装しなさい。

### 4. `vim.lsp.diagnostic`から`vim.diagnostic`への移行

以下の`vim.lsp.diagnostic`関数は非推奨となり、`vim.diagnostic`モジュールの関数を使用する必要があります。

- `vim.lsp.diagnostic.clear()` -> `vim.diagnostic.hide()`
- `vim.lsp.diagnostic.disable()` -> `vim.diagnostic.disable()`
- `vim.lsp.diagnostic.display()` -> `vim.diagnostic.show()`
- `vim.lsp.diagnostic.get_all()` -> `vim.diagnostic.get()`

## 対応方針

現在、`lsp.lua`では`lspconfig.SERVER.setup`の形式で各LSPサーバーを設定しています。
これを新しい`vim.lsp.config()`と`vim.lsp.enable()`を使用する形式に移行する必要があります。
また、`on_attach`関数内などで古いAPIを使用している箇所があれば、それらも更新する必要があります。

## 削除に関する注意点

- API非推奨化に伴い、使用されなくなった関数やモジュールは完全に削除するか、コメントアウトする必要がある
- 古いLSP設定関数は段階的に削除し、新しいAPIに置き換える
- 不要になったプラグインや設定は、設定ファイルから完全に削除する
- 削除する際は、代替手段や新しい推奨アプローチを必ず確認すること

# LuaCATSタイプアノテーション仕様

## 概要
LuaCATS（Lua Comment And Type System）は、Lua Language Server（`lua_ls`）が解析する型注釈システムです。
特別なコメント形式で型情報を提供し、LSPの機能を向上させます。

## 基本構文

```lua
--- トリプルダッシュで始まる特別なコメント
---@annotation_name type_info description
```

## 主要な注釈タイプ

### 1. クラス・テーブル定義
```lua
---@class MyClass
---@field name string 名前
---@field age integer 年齢
---@field items string[] アイテムリスト
local MyClass = {}
```

### 2. 関数パラメータと戻り値
```lua
---@param name string プレイヤー名
---@param level integer レベル
---@param options? table オプション設定（任意）
---@return Player player 作成されたプレイヤー
---@return boolean success 成功フラグ
function create_player(name, level, options)
end
```

### 3. 変数の型宣言
```lua
---@type string[]
local file_list = {}

---@type table<string, function>
local handlers = {}
```

### 4. ジェネリック型
```lua
---@generic T
---@param items T[]
---@param predicate fun(item: T): boolean
---@return T[]
function filter(items, predicate)
end
```

### 5. その他の重要注釈
```lua
---@alias PlayerState "idle" | "moving" | "attacking"
---@enum Direction
local Direction = {
    UP = 1,
    DOWN = 2,
    LEFT = 3,
    RIGHT = 4
}

---@overload fun(name: string): Player
---@overload fun(name: string, level: integer): Player
function Player.new(name, level)
end

---@deprecated Use new_function instead
---@nodiscard
function old_function()
end
```

## Neovim設定で付けるべき注釈

### 1. LSP設定関連
```lua
---@class LspConfig
---@field capabilities table LSP capabilities
---@field on_attach fun(client: vim.lsp.Client, bufnr: integer) Attach handler

---@param client vim.lsp.Client
---@param bufnr integer
function on_attach(client, bufnr)
end

---@param server_name string
---@param config table
function setup_server(server_name, config)
end
```

### 2. キーマッピング関連
```lua
---@class KeymapOpts
---@field desc string 説明
---@field buffer? integer バッファID
---@field silent? boolean サイレント実行
---@field noremap? boolean リマップ無効

---@param mode string|string[] キーマップモード
---@param lhs string キー
---@param rhs string|function コマンド
---@param opts? KeymapOpts オプション
function set_keymap(mode, lhs, rhs, opts)
end
```

### 3. プラグイン設定関連
```lua
---@class PluginSpec
---@field [1] string プラグインURL
---@field dependencies? string[] 依存プラグイン
---@field config? function|boolean 設定関数
---@field event? string|string[] 読み込みイベント
---@field cmd? string|string[] コマンド
---@field ft? string|string[] ファイルタイプ
---@field keys? string|string[] キー
---@field lazy? boolean 遅延読み込み

---@type PluginSpec[]
local plugins = {}
```

### 4. 設定オプション関連
```lua
---@class VimOptions
---@field number boolean 行番号表示
---@field relativenumber boolean 相対行番号
---@field tabstop integer タブサイズ
---@field shiftwidth integer インデントサイズ

---@param options VimOptions
function apply_options(options)
end
```

## 型注釈のベストプラクティス

### 1. 必須項目
- すべてのpublic関数に`@param`と`@return`を付ける
- 複雑なテーブル構造には`@class`を定義
- グローバル変数には`@type`を付ける

### 2. 推奨項目
- オプショナルパラメータには`?`を付ける
- ユニオン型は`|`で区切る（例：`string|number`）
- 配列型には`[]`を使う（例：`string[]`）
- 関数型には`fun()`を使う（例：`fun(): boolean`）

### 3. Neovim特有の型
```lua
---@param buf integer Buffer handle
---@param win integer Window handle
---@param client vim.lsp.Client LSP client
---@param opts vim.api.keyset.user_command Command options
```

## lua_ls設定の推奨値

```luablink
settings = {
    Lua = {
        hint = {
            enable = true, -- インレイヒント有効化
            paramName = 'All',
            paramType = true,
            arrayIndex = 'Auto'
        },
        completion = {
            callSnippet = 'Replace'
        },
        diagnostics = {
            globals = {'vim'} -- Neovim環境認識
        }
    }
}
```

# プラグイン実装方針（現在の設定ベース）

## 概要
本設定では、lazy.nvimを使用し、Neovim 0.11+とそれ以前のバージョンに対応したハイブリッドLSP設定を採用しています。
core/とplugins/の分離による明確な設定構造を維持し、型安全性とパフォーマンスを重視した実装方針です。

## 1. 現在のプラグイン管理構成

### lazy.nvim設定（init.lua）
```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = true, -- 全プラグイン遅延読み込み
  },
  performance = {
    cache = { enabled = true },
  },
  lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
})
```

### ディレクトリ構造
```
lua/
├── core/
│   ├── init.lua        -- コア設定読み込み
│   ├── options.lua     -- Vim設定オプション
│   ├── keymap.lua      -- キーマッピング
│   └── lsp.lua         -- 新LSP API（0.11+）
├── plugins/
│   ├── lsp.lua         -- LSP設定（メイン）
│   ├── Telescope.lua   -- Telescope設定
│   ├── colorscheme.lua -- カラースキーム
│   ├── copilot.lua     -- GitHub Copilot
│   └── nvim-treesitter.lua -- Treesitter
└── util.lua            -- ユーティリティ関数
```

## 2. LSPハイブリッド設定方針

### バージョン分岐戦略
```lua
-- plugins/lsp.lua内でのバージョン分岐
config = function(_, opts)
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  
  if vim.fn.has('nvim-0.11') == 1 then
    require("core.lsp").setup(capabilities)  -- 新API使用
    return
  end
  
  -- 従来のlspconfig使用
  local lspconfig = require("lspconfig")
  -- 以下従来設定...
end
```

### 新LSP API設定（core/lsp.lua）
```lua
---@class CoreLspModule
local M = {}

---@param capabilities? table LSP capabilities
function M.setup(capabilities)
  if vim.fn.has('nvim-0.11') == 0 then return end
  
  capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()
  
  -- LSP設定配列
  local lsps = {
    { "lua_ls", { capabilities = capabilities } },
    { "ts_ls", { 
        capabilities = capabilities,
        single_file_support = false,
        root_markers = { "tsconfig.json" },
        -- 設定詳細...
      }
    },
    -- 他のLSPサーバー...
  }
  
  for _, lsp in pairs(lsps) do
    local name, config = lsp[1], lsp[2]
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end
```

## 3. プラグイン設定パターン

### 基本設定パターン
```lua
-- plugins/内の各ファイルで使用するパターン
return {
  {
    "plugin/name",
    event = "BufReadPost",  -- 遅延読み込み指定
    dependencies = {
      "required/dependency",
    },
    opts = {
      -- プラグイン設定（90%のケースで使用）
    },
    config = function(_, opts)
      -- 複雑な設定が必要な場合のみ
      require("plugin").setup(opts)
    end
  }
}
```

### 言語固有プラグイン
```lua
-- Rust専用設定例（rustaceanvim）
{
  "mrcjkb/rustaceanvim",
  ft = { "rust" },
  lazy = false,
  opts = {
    server = {
      on_attach = function(client, bufnr)
        -- Rust固有の設定
      end,
      default_settings = {
        ["rust-analyzer"] = {
          -- rust-analyzer設定
        },
      },
    },
  }
}
```

## 4. 型安全性実装

### LuaCATS注釈の活用
```lua
---@class PluginConfig
---@field option1 string 設定項目1
---@field option2? boolean オプション項目（任意）

---@type fun(mode: string|string[], lhs: string, rhs: string|function, opts?: table)
local key = vim.keymap.set

---@param capabilities? table LSP capabilities
function M.setup(capabilities)
  -- 実装
end
```

### エラーハンドリング
```lua
---@return string|nil python_path Python実行可能パス
local function get_python_path()
  local rye_output = vim.fn.system("rye show")
  if vim.v.shell_error == 0 then
    -- 正常処理
    return python_path
  end
  return nil  -- エラー時
end
```

## 5. パフォーマンス最適化

### 遅延読み込み戦略
- **event = "BufReadPost"**: ファイル読み込み後
- **event = "VeryLazy"**: 他のプラグイン読み込み後
- **ft = {...}**: 特定ファイルタイプ
- **cmd = {...}**: コマンド実行時
- **lazy = false**: 即座読み込み（必要な場合のみ）

### 条件分岐読み込み
```lua
-- Node.js環境の判定例
local function is_node_dir()
  return vim.fs.find('package.json', { 
    upward = true, 
    path = vim.fn.getcwd() 
  })[1] ~= nil
end

-- TypeScript LSPの条件付き停止
if not is_node_dir() then
  client.stop(true)
end
```

## 6. 現在使用プラグイン群

### コアプラグイン
- **neovim/nvim-lspconfig**: LSP基盤
- **hrsh7th/nvim-cmp**: 補完エンジン
- **L3MON4D3/LuaSnip**: スニペット
- **nvimtools/none-ls.nvim**: フォーマッタ・リンタ

### 言語サポート
- **mrcjkb/rustaceanvim**: Rust開発環境
- **nvim-treesitter**: 構文解析

### UI・ツール
- **Telescope**: ファジーファインダー
- **GitHub Copilot**: AI補完

## 7. 設定更新指針

### 新プラグイン追加時
1. **plugins/内に専用ファイル作成**（機能別分類）
2. **lazy.nvim形式での設定記述**
3. **LuaCATS注釈の追加**
4. **適切な遅延読み込み指定**

### LSP設定更新時
1. **plugins/lsp.lua**: 従来API設定
2. **core/lsp.lua**: 新API設定
3. **両方での動作確認**

### 削除・変更時
- **完全削除**: 使用されなくなった設定は即座に削除
- **段階的移行**: 破壊的変更は段階的に実施
- **テスト**: 変更後の動作確認必須

## 8. 禁止・非推奨項目

### 使用禁止
- **mason.nvim / mason-lspconfig.nvim**: 破壊的変更により使用中止
- **packer.nvim**: 非メンテナンス状態

### 非推奨API
- **vim.lsp.diagnostic.***: `vim.diagnostic.*`を使用
- **lspconfig.utilの一部関数**: 段階的廃止予定

## チェックリスト

### 新プラグイン追加時
- [ ] plugins/内に適切なファイル作成
- [ ] lazy.nvim形式での設定
- [ ] 遅延読み込み設定
- [ ] LuaCATS注釈追加
- [ ] 依存関係の確認

### LSP設定変更時
- [ ] core/lsp.luaで新API対応
- [ ] plugins/lsp.luaで従来API対応
- [ ] バージョン分岐動作確認
- [ ] キーマッピング統一性確認

