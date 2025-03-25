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

### Configuration

Configuration is handled by [neoconf.nvim][neoconf.nvim-repo].


[cargo-repo]: https://github.com/rust-lang/cargo
[neoconf.nvim-repo]: https://github.com/folke/neoconf.nvim
[neovim-home]: https://neovim.io
[nvim-build]: https://github.com/neovim/neovim/blob/master/BUILD.md
[nvim-doc-initialization]: https://neovim.io/doc/user/starting.html#initialization
[pre-commit-home]: https://pre-commit.com
[python-downloads]: https://www.python.org/downloads/
[stylua-repo]: https://github.com/JohnnyMorganz/StyLua
