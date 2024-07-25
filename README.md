# nvim

My neovim config

## Usage

### Prerequisites

- [neovim][neovim-home] `v0.9.5`
- [cargo][cargo-repo] `v1.73.0`
- [stylua][stylua-repo] `v0.20.0`: Install with `cargo` and `--features lua52`
- [pre-commit][pre-commit-home] `v3.5.0`

### Setup

Clone this project into the neovim config directory (`~/.config/nvim`).

#### Config

Configuration settings are driven by the `core.config` module, which contains all defaults. You
may set global overrides in a `~/.config/nvim/nvim.json` file.  Projects may also provide their own
local overrides in an `nvim.json` at the root of the project.  The schema for `nvim.json` files
is [nvim.schema.json](./nvim.schema.json).

Example `nvim.json`:

```json
{
  "$schema": "https://raw.githubusercontent.com/jacksonneal/nvim/minimal/nvim.schema.json",
  "colorscheme": "rose-pine-dawn"
}
```

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
[nvim-dap-python-repo]: https://github.com/mfussenegger/nvim-dap-python
[pre-commit-home]: https://pre-commit.com
[pytest-repo]: https://github.com/pytest-dev/pytest
[stylua-repo]: https://github.com/JohnnyMorganz/StyLua
