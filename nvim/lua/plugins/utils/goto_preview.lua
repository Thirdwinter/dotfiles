return {
  'rmagatti/goto-preview',
  lazy = true,
  keys = {
    { 'gpd', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>', { noremap = true, desc = '预览定义' } },
    { 'gpt', '<cmd>lua require("goto-preview").goto_preview_type_definition()<CR>', { noremap = true, desc = '预览类型定义' } },
    { 'gpi', '<cmd>lua require("goto-preview").goto_preview_implementation()<CR>', { noremap = true, desc = '预览实现' } },
    { 'gpD', '<cmd>lua require("goto-preview").goto_preview_declaration()<CR>', { noremap = true, desc = '预览声明' } },
    { 'gP', '<cmd>lua require("goto-preview").close_all_win()<CR>', { noremap = true, desc = '关闭所有预览窗口' } },
    { 'gpr', '<cmd>lua require("goto-preview").goto_preview_references()<CR>', { noremap = true, desc = '预览引用' } },
  },
  config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
}
