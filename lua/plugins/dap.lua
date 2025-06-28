
---@class DapAdapterExecutable
---@field command string
---@field args string[]

---@class DapAdapter
---@field type string
---@field command? string
---@field args? string[]
---@field port? string
---@field executable? DapAdapterExecutable

---@class DapConfiguration
---@field type string
---@field request string
---@field name string
---@field program? string | fun(): string
---@field pythonPath? fun(): string
---@field cwd? string
---@field stopOnEntry? boolean

-- Debugging setup using nvim-dap
return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function(_, opts)
      ---@type DapUIOptions
      local dapui_opts = {
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 0.25,
            position = "bottom",
          },
        },
      }
      local dap = require("dap")
      local dapui = require("dapui")

      -- Adapters
      ---@type table<string, DapAdapter>
      dap.adapters.python = {
        type = 'executable',
        command = 'python',
        args = { '-m', 'debugpy.adapter' },
      }

      ---@type table<string, DapAdapter>
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = 'codelldb',
          args = { "--port", "${port}" },
        }
      }

      -- Configurations
      ---@type table<string, DapConfiguration[]>
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            return vim.g.python3_host_prog or 'python'
          end,
        },
      }

      ---@type table<string, DapConfiguration[]>
      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      
      -- Keymaps
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step into' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step over' })
      vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Open REPL' })
      vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Run last' })
      vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Terminate' })

      -- DAP UI
      require("dapui").setup(dapui_opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  }
}
