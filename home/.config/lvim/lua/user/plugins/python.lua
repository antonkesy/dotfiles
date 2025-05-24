return {
  {
    "microsoft/python-type-stubs",
    cond = false
    -- https://github.com/microsoft/pyright/issues/4878
    -- TODO: "stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs""
  }
}
