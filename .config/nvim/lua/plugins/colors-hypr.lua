return {
  {
    "LazyVim/LazyVim",
    -- Use our local colorscheme "hypr"
    opts = { colorscheme = "hypr" },
    init = function()
      -- Re-apply the colorscheme whenever Neovim regains focus or resumes
      local grp = vim.api.nvim_create_augroup("HyprColorsReload", { clear = true })
      vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
        group = grp,
        callback = function()
          pcall(vim.cmd, "colorscheme hypr")
        end,
        desc = "Reload Hypr colorscheme on focus",
      })
    end,
  },
}

