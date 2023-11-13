local dap = require('dap')

dap.adapters.haskell = function(callback, config)
  local port = 4711
  local handle
  handle, _ = vim.loop.spawn('haskell-debug-adapter', {
    args = { '--hackage-version', '--lsp' },
    detached = true,
  }, function(code)
    handle:close()
    print('Haskell Debug Adapter Exited with ' .. code)
  end)
  vim.defer_fn(
    function()
      callback({ type = 'server', host = '127.0.0.1', port = port })
    end,
    100
  )
end

-- stack install haskell-dap ghci-dap haskell-debug-adapter
dap.configurations.haskell = {
  {
    type = 'haskell',
    request = 'launch',
    name = 'Haskell Debug',
    workspace = '${workspaceFolder}',
    startup = "${workspaceFolder}/<your-entrypoint-file>.hs",
    stopOnEntry = false,
    mainArgs = {},
    logFile = "${workspaceFolder}/hda.log",
    logLevel = "DEBUG",
    ghciPrompt = "H>>= ",
    ghciInitialPrompt = "Prelude>",
    ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options=-fprint-evld-with-show",
    ghciEnv = {},
    targetEnv = {},
    forceInspect = false,
    noDebug = false,
  },
}
