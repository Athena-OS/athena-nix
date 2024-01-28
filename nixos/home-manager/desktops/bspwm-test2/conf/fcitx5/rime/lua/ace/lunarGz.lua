------------------------------------
------wirting by 98wubi Group-------
------http://98wb.ys168.com/--------
------------------------------------

--公历转干支历实现
--[[干支历的年以立春发生时刻（注意，不是立春日的0时）为年干支的起点；各月干支以十二节时刻（注意，不一定是各节气日的0时）
--]]
--require('common')
require("ace/lunarJq")

GanZhiLi = {
}

--创建干支历对象
function GanZhiLi:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:setTime(os.time())
    return o
end

--将offset的数值转化为特定偏移下的周期数，起始数，偏移量，周期
function GanZhiLi:calRound(start, offset, round)
    if start > round or start <=0 then return nil end --参数不对
    offset = math.floor(math.fmod(start+offset, round))
    if offset >=0 then
        if offset==0 then offset=round end
        return offset
    else
        return round + offset
    end
end

--周期循环数
function calR2(n, round)
    local x = math.floor(math.fmod(n,round))
    if x==0 then x=round end
    return x
end

--设置用于转换干支历的公历时间
function GanZhiLi:setTime(t)
    self.ttime = t
    self.tday = os.date('*t', t)
    --for k,v in pairs(self.tday) do
    --    print(k,v)
    --end
    --先取公历今年的干支
    self.jqs = getYearJQ(self.tday.year)
    self.ganZhiYearNum = self:calGanZhiYearNum()
    if self.ganZhiYearNum ~= self.tday.year then
        --如果在节气上还没到今年的立春，则还没到干支历的今年，需要取干支历的年份的24节气
        self.jqs = getYearJQ(self.ganZhiYearNum)
    end
    self.ganZhiMonNum = self:calGanZhiMonthNum()
    self.curJq = self:getCurJQ()

end

function GanZhiLi:getCurJQ()
    --for i=1,24 do
    --    local x = os.date('*t', self.jqs[i])
    --    print(x.year, x.month, x.day, x.hour, x.min, x.sec)
    --end
    local x = 0
    if self.ttime < self.jqs[1] then return nil end --出错，计算错年了？
    for i=1,23 do
        if self.jqs[i] <= self.ttime and self.jqs[i+1] > self.ttime then x=i break end
    end
    if x==0 then x=24 end
    return x --返回以立春为起始序号1的节气
end


--根据公历年份和节气计算干支历的年份
function GanZhiLi:calGanZhiYearNum()
    if (self.ttime < self.jqs[1]) then return self.tday.year -1
    else return self.tday.year end
end

--获取干支月份
function GanZhiLi:calGanZhiMonthNum()
    if self.ttime < self.jqs[1] then return nil end
    local x = 0
    if self.ttime < self.jqs[1] then return nil end --出错，计算错年了？
    for i=1,23 do
        if self.jqs[i] <= self.ttime and self.jqs[i+1] > self.ttime then x=i end
    end
    if x==0 then x=24 end
    return math.floor((x+1)/2)
end


--返回年的干支序号，1为甲子。。。
function GanZhiLi:getYearGanZhi()
    local jiaziYear = 1984 --甲子年
    --print(self.ganZhiYearNum)
    local yeardiff = self.ganZhiYearNum - jiaziYear
    return self:calRound(1,yeardiff,60)
end

--返回年的天干号，1为甲
function GanZhiLi:getYearGan()
    local idx = self:getYearGanZhi()
    return self:calR2(idx,10)
end

--返回年的地支号，1为子
function GanZhiLi:getYearZhi()
    local idx = self:getYearGanZhi()
    return self:calR2(idx,12)
end

--返回月的干支号
function GanZhiLi:getMonGanZhi()
    local ck ={year=2010,month=2,day=4,hour=6,min=42,sec=0}
    local x = os.time(ck) --参考月，立春时间2010-2-4 6:42:00对应的干支序号为15
    local ydiff = self.ganZhiYearNum - ck.year
    local mdiff = self.ganZhiMonNum-1
    if ydiff >=0 then
        mdiff = ydiff*12 + mdiff
    else
        mdiff = (ydiff+1)*12 + mdiff -12
    end
    return self:calRound(15,mdiff, 60)
end


function GanZhiLi:getMonGan()
    local idx = self:getMonGanZhi()
    return self:calR2(idx,10)
end

function GanZhiLi:getMonZhi()
    local idx = self:getMonGanZhi()
    return self:calR2(idx,12)
end

--返回日的干支号，甲子从1开始
function GanZhiLi:getDayGanZhi()
    local DAYSEC = 24*3600
    local jiaziDayTime = os.time({year=2012, month=8, day=30, hour=23, min=0,sec=0})
    local daydiff = math.floor((self.ttime - jiaziDayTime)/DAYSEC)
    return self:calRound(1,daydiff,60)
end

--返回日的天干号
function GanZhiLi:getDayGan()
    local idx = self:getDayGanZhi()
    return self:calR2(idx,10)
end

--返回日的地支号
function GanZhiLi:getDayZhi()
    local idx = self:getDayGanZhi()
    return self:calR2(idx,12)
end

--返回时辰的干支号
function GanZhiLi:getHourGanZhi()
    local SHICHENSEC=3600*2
    local jiaziShiTime = os.time({year=2012, month=8, day=30, hour=23, min=0, sec=0})
    local shiDiff = math.floor((self.ttime - jiaziShiTime)/SHICHENSEC)
    return self:calRound(1,shiDiff,60)
end

--返回时干号
function GanZhiLi:getShiGan()
    local idx = self:getHourGanZhi()
    return self:calR2(idx,10)
end

--返回时支号
function GanZhiLi:getShiZhi()
    local idx = self:getHourGanZhi()
    return self:calR2(idx,12)
end





--====================以下是测试代码=============

local jqB={ --节气表
"立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露",
"秋分","寒露","霜降","立冬","小雪","大雪","冬至","小寒","大寒",}
--天干
local tiangan = {'甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'}

--地支
local dizhi = {'子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'}


--根据六十甲子序号，返回六十甲子字符串,甲子从1开始
local function get60JiaZiStr(i)
local gan = i % 10
        if gan == 0  then gan = 10 end
        local zhi = i % 12
        if zhi == 0 then zhi = 12 end
        return tiangan[gan]..dizhi[zhi]
end

function lunarJzl(y)
    local x,yidx,midx,didx,hidx
    y=tostring(y)
    x = GanZhiLi:new()
    x:setTime(os.time({year=tonumber(y.sub(y,1,4)),month=tonumber(y.sub(y,5,-5)), day=tonumber(y.sub(y,7,-3)),hour=tonumber(y.sub(y,9,-1)),min=4,sec=5}))
    yidx = x:getYearGanZhi()
    midx = x:getMonGanZhi()
    didx = x:getDayGanZhi()
    hidx = x:getHourGanZhi()
    GzData= get60JiaZiStr(yidx) .. '年' .. get60JiaZiStr(midx) .. '月' .. get60JiaZiStr(didx) .. '日' .. get60JiaZiStr(hidx) .. '时'
    --print('干支:'  .. GzData)
    return GzData
end

--测试
--print(lunarJzl(os.date("%Y%m%d%H")))