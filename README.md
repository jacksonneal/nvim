# nvim

My neovim config.

## Usage

### Prerequisites

- [neovim][neovim-home] `v0.10.4`
- [cargo][cargo-repo] `v1.85.0`
- [stylua][stylua-repo] `v2.0.2`
  - install via `cargo install stylua --features lua52`
- [python][python-downloads] `v3.12.0`
- [pre-commit][pre-commit-home] `v4.0.1`
  - install via `pip install pre-commit`

### Setup

Clone this project into your neovim user config directory (see [initialization #7][nvim-doc-initialization]).

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
[nvim-doc-initialization]: https://neovim.io/doc/user/starting.html#initialization
[pre-commit-home]: https://pre-commit.com
[pytest-repo]: https://github.com/pytest-dev/pytest
[python-downloads]: https://www.python.org/downloads/
[stylua-repo]: https://github.com/JohnnyMorganz/StyLua
