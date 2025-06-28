---@class PyrightPluginOpts

-- plugins/python.lua
return {
  {
    "microsoft/pyright",
    ft = "python",
    ---@type PyrightPluginOpts
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