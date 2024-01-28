------------------------------------
------wirting by 98wubi Group-------
------http://98wb.ys168.com/--------
------------------------------------
-- Method example-------------------
--  translators:
--      - "lua_translator@time_date"
-----------------------------------

rv_var={ week_var="week",date_var="date",nl_var="nong",time_var="time",jq_var="jie"}	--编码关键字修改
new_spelling = require("ace/new_spelling")
helper = require("ace/helper")
require("ace/lunarDate")
require("ace/lunarJq")
require("ace/lunarGz")
local hotstring_translator= require("ace/hotstring")
local Getlongstring = hotstring_translator.Gettangtouge

function CnDate_translator(y)
	 local t,cstr,t2,t1
	 cstr = {"〇","一","二","三","四","五","六","七","八","九"}  t=""  t1=tostring(y)
	if t1.len(tostring(t1))~=8 then return t1 end
	 for i =1,t1.len(t1) do
		  t2=cstr[tonumber(t1.sub(t1,i,i))+1]
		  if i==5 and t2 ~= "〇" then t2="年十" elseif i==5 and t2 == "〇" then t2="年"  end
		  if i==6 and t2 ~= "〇" then t2 =t2 .. "月" elseif i==6 and t2 == "〇" then t2="月"  end
		  --if t.sub(t,t.len(t)-1)=="年" then t2=t2 .. "月" end
		  if i==7 and tonumber(t1.sub(t1,7,7))>1 then t2= t2 .. "十" elseif i==7 and t2 == "〇" then t2="" elseif i==7 and tonumber(t1.sub(t1,7,7))==1 then t2="十" end
		  if i==8 and t2 ~= "〇" then t2 =t2 .. "日" elseif i==8 and t2 == "〇" then t2="日"  end
		  t=t .. t2
	end
		  return t
end

local GetLunarSichen= function(time,t)
	local time=tonumber(time)
	local LunarSichen = {"子时(夜半｜三更)", "丑时(鸡鸣｜四更)", "寅时(平旦｜五更)", "卯时(日出)", "辰时(食时)", "巳时(隅中)", "午时(日中)", "未时(日昳)", "申时(哺时)", "酉时(日入)", "戌时(黄昏｜一更)", "亥时(人定｜二更)"}
	if tonumber(t)==1 then sj=math.floor((time+1)/2)+1 elseif tonumber(t)==0 then sj=math.floor((time+13)/2)+1 end
	if sj>12 then return LunarSichen[sj-12] else return LunarSichen[sj] end
end

--年天数判断
local function IsLeap(y)
	local year=tonumber(y)
	if math.fmod(year,400)~=0 and math.fmod(year,4)==0 or math.fmod(year,400)==0 then return 366
	else return 365 end
end

local format_Time= function()
	if os.date("%p")=="AM" then return "上午" else return "下午" end
end

local format_week= function(n)
	local obj={"日","一","二","三","四","五","六"}
	if tonumber(n)==1 then return "周"..obj[os.date("%w")+1] else return "星期"..obj[os.date("%w")+1] end
end
-------------------------------------------------------------
--[[
	--%a 星期简称，如Wed	%A 星期全称，如Wednesday
	--%b 月份简称，如Sep	%B 月份全称，如September
	--%c 日期时间格式 (e.g., 09/16/98 23:48:10)
	--%d 一个月的第几天 [01-31]	%j 一年的第几天
	--%H 24小时制 [00-23]	%I 12小时制 [01-12]
	--%M 分钟 [00-59]	%m 月份 (09) [01-12]
	--%p 上午/下午 (pm or am)
	--%S 秒 (10) [00-61]
	--%w 星期的第几天 [0-6 = Sunday-Saturday]	%W 一年的第几周
	--%x 日期格式 (e.g., 09/16/98)	%X 时间格式 (e.g., 23:48:10)
	--%Y 年份全称 (1998)	%y 年份简称 [00-99]
	--%% 百分号
	--os.date() 把时间戳转化成可显示的时间字符串
	--os.time ([table])
--]]
----------------------------------------------------------------

