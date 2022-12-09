RegisterServerEvent("qpixel-policeBadge:showBadge")
AddEventHandler("qpixel-policeBadge:showBadge", function()
  -- local src = source
  local src = source
  local xPlayer = vRP.getUserId(src)
  -- local cid = user["PlayerData"]["id"] 

  local name = Player(src).state.char_info.nume .. " " .. Player(src).state.char_info.prenume
  local callsign = vRP.getMetaData(xPlayer)["callsign"]
  if vRP.isUserInFaction(xPlayer,"Politie") then
    TriggerClientEvent('icemallow-badge:badgeanim', src)
    TriggerClientEvent('icemallow-badge:open', -1, name, callsign, src)
  else
    TriggerClientEvent("DoLongHudText", src, 'This is not your badge',1)
  end
end)
