if true then
  return {}
end
return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- 如果你想总是获取最新版本，请设置此项
    opts = {
      provider = 'openai',
      auto_suggestions_provider = 'openai', -- 由于自动建议是高频率操作，因此成本较高，建议指定一个成本较低的提供商或免费提供商：copilot
      openai = {
        endpoint = 'https://api.deepseek.com/v1',
        model = 'deepseek-chat',
        timeout = 30000, -- 超时时间，单位毫秒
        temperature = 0,
        max_tokens = 4096,
        -- 可选配置
        api_key_name = 'OPENAI_API_KEY', -- 如果未设置则默认使用 OPENAI_API_KEY
      },
    },
    -- 如果你想从源码构建，请执行 `make BUILD_FROM_SOURCE=true`
    build = 'make BUILD_FROM_SOURCE=true',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- Windows 系统使用
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- 以下依赖是可选的
      'nvim-tree/nvim-web-devicons', -- 或者使用 echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- 用于 providers='copilot'
      {
        -- 支持图片粘贴
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- 推荐设置
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- Windows 用户需要设置此项
            use_absolute_path = true,
          },
        },
      },
      {
        -- 如果你设置了 lazy=true，请确保正确配置此项
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
