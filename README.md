# nvim

My neovim config.

## Usage

### Prerequisites

- [neovim][neovim-home] `v0.10.4`
  - [build from source][nvim-build] with debug info
- [cargo][cargo-repo] `v1.85.0`
- [stylua][stylua-repo] `v2.0.2`
  - install via `cargo install stylua --features lua52`
- [python][python-downloads] `v3.12.0`
- [pre-commit][pre-commit-home] `v4.0.1`
  - install via `pip install pre-commit`

### Setup

Clone this project into your neovim user config directory (see [initialization #7][nvim-doc-initialization]).

## Features

### LSP Support

- lua
  - LuaLS (for editing neovim config only)

### Keymaps

> __Note__: This is only a subset of commonly used keymaps.  A complete list of keymaps
> can be accessed for each mode via `:nmap`, `:imap`, and `:vmap`.

| Keymap        | Description                |
| ------------- | -------------------------- |
| `C-\`         | Toggle terminal.           |
| `S-h`         | Cycle to previous buffer.  |
| `S-l`         | Cycle to next buffer.      |
| `<leader>-bp` | Toggle current buffer pin. |
| `<leader>-bP` | Close unpinned buffers.    |
| `<leader>-bd` | Close current buffer.      |

### DAP

#### Python

Debugging in Python is supported through the [nvim-dap-python][nvim-dap-python-repo] plugin, which
is configured to use a virtual environment located at `./.venv` and [pytest][pytest-repo] as a
test runner.

| Keymap        | Command                  |
| ------------- | ------------------------ |
| `<leader>dpr` | Debug current function   |
| `F9`          | Toggle DAP UI            |
| `<leader>db`  | Toggle breakpoint        |
| `F5`          | Continue from breakpoint |


[cargo-repo]: https://github.com/rust-lang/cargo
[neovim-home]: https://neovim.io
[nvim-build]: https://github.com/neovim/neovim/blob/master/BUILD.md
[nvim-dap-python-repo]: https://github.com/mfussenegger/nvim-dap-python
[nvim-doc-initialization]: https://neovim.io/doc/user/starting.html#initialization
[pre-commit-home]: https://pre-commit.com
[pytest-repo]: https://github.com/pytest-dev/pytest
[python-downloads]: https://www.python.org/downloads/
[stylua-repo]: https://github.com/JohnnyMorganz/StyLua
