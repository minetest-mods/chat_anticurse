-- Minetest 0.4.10+ mod: chat_anticurse
-- punish player for cursing by disconnecting them
--
--  Created in 2015 by Andrey.
--  Updated in 2024 by Olivia May.
--  Some words from NoNameDude
--  This mod is Free and Open Source Software, released under the LGPL 2.1 or later.
--
-- See README.txt for more information.

chat_anticurse = {}

local v1 = "i"
local v2 = "a"
local v3 = "u"
local v4 = "e"
local v5 = "o"

-- Russian / Cyrilic
local v6 = "о"
local v7 = "е"
local v8 = "а"
local v9 = "з"
local v10 = "у"
local v11 = "и"
local v12 = "я"

-- List of curse words. Put spaces before and after word to prevent the
-- Scunthorpe problem: https://en.wikipedia.org/wiki/Scunthorpe_problem
-- Some words don't have spaces because they shouldn't be in any words.
local curse_words = {
	-- English
	" " .. v2 .. "ss ",
	" d" .. v1 .. "ck ",
	" p" .. v4 .. "n" .. v1 .. "s ",
	"t" .. v4 .. "st" .. v1 .. "cl" .. v4 .. "",
	" p" .. v3 .. "ssy ",
	" h" .. v5 .. "rny ",
	" b" .. v1 .. "tch ",
	" b" .. v1 .. "tch" .. v4 .. " ",
	" " .. v4 .. "s" .. v4 .. "x ",
	" c" .. v3 .. "nt ",
	" f" .. v3 .. "ck ",
	"" .. v2 .. "rs" .. v4 .. "h" .. v5 .. "l" .. v4 .. "",
	" c" .. v3 .. "m ",
	" sh" .. v1 .. "t ",
	"sh" .. v1 .. "tst" .. v5 .. "rm",
	"sh" .. v1 .. "tst" .. v2 .. "" .. v1 .. "n",
	" c" .. v5 .. "ck ",
	"n" .. v1 .. "gg" .. v4 .. "r",
	"f" .. v2 .. "gg" .. v5 .. "t",
	" f" .. v2 .. "g ",
	" wh" .. v5 .. "r" .. v4 .. " ",
	" " .. v1 .. "nc" .. v4 .. "l ",
	" c" .. v3 .. "ck ",
	" f" .. v3 .. "ck" .. v4 .. "r ",
	" f" .. v3 .. "ck" .. v1 .. "ng ",
	"m" .. v5 .. "th" .. v4 .. "rf" .. v3 .. "ck",
	" v" .. v2 .. "g" .. v1 .. "n" .. v2 .. " ",
	" v" .. v2 .. "g ",
	" v" .. v3 .. "lv" .. v2 .. " ",
	" cl" .. v1 .. "t ",
	" p" .. v4 .. "n" .. v1 .. "l" .. v4 .. " ",
	" " .. v2 .. "" .. v3 .. "t" .. v1 .. "st ",
	"m" .. v2 .. "st" .. v3 .. "rb" .. v2 .. "t",
	"" .. v1 .. "nt" .. v4 .. "rc" .. v5 .. "" .. v3 .. "rs" .. v4 .. "",
	"" .. v2 .. "ssh" .. v5 .. "l" .. v4 .. "",
	"" .. v2 .. "sswh" .. v1 .. "p" .. v4 .. "",
	"" .. v2 .. "ssw" .. v1 .. "p" .. v4 .. "",
	"c" .. v5 .. "cks" .. v3 .. "ck" .. v4 .. "r",
	"b" .. v1 .. "tch" .. v2 .. "ss",
	"t" .. v1 .. "tt" .. v1 .. "" .. v4 .. "s",
	" t" .. v1 .. "ts ",
	"d" .. v4 .. "g" .. v4 .. "n" .. v4 .. "r" .. v2 .. "t" .. v4 .. "",
	"b" .. v2 .. "st" .. v2 .. "rd",
	" p" .. v5 .. "rn ",
	"p" .. v5 .. "rn" .. v5 .. "gr" .. v2 .. "phy",
	"tr" .. v2 .. "nny",
	"ywnb" .. v2 .. "w",
	"ywnb" .. v2 .. "m",
	" k" .. v1 .. "k" .. v4 .. " ",
	" kys ",
	"k" .. v1 .. "ll y" .. v5 .. "" .. v3 .. "rs" .. v4 .. "lf",

	-- Russian
	" " .. v7 .. "б" .. v8 .. " ",
	" бл" .. v12 .. " ",
	" ж" .. v6 .. "п ",
	" х" .. v10 .. "й ",
	" чл" .. v7 .. "н ",
	" п" .. v11 .. "" .. v9 .. "д ",
	" в" .. v6 .. "" .. v9 .. "б" .. v10 .. "д ",
	" в" .. v6 .. "" .. v9 .. "бyж ",
	" сп" .. v7 .. "рм ",
	" бл" .. v12 .. "д ",
	" бл" .. v12 .. "ть ",
	" с" .. v6 .. "кс ",
	" с" .. v10 .. "к" .. v8 .. " ",
	" мл" .. v12 .. " ",
	" бл" .. v11 .. "н ",
	" тв" .. v6 .. "ю м" .. v8 .. "ть ",
	" тв" .. v6 .. "ю ж" .. v7 .. " м" .. v8 .. "ть ",
	" д" .. v11 .. "б" .. v11 .. "л ",
	" " .. v8 .. "" .. v10 .. "т ",
	" " .. v8 .. "" .. v10 .. "т" .. v11 .. "ст ",
	" м" .. v8 .. "нд" .. v8 .. " ",
	" " .. v7 .. "б" .. v8 .. "ть ",
	" " .. v7 .. "б" .. v8 .. "л" .. v6 .. " " .. v9 .. "" .. v8 .. "кр" .. v6 .. "й ",
	" " .. v9 .. "" .. v8 .. "" .. v7 .. "б" .. v8 .. "л ",
	" " .. v6 .. "тв" .. v8 .. "л" .. v11 .. " ",
	" " .. v9 .. "" .. v8 .. "ткн" .. v11 .. "сь ",
	" м" .. v10 .. "д" .. v8 .. "к ",
	" х" .. v10 .. "й ",
	" " .. v6 .. "х" .. v10 .. "" .. v7 .. "л? ",
	" эт" .. v6 .. " п" .. v11 .. "" .. v9 .. "д" .. v7 .. "ц ",
	" п" .. v11 .. "" .. v9 .. "д" .. v8 .. " ",
	" св" .. v6 .. "л" .. v6 .. "чь ",
	" ж" .. v6 .. "п" .. v8 .. " ",
	" г" .. v8 .. "вн" .. v6 .. " ",
	" л" .. v6 .. "х ",
	" г" .. v8 .. "нд" .. v6 .. "н ",
	" " .. v10 .. "блюд" .. v6 .. "к ",
	" ср" .. v8 .. "ть ",
	" мн" .. v7 .. " н" .. v8 .. "ср" .. v8 .. "ть ",
	" мн" .. v7 .. " п" .. v6 .. "х" .. v10 .. "й ",
	" ч" .. v7 .. "рт ",
	" тр" .. v8 .. "хн" .. v10 .. "ть ",
	" тр" .. v8 .. "хн" .. v10 .. "л ",
	" д" .. v7 .. "г" .. v7 .. "н" .. v7 .. "р" .. v8 .. "т ",
	" хр" .. v7 .. "н ",
	" х" .. v10 .. "й ",
	" д" .. v7 .. "рьм" .. v6 .. " ",
	" п" .. v6 .. "ш" .. v7 .. "л к ч" .. v6 .. "рт" .. v10 .. " ",
	" мн" .. v7 .. " пл" .. v7 .. "в" .. v8 .. "ть ",
	" х" .. v7 .. "рн" .. v12 .. " ",
	" хр" .. v7 .. "нь ",
	" " .. v6 .. "д" .. v11 .. "н хр" .. v7 .. "н ",
	" н" .. v11 .. " хр" .. v7 .. "н" .. v8 .. " ",
	" н" .. v10 .. " " .. v7 .. "г" .. v6 .. " н" .. v8 .. "хр" .. v7 .. "н ",
	" " .. v11 .. "д" .. v11 .. " н" .. v8 .. "х" .. v7 .. "р ",
	" н" .. v8 .. "хр" .. v7 .. "н ",
	" п" .. v6 .. "шёл ",
	" н" .. v8 .. "х" .. v7 .. "р ",
	" н" .. v8 .. "хр" .. v7 .. "н ",

	-- German
	" " .. v2 .. "rschl" .. v5 .. "ch ",
	" " .. v2 .. "rsch ",
	" schw" .. v2 .. "nz ",
	" w" .. v1 .. "chs" .. v4 .. "r ",
	" schl" .. v2 .. "mp" .. v4 .. " ",
	" h" .. v3 .. "rr" .. v4 .. " ",
	" f" .. v1 .. "ck d" .. v1 .. "ch ",
	" m" .. v3 .. "tt" .. v4 .. "rf" .. v1 .. "ck" .. v4 .. "r ",
	" h" .. v3 .. "r" .. v4 .. "ns" .. v5 .. "hn ",
	" m" .. v2 .. "st" .. v3 .. "b" .. v1 .. "r" .. v4 .. "n ",
	" sch" .. v4 .. "" .. v1 .. "d" .. v4 .. " ",
	" g" .. v4 .. "schl" .. v4 .. "chtsv" .. v4 .. "rk" .. v4 .. "hr ",
	" f" .. v5 .. "tz" .. v4 .. " ",
	" m" .. v1 .. "ssg" .. v4 .. "b" .. v3 .. "rt ",
	" m" .. v1 .. "ssg" .. v4 .. "b" .. v3 .. "rt ",
	" v" .. v5 .. "ll" .. v1 .. "d" .. v1 .. "" .. v5 .. "t ",
	" brüst" .. v4 .. " ",
	" t" .. v1 .. "tt" .. v4 .. "n ",
	" sch" .. v4 .. "" .. v1 .. "ß" .. v4 .. " ",
	" sch" .. v4 .. "" .. v1 .. "ss" .. v4 .. " ",
}

