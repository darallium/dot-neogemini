# 言語固有設定詳細

### TypeScript/JavaScript
```lua
-- plugins/typescript.lua
return {
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
      },
    },
  },
}
```

### Rust
```lua
-- plugins/rust.lua
return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    lazy = false,
    opts = {
      server = {
        on_attach = function(client, bufnr)
          local key = vim.keymap.set
          key('n', '<leader>ca', function()
            vim.cmd.RustLsp('codeAction')
          end, { desc = 'Code Action', buffer = bufnr })
          key('n', '<leader>dr', function()
            vim.cmd.RustLsp('debuggables')
          end, { desc = 'Rust debuggables', buffer = bufnr })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
  },
  
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      crates.show()
    end,
  },
}
```

### Python
```lua
-- plugins/python.lua
return {
  {
    "microsoft/pyright",
    ft = "python",
    config = function()
      -- Rye環境検出
      local function get_python_path()
        local rye_output = vim.fn.system("rye show --json")
        if vim.v.shell_error == 0 then
          local ok, data = pcall(vim.json.decode, rye_output)
          if ok and data.python_path then
            return data.python_path
          end
        end
        return nil
      end
      
      local python_path = get_python_path()
      if python_path then
        vim.g.python3_host_prog = python_path
      end
    end,
  },
}
```

### Go
```lua
-- plugins/go.lua
return {
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = '<CMD>GoInstallBinaries<CR>',
  }
}
```

### Java
```lua
-- plugins/java.lua
return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function() 
      local jdtls = require('jdtls')
      local root_markers = {'gradlew', 'mvnw', '.git'}
      local root_dir = jdtls.setup.find_root(root_markers)

      if not root_dir then
        return
      end

      local jdtls_config = {
        cmd = {'jdtls'},
        root_dir = root_dir,
      }

      jdtls.start_or_attach(jdtls_config)
    end,
  },
}
```

### C/C++
```lua
-- plugins/c_cpp.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
          },
        },
      },
    },
  },
}
```

### PHP
```lua
-- plugins/php.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "php" },
    opts = {
      servers = {
        intelephense = {},
      },
    },
  },
}
```

### Ruby
```lua
-- plugins/ruby.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "ruby" },
    opts = {
      servers = {
        solargraph = {},
      },
    },
  },
}
```

### C#
```lua
-- plugins/csharp.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "csharp" },
    opts = {
      servers = {
        omnisharp = {},
      },
    },
  },
}
```

### Kotlin
```lua
-- plugins/kotlin.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "kotlin" },
    opts = {
      servers = {
        kotlin_language_server = {},
      },
    },
  },
}
```

### HTML/CSS
```lua
-- plugins/html_css.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "html", "css" },
    opts = {
      servers = {
        html = {},
        cssls = {},
      },
    },
  },
}
```

### Lua
```lua
-- plugins/lua.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "lua" },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
      },
    },
  },
}
```

### Markdown
```lua
-- plugins/markdown.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "markdown" },
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
}
```

### Shell Script
```lua
-- plugins/shell.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "sh" },
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
}
```

### Perl
```lua
-- plugins/perl.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "perl" },
    opts = {
      servers = {
        perlls = {},
      },
    },
  },
}
```

### R
```lua
-- plugins/r.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "r" },
    opts = {
      servers = {
        r_language_server = {},
      },
    },
  },
}
```

### SQL
```lua
-- plugins/sql.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "sql" },
    opts = {
      servers = {
        sqlls = {},
      },
    },
  },
}
```

### YAML
```lua
-- plugins/yaml.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "yaml" },
    opts = {
      servers = {
        yamlls = {},
      },
    },
  },
}
```

### JSON
```lua
-- plugins/json.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "json" },
    opts = {
      servers = {
        jsonls = {},
      },
    },
  },
}
```

### Swift
```lua
-- plugins/swift.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
    opts = {
      servers = {
        sourcekit = {
          -- SourceKit-LSP relies on didChangeWatchedFiles, but Neovim doesn't implement dynamic registration.
          -- Manually enable it in capabilities.
          capabilities = {
            textDocument = {
              didChangeWatchedFiles = {
                dynamicRegistration = false,
              },
            },
          },
          root_markers = { "Package.swift", ".git" },
        },
      },
    },
  },
}
```

### Dart
```lua
-- plugins/dart.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "dart" },
    opts = {
      servers = {
        dartls = {},
      },
    },
  },
}
```

### Clojure
```lua
-- plugins/clojure.lua
return {
  {
    "neovim/nvim-lspconfig",
    ft = { "clojure", "clojurescript", "cljc", "edn" },
    opts = {
      servers = {
        clojure_lsp = {},
      },
    },
  },
}
```
