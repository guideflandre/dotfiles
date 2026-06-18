return { 
    "ribru17/bamboo.nvim", 
    name = "bamboo", 
    opts = {
        variant = "moon"
    },
  lazy = false, 
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "bamboo"
  end
}

