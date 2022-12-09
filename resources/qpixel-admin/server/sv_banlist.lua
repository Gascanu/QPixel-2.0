local BanList            = {}
local BanListLoad        = false
local joined = false

CreateThread(function()
	while true do
		Wait(1000)
		if BanListLoad == false then
			loadBanListMenu()
			if BanList ~= {} then
				print("Ban List Successfully Loaded.")
				BanListLoad = true
			else
				print("ERROR: Ban List did not load.")
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(10000)
		if BanListLoad == true then
			loadBanListMenu()
		end
	end
end)

function getPrioType(pSource)
	-- local pSrc = pSource
	-- local user = exports['qpixel-base']:getModule("Player"):GetUser(pSource)
	return "Prio Broke:) ~ loleris"
end

function getEverything()
	local everything = {}
	for k,v in pairs(vRP.getUsers()) do
		local char
		local xPlayer = vRP.getUserId(k)
		local cash
		-- local steamid 
		-- if user then 
		-- 	-- char = user:getCurrentCharacter() 
		-- 	-- cash = user:getCash()
		-- end
		local pt = getPrioType(tonumber(v))
		local fullname
		local lastname
		local firstname
		local cid
		local bank
		if char then
			cid = xPlayer
			bank = vRP.getBankMoney(xPlayer)
			cash = vRP.getMoney(xPlayer)
			fullname = Player(src).state.char_info.nume .. ' ' .. Player(src).state.char_info.prenume
			firstname = Player(src).state.char_info.nume
			lastname = Player(src).state.char_info.prenume
		end
		everything[#everything+1] = {
			["nume"]          = GetPlayerName(tonumber(v)),
            ["serverID"]      = k,
            ["queueType"]     = pt,
            ["user_id"]        = cid,
            ["Full Name"]      = fullname,
			["Nume"] = firstname,
			["Prenume"]   = lastname,
			["Cash"]      = "$" .. cash,
			["Bank"]      = "$" .. bank
		}
	end
	return everything
end

exports('getEverything',getEverything)

RegisterNetEvent("oneMoreTryAdminSv", function()
	TriggerClientEvent("oneMoreTryAdmin",source,BanList)
end)

function getBanList()
	return BanList
end

RPC.register("getBanList", function()
	return BanList
end)

exports('getBanList',getBanList)

function loadBanListMenu()
	exports.oxmysql:execute('SELECT * FROM bans', {}, function(data)
		BanList = {}
			

		for i=1, #data, 1 do
			local exp2
			if data[i].expire == 0 then
				exp2 = "Permanent"
			else
				exp2 = os.date('%m-%d-%Y', data[i].expire)
			end

			print(data[i].ip)
			BanList[#BanList+1] = {
				banid     = data[i].banid,
				steamid = data[i].steam,
				name = data[i].name,
				license = data[i].license,
				license2 = tonumber(data[i].license2),
				xbox = data[i].xbox,
				live = data[i].live,
				cfx = data[i].cfx,
				discord = data[i].discord,
				ip = data[i].ip,
				token = data[i].token,
				reason    = data[i].reason,
				bannedby  = data[i].bannedby,
				expire    = data[i].expire,
				bannedon  = data[i].bannedon,
				bannedon2 = os.date('%m-%d-%Y', data[i].bannedon),
				expire2   = exp2,
			}
		end
	end)
end

exports('getIdentifier', getIdentifier)
exports('getUserToken', getUserToken)

function deleteBan(user_id,license) 
	exports.oxmysql:execute('DELETE FROM bans WHERE license=@license',{['@license']  = license}, function ()
			loadBanListMenu()
	end)
end

exports('deletebanned',deleteBan)