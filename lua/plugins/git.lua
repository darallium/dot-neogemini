-- plugins/git.lua
return {
  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local key = vim.keymap.set
        
        key("n", "]h", gs.next_hunk, { buffer = buffer, desc = "Next Hunk" })
        key("n", "[h", gs.prev_hunk, { buffer = buffer, desc = "Prev Hunk" })
        key({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { buffer = buffer, desc = "Stage Hunk" })
        key({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { buffer = buffer, desc = "Reset Hunk" })
        key("n", "<leader>ghS", gs.stage_buffer, { buffer = buffer, desc = "Stage Buffer" })
        key("n", "<leader>ghu", gs.undo_stage_hunk, { buffer = buffer, desc = "Undo Stage Hunk" })
        key("n", "<leader>ghR", gs.reset_buffer, { buffer = buffer, desc = "Reset Buffer" })
        key("n", "<leader>ghp", gs.preview_hunk, { buffer = buffer, desc = "Preview Hunk" })
        key("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { buffer = buffer, desc = "Blame Line" })
        key("n", "<leader>ghd", gs.diffthis, { buffer = buffer, desc = "Diff This" })
        key("n", "<leader>ghD", function() gs.diffthis("~") end, { buffer = buffer, desc = "Diff This ~" })
        key({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = buffer, desc = "GitSigns Select Hunk" })
      end,
    },
  },
  
  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  
  -- Git conflict resolution
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPost",
    opts = {
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = 'copen',
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
      }
    },
  },
  
  -- Diffview
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView File History" },
    },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      use_icons = true,
    },
  },
}