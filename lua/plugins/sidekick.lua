return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = false,
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle({ name = "claude" })
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ name = "claude" })
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close({ name = "claude" })
      end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt({ name = "claude" })
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
