-- Module for file type detection.

vim.filetype.add({
  extension = {
    hell = "haskell",
  },
  filename = {
    ["justfile"] = "make",
  },
})
