return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")

    iron.setup({
      config = {
        repl_definition = {
          python = {
            command = function()
              if vim.fn.executable("ipython") == 1 then
                return { "ipython", "--no-autoindent" }
              else
                return { "python3" }
              end
            end,
            format = require("iron.fts.common").bracketed_paste_python,
          },
        },
        repl_open_cmd = view.split.vertical.rightbelow("%40"),
      },
      keymaps = {},
      highlight = { italic = true },
      ignore_blank_lines = true,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function(args)
        local buf = args.buf
        local opts = function(desc)
          return { buffer = buf, noremap = true, silent = true, desc = desc }
        end

        -- REPL management
        vim.keymap.set("n", "<localleader>rf", "<cmd>IronRepl<cr>", opts("Open Python REPL"))
        vim.keymap.set("n", "<localleader>rq", "<cmd>IronHide<cr>", opts("Close REPL"))
        vim.keymap.set("n", "<localleader>rs", iron.repl_restart, opts("Restart REPL"))
        vim.keymap.set("n", "<localleader>rc", function()
          iron.send(nil, string.char(12))
        end, opts("Clear REPL"))
        vim.keymap.set("n", "<localleader>ri", function()
          iron.send(nil, string.char(3))
        end, opts("Interrupt REPL"))

        -- Sending code
        vim.keymap.set("n", "<localleader>d", function()
          iron.send_line()
          vim.cmd("normal! j")
        end, opts("Send line"))
        vim.keymap.set("v", "<localleader>sd", function()
          iron.visual_send()
          local end_line = vim.fn.line("'>")
          local last_line = vim.api.nvim_buf_line_count(0)
          if end_line < last_line then
            vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
          end
        end, opts("Send selection"))
        vim.keymap.set("n", "<localleader>aa", iron.send_file, opts("Send file"))
        vim.keymap.set("n", "<localleader>sp", iron.send_paragraph, opts("Send paragraph"))
        vim.keymap.set("n", "<localleader>l", iron.send_motion, opts("Send motion"))
        vim.keymap.set("n", "<localleader><cr>", function()
          iron.send(nil, "\r")
        end, opts("Send CR"))
      end,
    })
  end,
}
