-- basic.lua

local basic = {}
package.loaded[...] = basic

function basic.index(table, item)
  for k, v in pairs(table) do
    if v == item then return k end
  end
end

function basic.map(table, func)
  local t = {}
  for k, v in pairs(table) do
    t[k] = func(v)
  end
  return t
end

function basic.matchstr(str, pat)
  local t = {}
  for i in str:gmatch(pat) do
    t[#t + 1] = i
  end
  return t
end

function basic.utf8chars(str, ...)
  local chars = {}
  for pos, code in utf8.codes(str) do
    chars[#chars + 1] = utf8.char(code)
  end
  return chars
end

function basic.utf8sub(str, first, ...)
  local last = ...
  if last == nil or last > utf8.len(str) then
    last = utf8.len(str)
  elseif last < 0 then
    last = utf8.len(str) + 1 + last
  end
  local fstoff = utf8.offset(str, first)
  local lstoff = utf8.offset(str, last + 1)
  if fstoff == nil then fstoff = 1 end
  if lstoff ~= nil then lstoff = lstoff - 1 end
  return string.sub(str, fstoff, lstoff)
end

