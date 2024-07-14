# nvim

My Neovim config.

## Usage

### Prerequisites

- [Neovim][neovim-home] `v0.9.5`
- [pre-commit][pre-commit-home] `v3.5.0`

### Setup

Clone this project into the Neovim config directory (`~/.config/nvim`).

#### Config

Configuration settings are driven by the `core.config` module, which contains all defaults. You
may set global overrides in a `~/.config/nvim/nvim.json` file.  Projects may also provide their own
local overrides in an `nvim.json` at the root of the project (where you open it with Neovim).  The
schema for `nvim.json` files is [nvim.schema.json](./nvim.schema.json).

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


[neovim-home]: https://neovim.io
[nvim-dap-python-repo]: https://github.com/mfussenegger/nvim-dap-python
[pre-commit-home]: https://pre-commit.com
[pytest-repo]: https://github.com/pytest-dev/pytest
