-- Dev plugins.

return {
  {
    "jacksonneal/jax.cur_ln_dx",
    main = "jax.cur_ln_dx",
    dev = true,
    opts = { is_enabled = true },
  },
  {
    "jacksonneal/jax.cur_ln_blame",
    main = "jax.cur_ln_blame",
    dev = true,
    config = true,
  },
}
