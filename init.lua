-- Minetest 0.4.10+ mod: chat_anticurse
-- punish player for cursing by disconnecting them
--
--  This mod is Free and Open Source Software, released under the LGPL 2.1 or later.
-- 
-- See README.txt for more information.

chat_anticurse = {}
chat_anticurse.simplemask = {}
-- some english and some russian curse words
-- i don't want to keep these words as cleartext in code, so they are stored like this.
local x1="a"
local x2="i"
local x3="u"
local x4="e"
local x5="o"
local y1="y"
local y2="и"
local y3="о"
local y4="е"
local y5="я"

chat_anticurse.simplemask[1] = " "..x1.."s" .. "s "
chat_anticurse.simplemask[2] = " d" .. ""..x2.."ck"
chat_anticurse.simplemask[3] = " p"..x4.."n" .. "is"
chat_anticurse.simplemask[4] = " p" .. ""..x3.."ssy"
chat_anticurse.simplemask[5] = " h"..x5.."" .. "r".."ny "
chat_anticurse.simplemask[6] = " b"..x2.."" .. "tch "
chat_anticurse.simplemask[7] = " b"..x2.."" .. "tche"
chat_anticurse.simplemask[8] = " s"..x4.."" .. "x"
chat_anticurse.simplemask[9] = " "..y4.."б" .. "а"
chat_anticurse.simplemask[10] = " бл"..y5.."" .. " "
chat_anticurse.simplemask[11] = " ж" .. ""..y3.."п"
chat_anticurse.simplemask[12] = " х" .. ""..y1.."й"
chat_anticurse.simplemask[13] = " ч" .. "л"..y4.."н"
chat_anticurse.simplemask[14] = " п"..y2.."" .. "зд"
chat_anticurse.simplemask[15] = " в"..y3.."" .. "збуд"
chat_anticurse.simplemask[16] = " в"..y3.."з" .. "б"..y1.."ж"
chat_anticurse.simplemask[17] = " сп"..y4.."" .. "рм"
chat_anticurse.simplemask[18] = " бл"..y5.."" .. "д"
chat_anticurse.simplemask[19] = " бл"..y5.."" .. "ть"
chat_anticurse.simplemask[20] = " с" .. ""..y4.."кс"
chat_anticurse.simplemask[21] = " f" .. ""..x3.."ck"
chat_anticurse.simplemask[22] = ""..x1.."rs"..x4.."h"..x5.."l"..x4..""
chat_anticurse.simplemask[23] = " c"..x3.."nt "



chat_anticurse.check_message = function(name, message)
    local checkingmessage=string.lower( name.." "..message .." " )
	local uncensored = 0
    for i=1, #chat_anticurse.simplemask do
        if string.find(checkingmessage, chat_anticurse.simplemask[i], 1, true) ~=nil then
            uncensored = 2
            break
        end
    end
    
    --additional checks
    if 
        string.find(checkingmessage, " c"..x3.."" .. "m ", 1, true) ~=nil and 
        not (string.find(checkingmessage, " c"..x3.."" .. "m " .. "se", 1, true) ~=nil) and
        not (string.find(checkingmessage, " c"..x3.."" .. "m " .. "to", 1, true) ~=nil)
    then
        uncensored = 2
    end
    return uncensored
end

minetest.register_on_chat_message(function(name, message)
    local uncensored = chat_anticurse.check_message(name, message)

    if uncensored == 1 then
        minetest.kick_player(name, "Hey! Was there a bad word?")
        minetest.log("action", "Player "..name.." warned for cursing. Chat:"..message)
        return true
    end

    if uncensored == 2 then
        minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
        minetest.chat_send_all("Player <"..name.."> warned for cursing" )
        minetest.log("action", "Player "..name.." warned for cursing. Chat:"..message)
        return true
    end

end)

if minetest.chatcommands["me"] then
    local old_command = minetest.chatcommands["me"].func
    minetest.chatcommands["me"].func = function(name, param)
        local uncensored = chat_anticurse.check_message(name, param)

        if uncensored == 1 then
            minetest.kick_player(name, "Hey! Was there a bad word?")
            minetest.log("action", "Player "..name.." warned for cursing. Msg:"..param)
            return
        end

        if uncensored == 2 then
            minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
            minetest.chat_send_all("Player <"..name.."> warned for cursing" )
            minetest.log("action", "Player "..name.." warned for cursing. Me:"..param)
            return
        end
        
        return old_command(name, param)
    end
end

if minetest.chatcommands["msg"] then
    local old_command = minetest.chatcommands["msg"].func
    minetest.chatcommands["msg"].func = function(name, param)
        local uncensored = chat_anticurse.check_message(name, param)

        if uncensored == 1 then
            minetest.kick_player(name, "Hey! Was there a bad word?")
            minetest.log("action", "Player "..name.." warned for cursing. Msg:"..param)
            return
        end

        if uncensored == 2 then
            minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
            minetest.chat_send_all("Player <"..name.."> warned for cursing" )
            minetest.log("action", "Player "..name.." warned for cursing. Msg:"..param)
            return
        end
        
        return old_command(name, param)
    end
end
