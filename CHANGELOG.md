# Changelog

All notable changes to this project will be documented in this file.

## 10-24-2024

### Added
- Ability to disable denols, disabled by default

## 10-20-2024

### Added
- Deno support
- Ability to disable eslint LSP

## 08-29-2024

### Added
- Treesitter graphql support

## 08-28-2024

### Fixed
- Neovim `v0.10` support

## 07-26-2024

### Added
- Support for `pyright.pythonPath` setting.

## 07-25-2024

### Added
- `nvim.json` example file in `README.md`.
- Recognize ".hell" files as type "haskell".

## 07-22-2024

### Changed
- Allow additional properties in root of `nvim.schema.json`.  Allows for meta keys like `$schema`.

## 07-15-2024

### Added
- LSP enable/disable to settings schema

## 07-14-2024

### Fixed
- Update instructions for running `stylua` with Lua `v5.2`

## 07-13-2024

### Changed
- Config settings files is now named `nvim.json`

### Added
- Global config setting override abilities
- Config settings schema in `nvim.schema.json`
- Documentation on config settings

## 07-11-2024

### Changed
- Python DAP test runner uses `pytest`
- Python DAP venv expected at `./.venv`

### Added
- Debug keymap documentation

## 07-03-2024

### Added
- Add keymap `<leader>gb` to `:CurLnBlameToggle`

## 06-27-2024

### Changed
- Set `vim.opt.conceallevel = 0`

### Fixed
- Fix `cur_ln_blame.nvim` bug leaving file handles open

### Added
- Add changelog
