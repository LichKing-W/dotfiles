return {
  "kawre/leetcode.nvim",
  cmd = "Leet",
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- configuration goes here
    lang = "python3",
    storage = {
      home = "~/leetcode",
      cache = "~/cache_leetcode",
    },
    cn = { -- leetcode.cn
      enabled = true, ---@type boolean
    },
    non_standalone = true,
    description = {
      width = "30%",
    },
  },
}
