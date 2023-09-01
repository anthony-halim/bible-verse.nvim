# 📖 bible-verse.nvim

Neovim plugin to query Bible verses and display it on the screen or insert it into the current buffer.

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

### Diatheke Installation

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
<br/>

> Post installation, it is recommended to run `:checkhealth bible-verse` to make sure all dependencies are installed and can be accessed by the plugin.

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
    --              "insert" - on verse query, insert the result below the cursor of the current buffer.
    default_behaviour = "query",

    -- query_format: text format on 'query' behaviour.
    --     Options: "bibleverse" - query as nerd formatted text.
    --              "plain" - query as plain text.
    query_format = "bibleverse",

    -- insert_format: text format on 'insert' behaviour. 
    --     Options: "markdown" - insert as Markdown formatted text.
    --              "plain" - insert as plain text.
    insert_format = "markdown",

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
            -- quote_block: put the formatted text within a quote block.
            quote_block = true,
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

        -- Formatter settings for bibleverse
        bibleverse = {
            -- omit_translation_footnote: omit translation name from the bibleverseFont text.
            omit_translation_footnote = false,
        }
    },

    ui = {
        -- insert_input: configuration for input component for prompting input for 'insert' behaviour
        -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/input
        insert_input = {
            enter = true,
            focusable = true,
            relative = "cursor",
            border = {
                style = "rounded",
                padding = { 0, 1 },
                text = {
                    top = "Insert verse:",
                    top_align = "left",
                },
            },
            win_options = {
                winhighlight = "FloatBorder:FloatBorder",
            },
            size = {
                -- max_width: maximum width of the insert component, in number of cells
                max_width = 50, -- custom attribute
                height = 1,
            },
            position = {
                row = 1,
                col = 0,
            },
            zindex = 60, -- Must be > popup.zindex
        },

        -- query_input: configuration for input component for prompting input for 'query' behaviour
        -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/input
        query_input = {
            enter = true,
            focusable = true,
            relative = "editor",
            border = {
                style = "rounded",
                padding = { 0, 1 },
                text = {
                    top = "Bible Verse",
                    top_align = "center",
                },
            },
            size = {
                max_width = 50,
                height = 1,
            },
            position = "50%",
            zindex = 60, -- Must be > popup.zindex
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
        },

        -- popup: configuration for popup component, extending from Nui configuration.
        -- see: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
        popup = {
            enter = true,
            focusable = true,
            relative = "editor",
            border = {
                style = "rounded",
                padding = { 1, 1 },
                text = {
                    top = "Bible Verse",
                    top_align = "center",
                },
            },
            size = {
                -- width_percentage: % of current width used for the popup, in float.
                -- max_width_percentage: maximum % of current width used for the popup, in float.
                -- max_height_percentage: maximum % of current height used for the popup, in float.
                width_percentage = 0.5, -- custom attribute
                max_width_percentage = 0.8, -- custom attribute
                max_height_percentage = 0.7, -- custom attribute
            },
            position = "50%",
            zindex = 50,
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
            buf_options = {
                modifiable = false,
                readonly = true,
            },
        },
    },
}
```

For how `formatter.*`, affects the output, see [Formatter](#formatter).

## 🌱 Usage 
 
| Command  | Lua | Description |
|--------- | -------------- | -------------- |
| `:BibleVerse`    | `require("bible-verse").cmd()`    | Execute default behaviour set as per `config.default_behaviour`.|
| `:BibleVerseQuery` or `:BibleVerse query`    | `require("bible-verse").query()`    | Query Bible verse and display it on the screen as a popup. |
| `:BibleVerseInsert` or `:BibleVerse insert`    | `require("bible-verse").insert()`    | Query Bible verse and insert it below the cursor in the current buffer. |

This plugin does not set any key bindings by default. You can set keymaps to trigger the `Lua` commands, as shown below:

```lua
vim.keymap.set("n", "<leader>Bq", require("bible-verse").query, { desc = "[B]ible verse [q]uery"})
vim.keymap.set("n", "<leader>Bi", require("bible-verse").insert, { desc = "[B]ible verse [i]nsert"})
```

## 🔤 Formatter

Below are the formatter configurations used to format queried verses.

### Markdown

With the default Markdown settings:
```lua
separator = "---",
quote_block = true,
omit_translation_footnote = false,
```

<details>
<summary>Overall format</summary>

```markdown
> {separator}
> 
> **{book_name} {chapter}**
> 
> <sup>{verse_number}</sup>{verse} [<sup>{verse_number}</sup>...]
>
> <sub>*{translation}*</sub>
> 
> {separator}
```

</details>

<details>
<summary>Unrendered sample output</summary>

```markdown
> ---
>
> **John 1**
> 
> <sup>1</sup>In the beginning was the Word, and the Word was with God, and the Word was God.
> 
> <sub>*KJV*</sub>
>
> ---
```

</details>

<details>
<summary>Rendered sample output</summary>

> ---
> 
> **John 1**
>
> <sup>1</sup>In the beginning was the Word, and the Word was with God, and the Word was God.
>
> <sub>*KJV*</sub>
> 
> ---

</details>

### Plain

With the default plain settings:
```lua
header_delimiter = " ",
omit_translation_footnote = true,
```

<details>
<summary>Overall format</summary>

```markdown
{book_name} {chapter}:{verse_number}{header_delimiter}{verse}
```

</details>

<details>
<summary>Sample output</summary>

John 1:1 In the beginning was the Word, and the Word was with God, and the Word was God.

</details>

### bibleverse

With the default bibleverse settings:
```lua
omit_translation_footnote = true,
```
<!--TODO: Implement -->

## 🙏 Special Thanks

- [vim-bible](https://github.com/robertrosman/vim-bible) by [robertrosman](https://github.com/robertrosman) as inspiration for this plugin.
- [noice.nvim](https://github.com/folke/noice.nvim) by [folke](https://github.com/folke) as inspiration for repository structure, management, and generally on how to write a Neovim plugin. Truly pleasant to work and extend from.
