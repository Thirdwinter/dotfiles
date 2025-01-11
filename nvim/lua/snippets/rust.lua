local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Add a Rust snippet for println!
ls.add_snippets('rust', {
  s('pp', {
    t 'println!("{',
    i(1),
    t '}", ',
    i(2, 'args'),
    t ');',
  }),
})
