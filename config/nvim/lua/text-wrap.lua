-- text-wrap.lua
-- Module for wrapping text at 79 character limit
-- Place this in ~/.config/nvim/lua/text-wrap.lua
-- Then add to your init.lua: require('text-wrap')

-- Format selected text to specified width (default 79)
local function format_to_width(width)
  width = width or 79

  -- Get the visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Get all selected lines and join them into one string
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, " ")

  -- Remove extra spaces
  text = text:gsub("%s+", " ")
  text = text:gsub("^%s+", "")
  text = text:gsub("%s+$", "")

  -- Wrap the text
  local wrapped_lines = {}
  local current_line = ""

  for word in text:gmatch("%S+") do
    -- Check if adding this word would exceed the width
    local test_line = current_line == "" and word or current_line .. " " .. word

    if #test_line > width then
      -- Line would be too long, save current line and start new one
      if current_line ~= "" then
        table.insert(wrapped_lines, current_line)
        current_line = word
      else
        -- Single word is longer than width, add it anyway
        table.insert(wrapped_lines, word)
        current_line = ""
      end
    else
      -- Word fits, add it to current line
      current_line = test_line
    end
  end

  -- Add the last line if there's anything left
  if current_line ~= "" then
    table.insert(wrapped_lines, current_line)
  end

  -- Replace the selected lines with wrapped lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, wrapped_lines)
end

-- Format current paragraph to specified width (default 80)
local function format_paragraph_to_width(width)
  width = width or 79

  -- Get current paragraph bounds
  local start_line = vim.fn.search('^$', 'bnW') + 1
  if start_line == 1 and vim.fn.getline(1) == '' then
    start_line = 2
  end

  local end_line = vim.fn.search('^$', 'nW') - 1
  if end_line == -1 then
    end_line = vim.fn.line('$')
  end

  -- Get all paragraph lines and join them
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, " ")

  -- Remove extra spaces
  text = text:gsub("%s+", " ")
  text = text:gsub("^%s+", "")
  text = text:gsub("%s+$", "")

  -- Wrap the text
  local wrapped_lines = {}
  local current_line = ""

  for word in text:gmatch("%S+") do
    -- Check if adding this word would exceed the width
    local test_line = current_line == "" and word or current_line .. " " .. word

    if #test_line > width then
      -- Line would be too long, save current line and start new one
      if current_line ~= "" then
        table.insert(wrapped_lines, current_line)
        current_line = word
      else
        -- Single word is longer than width, add it anyway
        table.insert(wrapped_lines, word)
        current_line = ""
      end
    else
      -- Word fits, add it to current line
      current_line = test_line
    end
  end

  -- Add the last line if there's anything left
  if current_line ~= "" then
    table.insert(wrapped_lines, current_line)
  end

  -- Replace the paragraph with wrapped lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, wrapped_lines)
end

-- Default width
local width = 79

-- Normal mode: format current paragraph with Leader+a
vim.keymap.set('n', '<Leader>a', function()
  format_paragraph_to_width(width)
end, {
  desc = 'Wrap current paragraph at 80 characters',
  noremap = true,
  silent = true
})

-- Command to format with custom width
vim.api.nvim_create_user_command('FormatWidth', function(args)
  local custom_width = tonumber(args.args) or 79
  format_paragraph_to_width(custom_width)
end, {
  nargs = '?',
  desc = 'Format paragraph to specified width (default 80)'
})
