# 📖 bible-verse.nvim

Neovim plugin to query Bible verses and display it on the screen or paste it into the current buffer.

<!-- TODO: Show Gif -->

## 📋 Requirements

- Neovim >= 0.9.0
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim): used for UI components.
- Diatheke: backend for verse querying.

## 🛠️ Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
-- lazy.nvim
{
    "anthony-halim/bible-verse.nvim",
    lazy = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        -- plugin is not enabled by default and the setup function must be called.
        require("bible-verse").setup({
            diatheke = {
                translation = "KJV",
            },
        })
    end,
}
```

For setup function, see [Setup](#setup).

#### Diatheke Installation

Diatheke is one of the front-ends to the SWORD Project by [CrossWire Bible Society](https://crosswire.org/) and is used as the backend of this plugin to query the verses.

Below is the installation snippets for your convenience. Note that this is not the official method of installation by any means.

##### MacOS

<details>
<summary>Installation</summary>

```sh
# Install SWORD
brew install sword

export SWORD_PATH="${HOME}/.sword"
mkdir -p "${SWORD_PATH}/mods.d"

echo "yes" | installmgr -init # create a basic user config file
echo "yes" | installmgr -sc   # sync config with list of known remote repos

# Sample module installation with CrossWire remote source and KJV module.
echo "yes" | installmgr -r CrossWire      # refresh remote source
echo "yes" | installmgr -ri CrossWire KJV # install module from remote source
```
</details>

##### Debian

<details>
<summary>Installation</summary>

```sh
# Install SWORD
sudo apt install -y libsword-utils diatheke

export SWORD_PATH="${HOME}/.sword"
mkdir -p "${SWORD_PATH}/mods.d"

echo "yes" | installmgr -init # create a basic user config file
echo "yes" | installmgr -sc   # sync config with list of known remote repos

# Sample module installation with CrossWire remote source and KJV module.
echo "yes" | installmgr -r CrossWire      # refresh remote source
echo "yes" | installmgr -ri CrossWire KJV # install module from remote source
```
</details>

## ⚙️  Setup 

This plugin is not enabled by default and must be setup. The only mandatory configuration to be supplied is `diatheke.translation`.

Sample setup:
```lua
require("bible-verse").setup({
  diatheke = {
    -- Corresponds to the diatheke module; diatheke's -b flag.
    -- In this example, we are using KJV module.
    translation = "KJV",
  },
  ...remaining opts
})
```

For *opts*, see [Configuration](#configuration).

## ✏️  Configuration

Below is the full configuration as well as the defaults. You can override any of these options during the [Setup](#setup).

```lua
{
    -- default_behaviour: behaviour to be used on empty command arg, i.e. :BibleVerse. Defaults to query. 
    --     Options: "query" - on verse query, display the result on the screen as a popup.
    --              "paste" - on verse query, insert the result below the cursor of the current buffer.
    default_behaviour = "query",

    -- paste_format: text format on 'paste' behaviour. 
    --     Options: "markdown" - paste as Markdown formatted text.
    --              "plain" - paste as plain text.
    paste_format = "markdown",

    -- query_format: text format on 'query' behaviour. 
    --     Options: "nerd" - paste as Nerdfont formatted text.
    --              "plain" - paste as plain text.
    query_format = "nerd",

    diatheke = {
        -- (MANDATORY) translation: diatheke module to be used.
        translation = "",
        -- locale: locale as locales in the machine.
        locale = "en",
    },

    formatter = {
        -- Formatter settings for markdown
        markdown = {
            -- separator: text to be used as prefix and suffix the markdown text. Set to empty string to disable.
            separator = "---",
            -- omit_translation_footnote: omit translation name from the markdown text.
            omit_translation_footnote = false,
        },

        -- Formatter settings for plain
        plain = {
            -- header_delimiter: text to be used to separate between the content of verse and the verse.
            header_delimiter = " ",
            -- omit_translation_footnote: omit translation name from the markdown text.
            omit_translation_footnote = true,
        },

        -- TODO: Write nerd settings
    },

    nui = {
        -- input: configuration for input component, extending from Nui configuration.
        -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/input
        input = {
            border = {
                style = "rounded",
                padding = { 0, 1 },
                text = {
                    top_align = "center",
                },
            },
            relative = "editor",
            position = "50%",
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
        },

        -- popup: configuration for popup component, extending from Nui configuration.
        -- see: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
        popup = {
            border = {
                style = "rounded",
                padding = { 1, 1 },
                text = {
                    top_align = "center",
                },
            },
            relative = "editor",
            position = "50%",
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
        },
    },
}
```

For how `formatter.*`, affects the output, see [Formatter](#formatter).

## 🌱 Usage 
 
<!-- TODO: Write -->

## 🔤 Formatter

Below are the formatter configurations used to format queried verses.

### Markdown

> Available on: `paste` behaviour.

<!-- TODO: Write -->

### Plain

> Available on: `query`, `paste` behaviour.

<!-- TODO: Write -->

### Nerd

> Available on: `query` behaviour.

<!-- TODO: Write -->

## 🙏 Special Thanks

- [vim-bible](https://github.com/robertrosman/vim-bible) by [robertrosman](https://github.com/robertrosman) as inspiration for this plugin.
- [noice.nvim](https://github.com/folke/noice.nvim) by [folke](https://github.com/folke) as inspiration for general repository structure. Truly pleasant to work and extend from.
