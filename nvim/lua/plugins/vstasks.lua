return {
  "EthanJWright/vs-tasks.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local map = LazyVim.safe_keymap_set

    map("n", "<Leader>t", function() end, { desc = "VSCode Tasks" })
    map("n", "<Leader>ta", function()
      require("telescope").extensions.vstask.tasks()
    end, { desc = "Tasks" })
    map("n", "<Leader>ti", function()
      require("telescope").extensions.vstask.inputs()
    end, { desc = "Inputs" })
    map("n", "<Leader>tj", function()
      require("telescope").extensions.vstask.jobs()
    end, { desc = "Jobs" })
    map("n", "<Leader>td", function()
      require("telescope").extensions.vstask.clear_inputs()
    end, { desc = "Clear inputs" })
    map("n", "<Leader>tc", function()
      require("telescope").extensions.vstask.cleanup_completed_jobs()
    end, { desc = "Cleanup completed jobs" })
    map("n", "<Leader>tl", function()
      require("telescope").extensions.vstask.launch()
    end, { desc = "Launch" })
    map("n", "<Leader>tr", function()
      require("telescope").extensions.vstask.command()
    end, { desc = "Command" })
  end,
}
