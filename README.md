# nvim

My Neovim config.

## Usage

### Prerequisites

- [Neovim][neovim-home] `v0.9.5`

### Setup

- Clone this project into the Neovim config directory (`~/.config/nvim`).

#### Config

Configuration settings are driven by the `core.config` module, which contains all defaults. You
may set global overrides in a `~/.config/nvim.json` file.  Projects may also provide their own
overrides in an `nvim.json` at the root of the project (where you open it with Neovim).  The
schema for `nvim.json` files is located in [./nvim.schema.json](./nvim.schema.json).

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

## Development

### Prerequisites

- [pre-commit](https://pre-commit.com/) `v3.5.0`


[neovim-home]: https://neovim.io
[nvim-dap-python-repo]: https://github.com/mfussenegger/nvim-dap-python
[pytest-repo]: https://github.com/pytest-dev/pytest