--公历日期
function date_translator(input, seg)
	local keyword = rv_var["date_var"]	--更多格式添加于dates之中
	if (input == keyword) then
		 local dates = {
			os.date("%Y-%m-%d 第%W周")
			,os.date("%Y年%m月%d日")
			,CnDate_translator(os.date("%Y%m%d"))
			,os.date("%Y-%m-%d｜%j/" .. IsLeap(os.date("%Y")))
			}
		-- Candidate(type, start, end, text, comment)
		for i =1,#dates do
			 yield(Candidate(keyword, seg.start, seg._end, dates[i], "〔日期〕"))
		end
		dates = nil
	end
end

--公历时间
function time_translator(input, seg)
	local keyword = rv_var["time_var"]	--更多格式添加于times之中
	if (input == keyword) then
		local times = {
			os.date("%H:%M:%S")
			,os.date("%Y-%m-%d " .. format_Time() .. "%I:%M")
			}
		for i =1,#times do
			yield(Candidate(keyword, seg.start, seg._end, times[i], "〔时间〕"))
		end
		times = nil
	end
end

--农历日期
function lunar_translator(input, seg)
	local keyword = rv_var["nl_var"]	--更多格式添加于lunar之中
	if (input == keyword) then
		local lunar = {
				{Date2LunarDate(os.date("%Y%m%d")) .. JQtest(os.date("%Y%m%d")),"〔公历⇉农历〕"}
				,{Date2LunarDate(os.date("%Y%m%d")) .. GetLunarSichen(os.date("%H"),1),"〔公历⇉农历〕"}
				,{lunarJzl(os.date("%Y%m%d%H")),"〔公历⇉干支〕"}
				,{LunarDate2Date(os.date("%Y%m%d"),0),"〔农历⇉公历〕"}
			}
		local leapDate={LunarDate2Date(os.date("%Y%m%d"),1).."（闰）","〔农历⇉公历〕"}
		if string.match(leapDate[1],"^(%d+)")~=nil then table.insert(lunar,leapDate) end
		for i =1,#lunar do
			yield(Candidate(keyword, seg.start, seg._end, lunar[i][1], lunar[i][2]))
		end
		lunar = nil
	end
end

local function QueryLunarInfo(date)
	local str,LunarDate,LunarGz,result,DateTime
	date=tostring(date) result={}
	str = date:gsub("^(%u+)","")
	if string.match(str,"^(20)%d%d+$")~=nil or string.match(str,"^(19)%d%d+$")~=nil then
		if string.len(str)==4 then str=str..string.sub(os.date("%m%d%H"),1) elseif string.len(str)==5 then str=str..string.sub(os.date("%m%d%H"),2) elseif string.len(str)==6 then str=str..string.sub(os.date("%m%d%H"),3) elseif string.len(str)==7 then str=str..string.sub(os.date("%m%d%H"),4)
		elseif string.len(str)==8 then str=str..string.sub(os.date("%m%d%H"),5) elseif string.len(str)==9 then str=str..string.sub(os.date("%m%d%H"),6) else str=string.sub(str,1,10) end
		if tonumber(string.sub(str,5,6))>12 or tonumber(string.sub(str,5,6))<1 or tonumber(string.sub(str,7,8))>31 or tonumber(string.sub(str,7,8))<1 or tonumber(string.sub(str,9,10))>24 then return result end
		LunarDate=Date2LunarDate(str)  LunarGz=lunarJzl(str)  DateTime=LunarDate2Date(str,0)
		if LunarGz~=nil then
			result={
				{CnDate_translator(string.sub(str,1,8)),"〔中文日期〕"}
				,{LunarDate,"〔公历⇉农历〕"}
				,{LunarGz,"〔公历⇉干支〕"}
			}
			if tonumber(string.sub(str,7,8))<31 then
				table.insert(result,{DateTime,"〔农历⇉公历〕"})
				local leapDate={LunarDate2Date(str,1).."（闰）","〔农历⇉公历〕"}
				if string.match(leapDate[1],"^(%d+)")~=nil then table.insert(result,leapDate) end
			end
		end
	end

	return result
end

--[[ ---------------测试----------------
local n=QueryLunarInfo(199105)
for i=1,#n do
	print(n[i][1]..n[i][2])
end
--]] ----------------------------------

