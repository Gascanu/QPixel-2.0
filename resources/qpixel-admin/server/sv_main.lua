function isAdministrator(src)
    local user = vRP.getUserId(src)
	local rank = vRP.isUserAdministrator(user)
	if rank then
        return true, rank
	end

    return false, rank
end

exports("isAdministrator", isAdministrator)

function giveLicense(src, license)
    local user = vRP.getUserId(src)
    if not user then return false end

    local update = Await(SQL.execute("UPDATE user_licenses SET status = @status WHERE cid = @cid AND type = @type", {
        ["@status"] = 1,
        ["@cid"] = user,
        ["@type"] = license
    }))

    if not update then return false end

    return true
end

exports("giveLicense", giveLicense)


function updateGarage(src, license_plate, garage)
    local update = Await(SQL.execute("UPDATE characters_cars SET current_garage = @current_garage WHERE license_plate = @license_plate", {
        ["@current_garage"] = garage,
        ["@license_plate"] = license_plate
    }))

    if not update then return false end

    return true
end

exports("updateGarage", updateGarage)

function sendLog(link, color, title, description, footer)
    local connect = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = description,
	        ["footer"] = {
                ["text"] = footer,
            },
        }
    }
    PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({username = "DesireRP",  avatar_url = "https://cdn.discordapp.com/attachments/991122949828530258/992926357413711872/unknown.png",embeds = connect}), { ['Content-Type'] = 'application/json' })
end

exports("sendLog", sendLog)

RegisterNetEvent("qpixel:admin:searchPlayerInventory")
AddEventHandler("qpixel:admin:searchPlayerInventory", function(pTarget)
    local user = vRP.getUserId(tonumber(pTarget))
    -- local cid = user:getCurrentCharacter().id
    TriggerClientEvent("server-inventory-open", source, "1", 'ply-'..user)
end)

RegisterServerEvent('qpixel-admin:insertPrio')
AddEventHandler('qpixel-admin:insertPrio', function()
    local src = source
    local sid = GetPlayerIdentifiers(src)[1]

    exports.oxmysql:execute("INSERT INTO player_prio (steam_id, prioType) VALUES (@steam_id, @prioType)",
    {
        ['@steam_id'] = sid,
        ['@prioType'] = '0',
    })
end)