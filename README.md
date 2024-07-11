# Neovim Config

## Usage

### Prerequisites

- [Neovim](https://neovim.io/) `v0.9.1`

### Setup

- Clone this project into your Neovim config directory (`~/.config/nvim` by default)

## Development

### Prerequisites

- [pre-commit](https://pre-commit.com/) `v3.5.0`

## DAP

### Python

Debugging in Python is supported through [nvim-dap-python][nvim-dap-python-repo] plugin, which
is configured to use a virtual environment located at `./.venv` and [pytest][pytest-repo] as a
test runner.

#### Usage

| Keymap        | Command                  |
| ------------- | ------------------------ |
| `<leader>dpr` | Debug current function   |
| `F9`          | Toggle DAP UI            |
| `<leader>db`  | Toggle breakpoint        |
| `F5`          | Continue from breakpoint |



[nvim-dap-python-repo]: https://github.com/mfussenegger/nvim-dap-python
[pytest-repo]: https://github.com/pytest-dev/pytest