-- 农历查询
function QueryLunar_translator(input, seg)	--以任意大写字母开头引导反查农历日期，日期位数不足会以当前日期补全。
	local str,lunar
	if string.match(input,"^(%u+%d+)$")~=nil then
		str = input:gsub("^(%a+)", "")
		if string.match(str,"^(20)%d%d+$")~=nil or string.match(str,"^(19)%d%d+$")~=nil then
			lunar=QueryLunarInfo(str)
			if #lunar>0 then
				for i=1,#lunar do
					yield(Candidate(input, seg.start, seg._end, lunar[i][1],lunar[i][2]))
				end
			end
		end
	end
end

--- single_char
function single_char(input, env)
	b = env.engine.context:get_option("single_char")
	for cand in input:iter() do
		if (not b or utf8.len(cand.text) == 1 or cand.type == "qsj" or cand.type == "time" or cand.type == "date" or cand.type == "help" or cand.type == "nl") then
			yield(cand)
		end
	end
end

--星期
function week_translator(input, seg)
	local keyword = rv_var["week_var"]	--更多格式添加于weeks之中
	if (input == keyword) then
		local weeks = {
			os.date("%Y年%m月%d日").." "..format_week(1)
			, os.date("%Y年%m月%d日").." "..format_week(0).." "..os.date("%H:%M:%S")
			}
		for i =1,#weeks do
			yield(Candidate(keyword, seg.start, seg._end, weeks[i], "〔星期〕"))
		end
		weeks = nil
	end
end

--列出当年余下的节气
function Jq_translator(input, seg)
	local keyword ,jqs
	keyword = rv_var["jq_var"]
	if (input == keyword) then
		jqs = GetNowTimeJq(os.date("%Y%m%d"))
		for i =1,#jqs do
			yield(Candidate(keyword, seg.start, seg._end, jqs[i], "〔节气〕"))
		end
		jqs = nil
	end
end

-------------------------------------------------------------
--[[
	文件lua\ace\longhotstring.lua可以自己编辑，也可以用工具生成，工具98资源库下载http://98wb.ys168.com/ 「小狼毫98五笔版辅助工具x64.exe」
--]]
----------------------------------------------------------------

-- 匹配长字符串
function longstring_translator(input, seg)	--编码为小写字母开头为过滤条件为"^(%l+%a+)" 以/开头的"^(%l+)"改为"^/"，编码为大写字母开头改为"^(%u+%a+)"，不分大小写为"^(%a+)"
	local str,m,strings
	if string.match(input,"^(%u+%a+)")~=nil then
		str = input:gsub("^/", "")
		str = str:lower(str)  strings=Getlongstring(str)
		if #strings>0 then
			for i =1,#strings do
				if strings[i][2]~="" then m="〔".. strings[i][2].."〕" else m="" end
				yield(Candidate(input, seg.start, seg._end, strings[i][1],m))
			end
		end
	end
end

local function splitNumPart(str)
	local part = {}
	part.int, part.dot, part.dec = string.match(str, "^(%d*)(%.?)(%d*)")
	return part
end

local function GetPreciseDecimal(nNum, n)
	if type(nNum) ~= "number" then nNum =tonumber(nNum) end
	n = n or 0;
	n = math.floor(n)
	if n < 0 then n = 0 end
	local nDecimal = 10 ^ n
	local nTemp = math.floor(nNum * nDecimal);
	local nRet = nTemp / nDecimal;
	return nRet;
end

local function decimal_func(str, posMap, valMap)
	local dec
	posMap = posMap or {[1]="角"; [2]="分"; [3]="厘"; [4]="毫"}
	valMap = valMap or {[0]="零"; "壹"; "贰"; "叁" ;"肆"; "伍"; "陆"; "柒"; "捌"; "玖"}
	if #str>4 then dec = string.sub(tostring(str), 1, 4) else dec =tostring(str) end
	dec = string.gsub(dec, "0+$", "")
	
	if dec == "" then return "整" end

	local result = ""
	for pos =1, #dec do
		local val = tonumber(string.sub(dec, pos, pos))
		if val~=0 then result = result .. valMap[val] .. posMap[pos] else result = result .. valMap[val] end
	end
	result=result:gsub(valMap[0]..valMap[0] ,valMap[0])
	return result:gsub(valMap[0]..valMap[0] ,valMap[0])
