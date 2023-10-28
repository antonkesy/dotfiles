lvim.builtin.dap.active = true
local dap = require('dap')

dap.adapters.python = {
  type = 'executable',
  command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    name = 'Launch File',
    type = 'python',
    request = 'launch',
    program = '${file}',
    cwd = '${workspaceFolder}',
    console = "integratedTerminal",
    stopOnEntry = false,
    args = {},
    pythonPath = function()
      return 'python3'
    end,
  },
}


dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode-14',
  name = 'lldb'
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
-- dap.adapters.clangd = {
--   id = 'clangd',
--   type = 'executable',
--   command = 'clangd',
-- }

-- dap.configurations.cpp = {
--   {
--     name = "Launch",
--     type = "clangd",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--   },
-- }
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- dap.adapters.codelldb = {
--   type = 'server',
--   port = "${port}",
--   executable = {
--       -- CHANGE THIS to your path!
--       command = '/absolute/path/to/codelldb/extension/adapter/codelldb',
--       args = {"--port", "${port}"},

--       -- On windows you may have to uncomment this:
--       -- detached = false,
--     }
-- }

dap.adapters.haskell = {
  type = 'executable',
  command = 'haskell-debug-adapter',
  args = { '--hackage-version=0.0.33.0' },
}

dap.configurations.haskell = {
  {
    type = 'haskell',
    request = 'launch',
    name = 'Debug',
    workspace = '${workspaceFolder}',
    startup = "${file}",
    stopOnEntry = true,
    logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
    logLevel = 'WARNING',
    ghciEnv = vim.empty_dict(),
    ghciPrompt = "λ: ",
    -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
    ghciInitialPrompt = "λ: ",
    ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
  },
}

dap.adapters.netcoredbg = {
  type = 'executable',
  command = 'netcoredbg',
  args = { '--interpreter=vscode' },
}

dap.configurations.cs = {
  {
    type = 'netcoredbg',
    name = 'Launch',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
