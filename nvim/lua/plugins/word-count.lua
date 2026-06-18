-- lua/plugins/word-count.lua
-- Counts words in a visual selection and displays the result.

--- Count words in a given string.
--- Words are defined as sequences of non-whitespace characters.
---@param text string
---@return integer
local function count_words(text)
  local count = 0
  for _ in text:gmatch("%S+") do
    count = count + 1
  end
  return count
end

--- Get the visually selected text.
--- Supports characterwise (v) and linewise (V) visual modes.
--- Must be called after leaving visual mode so '< and '> marks are set.
---@return string
local function get_visual_selection()
  local mode      = vim.fn.visualmode()
  local start_pos = vim.fn.getpos("'<")
  local end_pos   = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col  = start_pos[3]
  local end_line   = end_pos[2]
  local end_col    = end_pos[3]

  local lines = vim.fn.getline(start_line, end_line)

  if #lines == 0 then
    return ""
  end

  if mode == "V" then
    return table.concat(lines, "\n")
  end

  -- Characterwise: trim to selection bounds
  lines[#lines] = lines[#lines]:sub(1, end_col)
  lines[1]      = lines[1]:sub(start_col)

  return table.concat(lines, "\n")
end

--- Count words in the current visual selection and display the result.
local function count_selection()
  local text  = get_visual_selection()
  local count = count_words(text)
  local label = count == 1 and "word" or "words"
  -- echo persists in the command line until the next keypress
  vim.cmd(string.format('echo "Selection: %d %s"', count, label))
end

-- :<C-u> exits visual mode and clears the range from the command line,
-- leaving '< and '> marks intact for get_visual_selection().
vim.keymap.set(
  "v",
  "<leader>wc",
  ":<C-u>lua require('word_count_fn').run()<CR>",
  { noremap = true, silent = false, desc = "Count words in selection" }
)

-- Expose via a module table so the keymap string can call it
package.loaded["word_count_fn"] = { run = count_selection }

vim.api.nvim_create_user_command("WordCount", count_selection, {
  range = true,
  desc  = "Count words in visual selection",
})

return {}
