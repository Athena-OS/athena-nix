-- helper.lua
-- List features and usage of the schema.

local function translator(input, seg)
  if input:find('^help$') then
    local table = {
          { '选单', 'Ctrl+` 或 F4' }
        , { 'lua字符串', '以大写字母开头' }
        , { '农历反查', '任意大写字母引导+数字日期' }
        , { '时间', rv_var["date_var"] .. '｜' .. rv_var["time_var"] .. '｜' .. rv_var["week_var"] }
        , { '历法', rv_var["nl_var"] .. '｜' .. rv_var["jq_var"] }
        , { '繁简切换', 'Ctrl + Shift + F' }
        , { 'Emoji开关', 'Ctrl + Shift + G' }
        , { '显隐编码', 'Ctrl + Shift + H' }
        , { '显隐拼音', 'Ctrl + Shift + J' }
        , { '单字模式', 'Ctrl + Shift + k' }
        , { '金额大写', '任意大写字母引导+数字' }
        , { '临时拼音', 'i 键引导临时拼音及形码' }
        , { '重复历史', 'uj 重复历史' }
        , { '精准造词', '` 键引导精准造词' }
        , { '选单', 'Ctrl+` 或 F4' }
        , { 'lua字符串', '以大写字母开头触发' }
        , { '官方网盘', 'http://fds8866.ys168.com' }
        , { '博客', 'https://liangbi.gitee.io' }
        , { 'QQ群', '715024083' }
    }
    for k, v in ipairs(table) do
      local cand = Candidate('help', seg.start, seg._end, v[2], ' ' .. v[1])
      cand.preedit = input .. '\t简要说明'
      yield(cand)
    end
  end
end

return translator