local i
local crs_wrds = {}

-- All vowels asterisk'd
for i = 1, #curse_words do

	crs_wrds[i] = curse_words[i]
	crs_wrds[i] = crs_wrds[i]:gsub(v1, "*")
	crs_wrds[i] = crs_wrds[i]:gsub(v2, "*")
	crs_wrds[i] = crs_wrds[i]:gsub(v3, "*")
	crs_wrds[i] = crs_wrds[i]:gsub(v4, "*")
	crs_wrds[i] = crs_wrds[i]:gsub(v5, "*")

end

local crse_words = {}
local j

local switch = {
	[v1] = true,
	[v2] = true,
	[v3] = true,
	[v4] = true,
	[v5] = true,
}

-- First vowel asterisk'd
for i = 1, #curse_words do

	crse_words[i] = curse_words[i]
	for j = 1, #crse_words[i] do
		if switch[crse_words[i]:sub(j, j)] then
			local new_str = ""
			new_str = crse_words[i]:sub(1, j - 1)
			new_str = new_str .. "*"
			new_str = new_str .. crse_words[i]:sub(j + 1)
			crse_words[i] = new_str
			break
		end
	end
end

-- Add asterisk'd words to list
for i = 1, #curse_words do
	curse_words[#curse_words + 1] = crs_wrds[i]
	curse_words[#curse_words + 1] = crse_words[i]
end

-- Returns true if a curse word is found
function chat_anticurse.is_curse_found(name, message)

	local is_curse_found = false
	local i

	message = string.lower(name.." "..message .." ")

	for i = 1, #curse_words do
		if string.find(message, curse_words[i],
					   1, true) ~= nil then

			is_curse_found = true
			break
		end
	end

	if is_curse_found then
		minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
		minetest.chat_send_all("Player <"..name.."> warned for cursing" )
		minetest.log("action", "Player "..name.." warned for cursing. Chat:"..message)
	end

	return is_curse_found
end

minetest.register_on_chat_message(function(name, message)
	return chat_anticurse.is_curse_found(name, message)
end)

if minetest.chatcommands["me"] then

	local old_command = minetest.chatcommands["me"].func

	minetest.chatcommands["me"].func = function(name, param)

		if chat_anticurse.is_curse_found(name, param) then
			return nil
		end

		return old_command(name, param)
	end
end

if minetest.chatcommands["msg"] then

	local old_command = minetest.chatcommands["msg"].func

	minetest.chatcommands["msg"].func = function(name, param)

		if chat_anticurse.is_curse_found(name, param) then
			return nil
		end

		return old_command(name, param)
	end
end
