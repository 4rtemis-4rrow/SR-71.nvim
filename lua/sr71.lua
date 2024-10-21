local M = {}

-- Function to apply search and replace (regex or normal)
function M.apply_search_replace(is_regex)
  -- Get the current buffer and its lines
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local original_lines = vim.deepcopy(lines) -- Save original state

  -- Get the search term from the user
  local search_term = vim.fn.input("Search: ")
  if search_term == "" then return end -- Cancel if empty input

  -- Validate the regex if using regex mode
  if is_regex then
    local ok, _ = pcall(function() return search_term:match("()") end)
    if not ok then
      print("Invalid regex pattern.")
      return
    end
  else
    search_term = vim.pesc(search_term) -- Escape for plain text search
  end

  -- Highlight the search term
  local search_match_id = vim.fn.matchadd('Search', search_term) -- Highlight matches
  vim.cmd('redraw') -- Redraw to show highlights

  -- Get the replace term from the user
  local replace_term = vim.fn.input("Replace: ")
  if replace_term == "" then
    vim.fn.matchdelete(search_match_id) -- Clear highlight if canceled
    return
  end -- Cancel if empty input

  -- Perform the replacement
  local replaced_lines = {}
  for i, line in ipairs(lines) do
    if is_regex then
      replaced_lines[i] = line:gsub(search_term, replace_term)
    else
      replaced_lines[i] = line:gsub(search_term, replace_term)
    end
  end

  -- Set the modified lines temporarily to visualize the changes
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, replaced_lines)

  -- Highlight the replaced words
  local replace_match_id = vim.fn.matchadd('IncSearch', replace_term) -- Highlight replaced terms
  vim.cmd('redraw') -- Redraw to show highlights

  -- Ask for confirmation
  local confirmation = vim.fn.input("Confirm replacement? (y/n): ")
  if confirmation:lower() ~= 'y' then
    -- Revert to the original state
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, original_lines)
    print("Replacement canceled. No changes were made.")
  else
    -- Finalize the changes
    print("Replaced all instances of '" .. search_term .. "' with '" .. replace_term .. "'")
  end

  -- Clear highlights after the operation is over
  vim.fn.matchdelete(search_match_id) -- Clear search highlights
  vim.fn.matchdelete(replace_match_id) -- Clear replace highlights
end

-- Function to replace all occurrences of the word under the cursor
function M.replace_word_under_cursor()
  -- Get the current buffer and cursor position
  local buf = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_index = cursor_pos[1] - 1 -- Lines are 0-indexed

  -- Get the word under the cursor
  local word = vim.fn.expand('<cword>')
  if word == "" then return end -- Cancel if no word found

  -- Highlight the word under the cursor
  local word_match_id = vim.fn.matchadd('Search', word) -- Highlight the word
  vim.cmd('redraw') -- Redraw to show highlights

  -- Get the replacement term from the user
  local replace_term = vim.fn.input("Replace all occurrences of '" .. word .. "' with: ")
  if replace_term == "" then
    vim.fn.matchdelete(word_match_id) -- Clear highlight if canceled
    return
  end -- Cancel if empty input

  -- Get all lines and replace the word in the entire buffer
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local original_lines = vim.deepcopy(lines) -- Save original state for confirmation
  local replaced_lines = {} -- Initialize replaced_lines as an empty table
  for _, line_content in ipairs(lines) do
    -- Replace all occurrences of the word
    local modified_line = line_content:gsub(word, replace_term)
    table.insert(replaced_lines, modified_line) -- Insert modified line into replaced_lines
  end
  
  -- Set the modified lines temporarily to visualize the changes
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, replaced_lines)

  -- Highlight the replaced words
  local replace_match_id = vim.fn.matchadd('IncSearch', replace_term) -- Highlight replaced terms
  vim.cmd('redraw') -- Redraw to show highlights

  -- Ask for confirmation
  local confirmation = vim.fn.input("Confirm replacement? (y/n): ")
  if confirmation:lower() ~= 'y' then
    -- Revert to the original state
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, original_lines)
    print("Replacement canceled. No changes were made.")
  else
    -- Finalize the changes
    print("Replaced all instances of '" .. word .. "' with '" .. replace_term .. "'")
  end

  -- Clear highlights after the operation is over
  vim.fn.matchdelete(word_match_id) -- Clear word highlight
  vim.fn.matchdelete(replace_match_id) -- Clear replace highlights
end

-- Function to apply regex-based replacement
function M.replace_with_regex()
  M.apply_search_replace(true)
end

-- Function to apply plain-text-based replacement
function M.replace_with_plain_text()
  M.apply_search_replace(false)
end

-- Setup function for keybindings
function M.setup(opts)
  opts = opts or {}

  -- Default keybindings if not provided by the user
  local keybindings = opts.keybindings or {
    replace_regex = "<leader>rr",       -- Regex replace
    replace_text = "<leader>rt",        -- Plain-text replace
    replace_word = "<leader>rw",        -- Replace word under cursor
  }

  -- Set keybindings
  vim.api.nvim_set_keymap('n', keybindings.replace_regex, ":lua require('sr71').replace_with_regex()<CR>", { noremap = true, silent = true, desc = 'Search And Replace Regex Patterns' })
  vim.api.nvim_set_keymap('n', keybindings.replace_text, ":lua require('sr71').replace_with_plain_text()<CR>", { noremap = true, silent = true, desc = 'Search And Replace Plain Text' })
  vim.api.nvim_set_keymap('n', keybindings.replace_word, ":lua require('sr71').replace_word_under_cursor()<CR>", { noremap = true, silent = true, desc = 'Replace All occurrences Of The Word Under The Cursor' })
end

return M

