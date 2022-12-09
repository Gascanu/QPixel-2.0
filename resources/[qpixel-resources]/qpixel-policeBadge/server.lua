RegisterServerEvent("qpixel-policeBadge:showBadge")
AddEventHandler("qpixel-policeBadge:showBadge", function()
  -- local src = source
  local src = source
  local xPlayer = vRP.getUserId(src)
  -- local cid = user["PlayerData"]["id"] 

  local name = Player(src).state.char_info.nume .. " " .. Player(src).state.char_info.prenume
  local callsign = vRP.getMetaData(xPlayer)["callsign"]
  if vRP.isUserInFaction(xPlayer,"Politie") then
    TriggerClientEvent('mdrp-badge:badgeanim', src)
    vRPclient.getNearestPlayers(src, {7}, function(jucatori)
      for i = 1,#jucatori do
        TriggerClientEvent('mdrp-badge:open', jucatori[i], name, callsign)
      end
    end)
  else
    TriggerClientEvent("DoLongHudText", src, 'This is not your badge',1)
  end
end)
