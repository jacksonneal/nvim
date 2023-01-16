return {
	filetypes = { "haskell", "lhaskell", "cabal" },
	cmd = { "haskell-language-server-wrapper", "--lsp" },
	haskell = {
		cabalFormattingProvider = "cabalfmt",
		formattingProvider = "ormolu",
	},
	single_file_support = true,
}
