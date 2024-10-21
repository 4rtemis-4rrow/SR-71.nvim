# SR71 - Search and Replace Plugin for Neovim

SR-71 (Search Replace - 71) is a Neovim plugin that provides powerful search and replace functionality using both regex and plain text. It allows users to perform replacements throughout the current buffer and offers convenient confirmation prompts.

## Features

- **Regex Search and Replace**: Use regular expressions for advanced searching and replacing (currently broken).
- **Plain Text Replacement**: Quickly replace plain text strings.
- **Highlighting**: Temporarily highlight search and replaced terms for easy review.
- **Interactive Confirmation**: Confirm changes before they are finalized.
- **Word Replacement**: Replace all occurrences of the word under the cursor.

## Installation

To install the SR71 plugin, use your favorite plugin manager. Below are instructions for popular managers:

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

Add the following to your Neovim configuration file (usually `init.lua`):

```lua
require('lazy').setup({
  { '4rtemis-4rrow/SR-71.nvim' }
})
```

### Using [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use '4rtemis-4rrow/SR-71.nvim'
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug '4rtemis-4rrow/SR-71.nvim'
```

## Setup

After installing the plugin, **you must call** `require('sr71').setup()` **in your Neovim configuration**. This is required even if no arguments are passed to it:

```lua
require('sr71').setup() -- Required setup call
```

You can customize keybindings by passing an options table to the `setup` function. Here’s an example:

```lua
require('sr71').setup({
  keybindings = {
    replace_regex = "<leader>rR", -- Custom keybinding for regex replace
    replace_text = "<leader>rT",  -- Custom keybinding for plain text replace
    replace_word = "<leader>rW",   -- Custom keybinding for word under cursor
  }
})
```

## Usage

### Keybindings

By default, the following keybindings are set:

- **Replace with Regex**: `<leader>rr`
- **Replace Plain Text**: `<leader>rt`
- **Replace Word Under Cursor**: `<leader>rw`

### Example Usage

1. **Regex Replacement**:
   - Press `<leader>rr` to initiate a regex-based search and replace.
   - Enter the search pattern and replacement term when prompted.
   - Confirm the replacement to apply changes. **Note: Regex searching is currently broken.**

2. **Plain Text Replacement**:
   - Press `<leader>rt` to replace plain text in the current buffer.
   - Enter the search term and the text you want to replace it with.

3. **Word Replacement**:
   - Place the cursor on the word you want to replace.
   - Press `<leader>rw` to replace all occurrences of that word.

## Video Demonstration

Check out the following video showing the plugin in action:

[Watch the video](./media/recording.mp4)

## License

This plugin is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributing

Contributions are welcome! If you have suggestions, improvements, or bug fixes, feel free to open an issue or submit a pull request.
