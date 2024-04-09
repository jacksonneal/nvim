return {
  {
    "jacksonneal/jax.cur_ln_dx",
    dev = true,
  },
  {
    "jacksonneal/jax.cur_ln_git_blame",
    dev = true,
    config = function()
      require("jax.cur_ln_git_blame").setup()
    end,
  },
}
