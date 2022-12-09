local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- RegisterCommand('ghostttttt', function ()
-- 	TriggerServerEvent('qpixel-policeBadge:showBadge')
-- end)

RegisterNetEvent('mdrp-badge:badgeanim')
AddEventHandler('mdrp-badge:badgeanim', function(prop_name)
	prop_name = prop_name or 'prop_fib_badge'
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
		local boneIndex = GetPedBoneIndex(playerPed, 28422)
		AttachEntityToEntity(prop, playerPed, boneIndex, 0.065, 0.029, -0.035, 80.0, -1.90, 75.0, true, true, false, true, 1, true)
		RequestAnimDict('paper_1_rcm_alt1-9')
		TaskPlayAnim(playerPed, 'paper_1_rcm_alt1-9', 'player_one_dual-9', 8.0, -8, 10.0, 49, 0, 0, 0, 0)
		Citizen.Wait(3000)
		ClearPedSecondaryTask(playerPed)
		DeleteObject(prop)
	end)
end)

GetPedShot = function()
	if pedHeadshot then
		UnregisterPedheadshot(pedHeadshot)
	end
	pedHeadshot = Citizen.InvokeNative(0xBA8805A1108A2515, PlayerPedId())
	-- if GetEntityModel(GetPlayerPed(-1)) == femaleHash and not data.target then sex = 4 end
	-- if not IsPedMale(PlayerPedId()) and not data.target then sex = 4 end
	-- if data.target then
	-- 	UnregisterPedheadshot(pedHeadshot)
	-- 	local player = GetPlayerFromServerId(data.target)
	-- 	pedHeadshot = Citizen.InvokeNative(0xBA8805A1108A2515, GetPlayerPed(player))
	-- 	-- if GetEntityModel(GetPlayerPed(player)) == femaleHash then sex = 4 end
	-- 	if not IsPedMale(GetPlayerPed(player)) then sex = 4 end
	-- end
	while not IsPedheadshotReady(pedHeadshot) or not IsPedheadshotValid(pedHeadshot) do Citizen.Wait(100) end
	local headshot = GetPedheadshotTxdString(pedHeadshot)
	return headshot
end

RegisterNetEvent('mdrp-badge:open')
AddEventHandler('mdrp-badge:open', function(name, callsign)
	-- local person_src = pid
	-- local pid = GetPlayerFromServerId(person_src)
	-- local targetPed = GetPlayerPed(pid)
	-- local myCoords = GetEntityCoords(PlayerPedId())
	-- local targetCoords = GetEntityCoords(targetPed)
	-- if pid ~= -1 then
		-- if GetDistanceBetweenCoords(myCoords, targetCoords, true) <= Config.Distance then
			SendNUIMessage({ action = "open", name = name, img = GetPedShot(), callsign = callsign})
			Citizen.Wait(2500)
			SendNUIMessage({ action = "close"})
		-- end
	-- end
end)



