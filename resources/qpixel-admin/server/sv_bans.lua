
function GetBanTime(Expires)
    local Time = os.time()
    local Expiring = nil
    local ExpD = nil
    if Expires == '1hr' then
        Expiring = os.date("*t", Time + 3600)
        ExpD = tonumber(Time + 3600)
    elseif Expires == '6hrs' then
        Expiring = os.date("*t", Time + 21600)
        ExpD = tonumber(Time + 21600)
    elseif Expires == '12hrs' then
        Expiring = os.date("*t", Time + 43200)
        ExpD = tonumber(Time + 43200)
    elseif Expires == '1day' then
        Expiring = os.date("*t", Time + 86400)
        ExpD = tonumber(Time + 86400)
    elseif Expires == '3days' then
        Expiring = os.date("*t", Time + 259200)
        ExpD = tonumber(Time + 259200)
    elseif Expires == '1week' then
        Expiring = os.date("*t", Time + 604800)
        ExpD = tonumber(Time + 604800)
    elseif Expires == 'perm' then
        Expiring = os.date("*t", Time + 315360000) -- 10 Years
        ExpD = tonumber(Time + 315360000)
    end
    return Expiring, ExpD
end

-- function GetIds(src)
--     local ids = {}

--     for k,v in pairs(GetPlayerIdentifiers(src)) do
--         if string.sub(v, 1, string.len("steam:")) == "steam:" then
--             ids["hex"] = v
--         elseif string.sub(v, 1, string.len("license:")) == "license:" then
--             ids["license"] = v
--         elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
--             ids["xbl"] = v
--         elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
--             ids["ip"] = v
--         elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
--             ids["discord"] = v
--         elseif string.sub(v, 1, string.len("live:")) == "live:" then
--             ids["live"] = v
--         end
--     end

--     if not ids["ip"] then
--         ids["ip"] = GetPlayerEndpoint(src)
--     end

--     if not ids["steamid"] and ids["hex"] then
--         ids["steamid"] = HexIdToSteamId(ids["hex"])
--     end

--     return ids
-- end

-- function HexIdToSteamId(hexid)
--     local cid = HexIdToComId(hexid)
--     local steam64 = math.floor(tonumber(string.sub( cid, 2)))
--     local a = steam64 % 2 == 0 and 0 or 1
--     local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
--     local sid = "STEAM0:"..a..":"..(a == 1 and b -1 or b)
--     return sid
-- end

-- function HexIdToComId(hexid)
--     return math.floor(tonumber(string.sub(hexid, 7), 16))
-- end

-- function IsSteamId(id)
--     id = tostring(id)
--     if not id then return false end
--     if string.match(id, "^STEAM[01]:[01]:%d+$") then return true else return false end
-- end

function stringsplit(string, split)
    local t = {}
    local i = 0
    local f = string.find(string, split, 1, true)
    while f do
        i = i + 1
        t[i] = string.sub(string, 1, f-1)
        string = string.sub(string, f+1)
        f = string.find(string, split, 1, true)
    end
    i = i + 1
    t[i] = string
    return t
end

function getIdentifier(src, identifier)
    local ids = GetPlayerIdentifiers(src)
    for k, v in ipairs(ids) do
        for _, id in ipairs(stringsplit(v, ":")) do
            if id == identifier then
                return v
            end
        end
    end
    return false
end

function getUserToken(src)
    local tokens = {}
    for i = 0, GetNumPlayerTokens(src) do
        tokens[#tokens+1] =  GetPlayerToken(src, i)
    end
    Wait(100)
    if (#tokens > 0) then
        return tokens
    else
        return nil
    end
end

function generateUniqueBanId()
    math.randomseed(GetGameTimer())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end


function isVerifiedAdmin(src)
    local user = vRP.getUserId(src)
	local rank = vRP.isUserAdministrator(user)
    if rank then 
        return true 
    end 
    return false
end

function getevAdminifiers(pPlayer, pType)
    local Retval = nil
    local steamid  = ""
    local discord  = ""
    local ip       = ""
    for e,k in pairs(GetPlayerIdentifiers(pPlayer))do
        if string.sub(k, 1, string.len("steam:")) == "steam:" then
            steamid = k
        elseif string.sub(k, 1, string.len("ip:")) == "ip:" then
            ip = k
        elseif string.sub(k, 1, string.len("discord:")) == "discord:" then
            discord = k
        end
        if pType == "discord" then
            Retval = discord
        elseif pType == "ip" then
            Retval = ip
        elseif pType == "steam" then
            Retval = steamid
        end 
      end
    return Retval
end

local count = 0
RegisterNetEvent("qpixel:admin/server/ban-player", function(ServerId, Expires, Reason)
     -- Check if source exist

    -- 1 day = 86400
    local staff = source
    local banId = generateUniqueBanId()
    local banLength = Expires
    local pBanDate = os.time()
    local bannedBy = "AntiCheat"
    local pUnbanDate = nil
    local pReason = Reason
    local pSteamId = getIdentifier(ServerId, "steam")
    local pLicense = getIdentifier(ServerId, "license")
    local pLicense2 = vRP.getUserId(ServerId)
    local pXbox = getIdentifier(ServerId, "xbox")
    local pLive = getIdentifier(ServerId, "live")
    local pDiscord = getIdentifier(ServerId, "discord")
    local pCFX = getIdentifier(ServerId, "fivem")
    local pIp = getIdentifier(ServerId, "ip")
    local pTokens = getUserToken(ServerId)
    local pTokenData = json.encode(pTokens)
    if banLength == 0 then
        pUnbanDate = 0
    else
        pUnbanDate = math.floor(os.time() + (banLength * 86400))
    end

    -- print(banId, pSteamId, GetPlayerName(ServerId), pLicense, pLicense2, pXbox, pLive, pDiscord, pCFX, pIp, pTokenData, bannedBy, pBanDate,pUnbanDate, pReason)

    exports.oxmysql:query("INSERT INTO bans (banid, steam, name, license, license2, xbox, live, discord, cfx, ip, token, bannedby, bannedon, expire, reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", {banId, pSteamId, GetPlayerName(ServerId), pLicense, pLicense2, pXbox, pLive, pDiscord, pCFX, pIp, pTokenData, bannedBy, pBanDate,pUnbanDate, pReason})
    Wait(500)

    local unbanDate
    if (pUnbanDate == 0) then
        unbanDate = "Permanent"
    else
        unbanDate = os.date('%Y-%m-%d', pUnbanDate)
    end
    DropPlayer(ServerId,
        "You are banned, you may appeal it at https://discord.gg/desireroleplay | Ban ID: " .. banId .. " | Reason: " .. pReason ..
            " | Unban Date: " .. unbanDate)
end)

local count = 0

RegisterNetEvent("qpixel:admin:unBan", function(pBanID)
    print(pBanID)
    local src = source
    if not isVerifiedAdmin(src) then return end

    local BanData = exports.oxmysql:querySync('SELECT ! FROM bans WHERE banid = ?', {pBanID})
    if BanData and BanData[1] ~= nil then
        exports.oxmysql:query('DELETE FROM bans WHERE banid = ?', {pBanID})
        TriggerClientEvent('DoLongHudText', src, "You successfully unbanned the player.", 1)
        loadBanListMenu()
    else
        TriggerClientEvent('DoLongHudText', src, "Something went wrong.. This person is not banned.", 2)
    end
end)