end
--
--把数字串按千分位四位数分割，进行转换为中文
local function formatNum(num,t)
	local digitUnit,wordFigure
	local result=""
	num=tostring(num)
	if tonumber(t) < 1 then digitUnit = {"", "十", "百","千"} else digitUnit = {"","拾","佰","仟"} end
	if tonumber(t) <1 then
		wordFigure = {"〇","一","二","三","四","五","六","七","八","九"}
	else wordFigure = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖"} end
	if string.len(num)>4 or tonumber(num)==0 then return wordFigure[1] end
	local lens=string.len(num)
	for i=1,lens do
		local n=wordFigure[tonumber(string.sub(num,-i,-i))+1]
		if n~=wordFigure[1] then result=n .. digitUnit[i] .. result else result=n .. result end
	end
	result=result:gsub(wordFigure[1]..wordFigure[1] ,wordFigure[1])
	result=result:gsub(wordFigure[1].."$","") result=result:gsub(wordFigure[1].."$","")

	return result
end

--数值转换为中文
function number2cnChar(num,flag)    --flag=0中文小写反之为大写
	local digitUnit,st,wordFigure,result
	num=tostring(num) result=""
	local num1,num2=math.modf(num)
	if tonumber(num2)==0 then
		if tonumber(flag) < 1 then
			digitUnit = {"万","亿"}  wordFigure={"〇","一","十","元"}
		else
			digitUnit = {"万","亿"}  wordFigure={"零","壹","拾","圆"}
		end
		local lens=string.len(num1)
		if lens<5 then result=formatNum(num1,flag) elseif lens<9 then result=formatNum(string.sub(num1,1,-5),flag) .. digitUnit[1].. formatNum(string.sub(num1,-4,-1),flag)
		elseif lens<13 then result=formatNum(string.sub(num1,1,-9),flag) .. digitUnit[2] .. formatNum(string.sub(num1,-8,-5),flag) .. digitUnit[1] .. formatNum(string.sub(num1,-4,-1),flag) else result="" end
		result=result:gsub("^" .. wordFigure[1],"") result=result:gsub(wordFigure[1] .. digitUnit[1],"") result=result:gsub(wordFigure[1] .. digitUnit[2],"")
		result=result:gsub(wordFigure[1] .. wordFigure[1],wordFigure[1]) result=result:gsub(wordFigure[1] .. "$","")
		if lens>4 then result=result:gsub("^"..wordFigure[2].. wordFigure[3],wordFigure[3]) end
		if result~="" then result=result .. wordFigure[4] else result="数值超限！" end
	else return "数值超限！" end

	return result
end

function number_translator(input,seg)
	local str,num,numberPart
	if string.match(input,"^(%u+%d+)(%.?)(%d*)$")~=nil then
		str = input:gsub("^(%a+)", "")  numberPart=splitNumPart(str)
		if tonumber(str)>0 then
			num={
				{number2cnChar(numberPart.int,1)..decimal_func(numberPart.dec,{[1]="角"; [2]="分"; [3]="厘"; [4]="毫"},{[0]="零"; "壹"; "贰"; "叁" ;"肆"; "伍"; "陆"; "柒"; "捌"; "玖"}),"〔金额大写〕"}
				,{number2cnChar(numberPart.int,0)..decimal_func(numberPart.dec,{[1]="角"; [2]="分"; [3]="厘"; [4]="毫"},{[0]="〇"; "一"; "二"; "三" ;"四"; "五"; "六"; "七"; "八"; "九"}),"〔金额小写〕"}
			}
			if #num>0 then
				for i=1,#num do
					yield(Candidate(input, seg.start, seg._end, num[i][1],num[i][2]))
				end
			end
		end
	end
end

--- time/date/week/nl
function time_date(input, seg)
	date_translator(input, seg)
	time_translator(input, seg)
	week_translator(input, seg)
	lunar_translator(input, seg)
	Jq_translator(input, seg)
	longstring_translator(input, seg)
	QueryLunar_translator(input, seg)
	number_translator(input,seg)
end

--- 过滤器：单字在先
function single_char_first_filter(input)
    local l = {}
    for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    for cand in ipairs(l) do
        yield(cand)
    end
end
