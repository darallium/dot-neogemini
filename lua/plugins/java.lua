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
