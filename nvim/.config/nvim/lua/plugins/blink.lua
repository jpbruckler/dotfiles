return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '*',
  build = 'cargo build --release',
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = {
      implementation = 'prefer_rust_with_warning',
      max_typos = function(keyword) return math.floor(#keyword / 4) end,
      use_frecency = true,
      use_proximity = true,
      use_unsafe_no_lock = false,
      sorts = {
        'score',
        'sort_text',
      },

      prebuilt_binaries = {
        download = false,
        ignore_version_mismatch = false,
        force_version = nil,
        force_system_triple = nil,
        extra_curl_args = {}
      },
    },
  },
  opts_extend = { "sources.default" },
}
