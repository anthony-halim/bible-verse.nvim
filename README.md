# 📖 bible-verse.nvim

![build](https://github.com/anthony-halim/bible-verse.nvim/actions/workflows/ci.yml/badge.svg)

Neovim plugin to query Bible verses and display them on the screen or insert them into the current buffer.

![query_gif](https://github.com/anthony-halim/bible-verse.nvim/assets/50617144/001fa095-75e5-4e5e-b029-b6970968e540)

Insertion is done on the line **below** the current cursor position.

![insert_gif](https://github.com/anthony-halim/bible-verse.nvim/assets/50617144/f4c94dcf-4fad-4f41-b038-9c184ac1f50d)

## 📋 Requirements

- Neovim >= 0.9.1
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim): used for UI components.
- Diatheke: backend for verse querying.

## 🛠️ Installation

#### Plugin Installation

This plugin is not set up by default. The only mandatory configuration to be supplied is `diatheke.translation`.

Using [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
-- lazy.nvim
{
    "anthony-halim/bible-verse.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    opts = {
        diatheke = {
            -- (MANDATORY)
            -- Corresponds to the diatheke module; diatheke's -b flag.
            -- In this example, we are using KJV module.
            translation = "KJV",
        },
    },
    -- plugin is not set up by default
    config = true,
}
```

For full *opts*, see [Configuration](#configuration).

#### Diatheke Installation

Diatheke is one of the front-ends to the SWORD Project by [CrossWire Bible Society](https://crosswire.org/) and is used as the backend of this plugin to query the verses.

Below are the installation snippets for your convenience. Note that this is not the official method of installation by any means.

<details>
<summary>MacOS Installation</summary>
<br />

```sh
# Install SWORD
brew install sword

export SWORD_PATH="${HOME}/.sword"
mkdir -p "${SWORD_PATH}/mods.d"

yes "yes" | installmgr -init # create a basic user config file
yes "yes" | installmgr -sc   # sync config with known remote repos

# Sample module installation with CrossWire remote source and KJV module.
yes "yes" | installmgr -r CrossWire      # refresh remote source
yes "yes" | installmgr -ri CrossWire KJV # install KJV module from the remote source
```
</details>

<details>
<summary>Ubuntu Installation</summary>
<br />

```sh
# Install SWORD
sudo apt install -y libsword-utils diatheke

export SWORD_PATH="${HOME}/.sword"
mkdir -p "${SWORD_PATH}/mods.d"

yes "yes" | installmgr -init # create a basic user config file
yes "yes" | installmgr -sc   # sync config with known remote repos

# Sample module installation with CrossWire remote source and KJV module.
yes "yes" | installmgr -r CrossWire      # refresh remote source
yes "yes" | installmgr -ri CrossWire KJV # install KJV module from the remote source
```
</details>
<br/>

Add $SWORD_PATH to your shell profile to ensure Diatheke modules can be found.

```sh
# Example: adding to ZSH's .zshrc
echo 'export SWORD_PATH="${HOME}/.sword" >> ~/.zshrc'
```

> Post installation, it is recommended to run `:checkhealth bible-verse` to make sure all dependencies are installed and can be accessed by the plugin.

## 🌱 Usage 

#### API

| Command  | Lua | Description |
|--------- | -------------- | -------------- |
| `:BibleVerse`    | `require("bible-verse").cmd()`    | Execute default behaviour set as per `config.default_behaviour`.|
| `:BibleVerseQuery` or `:BibleVerse query`    | `require("bible-verse").cmd("query")`    | Query Bible verse and display it on the screen as a popup. |
| `:BibleVerseInsert` or `:BibleVerse insert`    | `require("bible-verse").cmd("insert")`    | Query Bible verse and insert it below the cursor in the current buffer. |
| `:BibleVerseRandom`    | `:BibleVerse random` | `require("bible-verse").cmd("random")`    | Query random Bible verse and returns a table containing the Book with chapter, the verse and translation name. |
| `:BibleVerseQueryRandom` or `:BibleVerse queryRandom`    | `require("bible-verse").cmd("queryRandom")`    | Query random Bible verse and display it on the screen as a popup. |

#### Key Bindings

This plugin does not set any key bindings by default. Example of setting keymaps:

##### Via Vim keymap

<details>
<br />
    
  ```lua
  vim.keymap.set("n", "<leader>Bq", "<cmd>BibleVerse query<cr>", { desc = "Bible query" })
  vim.keymap.set("n", "<leader>Bi", "<cmd>BibleVerse insert<cr>", { desc = "Bible insert" })
  ```

</details>

##### Via [lazy.nvim](https://github.com/folke/lazy.nvim) at installation phase

<details>
<br />

  ```lua
  {
      ... -- Other lazy.nvim configurations
      init = function()
          -- (OPTIONAL)
          -- Register to which-key.nvim for prefix visibility
          require("which-key").register({
              ["<leader>"] = {
                  B = {
                      name = "+Bible",
                  },
              },
          })
      end,
      keys = {
          { "<leader>Bq", "<cmd>BibleVerse query<cr>", desc = "Bible query" },
          { "<leader>Bi", "<cmd>BibleVerse insert<cr>", desc = "Bible insert" },
      },
  }
  ```
 
</details>

## ✏️  Configuration

Below is the full configuration as well as the defaults. You can override any of these options during the [Setup](#setup).

```lua
{
    -- default_behaviour: behaviour to be used on empty command arg, i.e. :BibleVerse. Defaults to query. 
    --     Options: "query" - on verse query, display the result on the screen as a popup.
    --              "insert" - on verse query, insert the result below the cursor of the current buffer.
    default_behaviour = "query",

    -- query_format: text format on 'query' behaviour.
    --     Options: "bibleverse" - query as bibleverse formatted text.
    --              "plain" - query as plain text.
    query_format = "bibleverse",

    -- insert_format: text format on 'insert' behaviour. 
    --     Options: "markdown" - insert as Markdown-formatted text.
    --              "plain" - insert as plain text.
    insert_format = "markdown",

    -- Forbid plugin on the following buffer filetypes
    exclude_buffer_filetypes = { "neo-tree", "NvimTree" },

    diatheke = {
        -- (MANDATORY) translation: diatheke module to be used.
        translation = "",
        -- locale: locale as locales in the machine.
        locale = "en",
    },

    formatter = {
        -- Formatter settings for markdown
        markdown = {
            -- separator: text to be used as separator between chapters. Set to empty string to disable.
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
            -- separator: text to be used as separator between chapters. Set to empty string to disable.
            separator = " ",
            -- omit_translation_footnote: omit translation name from the bibleverseFont text.
            omit_translation_footnote = false,
        }
    },

    highlighter = {
        -- To see all highlight groups that are currently active,
        -- :so $VIMRUNTIME/syntax/hitest.vim
        -- see :h highlight

        -- Highlighting for bibleverse text
        bibleverse = {
            -- highlighting for book and chapter of the output e.g. John 1
            book_chapter = {
                hlgroup = "Title", -- Highlight group to use to highlight the text
            },
            -- highlighting for verse number the output
            verse_number = { hlgroup = "Number" },
            -- highlighting for translation used in the output
            translation = { hlgroup = "ModeMsg" },
            -- highlighting for separator between book chapters used in the output
            separator = { hlgroup = "NonText" },
        },
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
            zindex = 20, -- Must be > popup.zindex
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
            zindex = 20, -- Must be > popup.zindex
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
            zindex = 10,
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

For how `formatter.*` affects the output, see [Formatter](#formatter).
 
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
<br />

```markdown
> **{book_name} {chapter}**
> 
> <sup>{verse_number}</sup>{verse} [<sup>{verse_number}</sup>{verse}...]
> 
> {separator}
> 
> **{book_name} {chapter}**
> 
> <sup>{verse_number}</sup>{verse} [<sup>{verse_number}</sup>{verse}...]
>
> <sub>*{translation}*</sub>
```

</details>

<details>
<summary>Unrendered sample output</summary>
<br />

```markdown
> **John 1**
> 
> <sup>51</sup>And he saith unto him, Verily, verily, I say unto you, Hereafter ye shall see heaven open, and the angels of God ascending and descending upon the Son of man.  
> 
> ---
> 
> **John 2**
> 
> <sup>1</sup>And the third day there was a marriage in Cana of Galilee; and the mother of Jesus was there: 
> 
> <sub>*KJV*</sub>
```

</details>

<details>
<summary>Rendered sample output</summary>
<br />

> **John 1**
> 
> <sup>51</sup>And he saith unto him, Verily, verily, I say unto you, Hereafter ye shall see heaven open, and the angels of God ascending and descending upon the Son of man.  
> 
> ---
> 
> **John 2**
> 
> <sup>1</sup>And the third day there was a marriage in Cana of Galilee; and the mother of Jesus was there: 
> 
> <sub>*KJV*</sub>

</details>

### Plain

With the default plain settings:
```lua
header_delimiter = " ",
omit_translation_footnote = true,
```

<details>
<summary>Overall format</summary>
<br />

```markdown
{book_name} {chapter}:{verse_number}{header_delimiter}{verse}
{book_name} {chapter}:{verse_number}{header_delimiter}{verse}
```

</details>

<details>
<summary>Sample output</summary>
<br />

```
John 1:51 And he saith unto him, Verily, verily, I say unto you, Hereafter ye shall see heaven open, and the angels of God ascending and descending upon the Son of man.
John 2:1 And the third day there was a marriage in Cana of Galilee; and the mother of Jesus was there:
```

</details>

### BibleVerse

With the default bibleverse settings:
```lua
-- Formatter settings
separator = " ",
omit_translation_footnote = false,

-- Highlighter settings
book_chapter = { hlgroup = "Title" },
verse_number = { hlgroup = "Number" },
translation = { hlgroup = "ModeMsg" },
separator = { hlgroup = "NonText" },
```

<details>
<summary>Overall format</summary>
<br />

```markdown
{book_chapter}

{verse_number}{verse} [{verse_number}{verse}...]

{separator}

{book_chapter}

{verse_number}{verse} [{verse_number}{verse}...]

{translation}
```

</details>

<details>
<summary> Rendered output </summary>
<br />

![image](https://github.com/anthony-halim/bible-verse.nvim/assets/50617144/8e176cf8-f99c-4f3e-91ff-21acb191a4d3)

</details>


## 🙏 Special Thanks

- [vim-bible](https://github.com/robertrosman/vim-bible) by [robertrosman](https://github.com/robertrosman) as inspiration for this plugin.
- [noice.nvim](https://github.com/folke/noice.nvim) by [folke](https://github.com/folke) as inspiration for repository structure, management, and generally on how to write a Neovim plugin. Truly pleasant to work and extend from.

