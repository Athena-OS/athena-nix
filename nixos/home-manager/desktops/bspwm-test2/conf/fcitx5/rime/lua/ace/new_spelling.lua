local basic = require('ace/lib/basic')
local map = basic.map
local index = basic.index
local utf8chars = basic.utf8chars
local matchstr = basic.matchstr

local function xform(input)
  if input == "" then return "" end
  input = input:gsub('%[', '〔')
  input = input:gsub('%]', '〕')
  input = input:gsub('※', ' ')
  input = input:gsub('_', ' ')
  input = input:gsub(',', '·')
  return input
end

local function subspelling(str, ...)
  local first, last = ...
  if not first then return str end
  local radicals = {}
  local s = str
  s = s:gsub('{', ' {')
  s = s:gsub('}', '} ')
  for seg in s:gmatch('%S+') do
    if seg:find('^{.+}$') then
      table.insert(radicals, seg)
    else
      for pos, code in utf8.codes(seg) do
        table.insert(radicals, utf8.char(code))
      end
    end
  end
  return table.concat{ table.unpack(radicals, first, last) }
end

local function lookup(db)
  return function (str)
    return db:lookup(str)
  end
end

local function parse_spll(str)
  local s = string.gsub(str, ',.*', '')
  return string.gsub(s, '^%[', '')
end

local function spell_phrase(s, spll_rvdb)
  local chars = utf8chars(s)
  local rvlk_results
  if #chars == 2 or #chars == 3 then
    rvlk_results = map(chars, lookup(spll_rvdb))
  else
    rvlk_results = map({chars[1], chars[2], chars[3], chars[#chars]},
        lookup(spll_rvdb))
  end
  if index(rvlk_results, '') then return '' end
  local spellings = map(rvlk_results, parse_spll)
  local sup = '◇'
  if #chars == 2 then
    return subspelling(spellings[1] .. sup, 1, 2) ..
           subspelling(spellings[2] .. sup, 1, 2)
  elseif #chars == 3 then
    return subspelling(spellings[1], 1, 2) ..
           subspelling(spellings[2], 1, 1) ..
           subspelling(spellings[3] .. sup, 1, 1)
  else
    return subspelling(spellings[1], 1, 1) ..
           subspelling(spellings[2], 1, 1) ..
           subspelling(spellings[3], 1, 1) ..
           subspelling(spellings[4], 1, 1)
  end
end

local function get_tricomment(cand, env)
  local ctext = cand.text
  if utf8.len(ctext) == 1 then
    local spll_raw = env.spll_rvdb:lookup(ctext)
    if spll_raw ~= '' then
      if env.engine.context:get_option("new_hide_pinyin") then
      -- return xform(spll_raw:gsub('%[(.-,.-),.+%]', '[%1]'))
         return xform(spll_raw:gsub('%[(.-),.+%]', '[%1]'))
      else
        return xform(spll_raw)
      end
    end
  else
    local spelling = spell_phrase(ctext, env.spll_rvdb)
    if spelling ~= '' then
      spelling = spelling:gsub('{(.-)}', '<%1>')
      local code = env.code_rvdb:lookup(ctext)
      if code ~= '' then
        code = matchstr(code, '%S+')
        table.sort(code, function(i, j) return i:len() < j:len() end)
        code = table.concat(code, ' ')
        return '〔 ' .. spelling .. ' · ' .. code .. ' 〕'
      else
        return '〔 ' .. spelling .. ' 〕'
      end
    end
  end
  return ''
end

local function filter(input, env)
  if env.engine.context:get_option("new_spelling") then
    for cand in input:iter() do
      if cand.type == 'simplified' and env.name_space == 'new_for_rvlk' then
        local comment = get_tricomment(cand, env) .. cand.comment
        yield(Candidate("simp_rvlk", cand.start, cand._end, cand.text, comment))
      else
        local add_comment = ''
        if cand.type == 'punct' then
          add_comment = env.code_rvdb:lookup(cand.text)
        elseif cand.type ~= 'sentence' then
          add_comment = get_tricomment(cand, env)
        end
        if add_comment ~= '' then
          if cand.type ~= 'completion' and (
              (env.name_space == 'new' and env.is_mixtyping) or
              (env.name_space == 'new_for_rvlk')
              ) then
            cand.comment = add_comment
          else
            cand.comment = add_comment .. cand.comment
          end
        end
        yield(cand)
      end
    end
  else
    for cand in input:iter() do yield(cand) end
  end
end

local function init(env)
  local config = env.engine.schema.config
  local spll_rvdb = config:get_string('lua_reverse_db/spelling')
  local code_rvdb = config:get_string('lua_reverse_db/code')
  local abc_extags_size = config:get_list_size('abc_segmentor/extra_tags')
  env.spll_rvdb = ReverseDb('build/' .. spll_rvdb .. '.reverse.bin')
  env.code_rvdb = ReverseDb('build/' .. code_rvdb .. '.reverse.bin')
  env.is_mixtyping = abc_extags_size > 0
end

return { init = init, func = filter }



