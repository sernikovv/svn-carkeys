ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('svn-carkeys', function(plate)
	local plateup = string.upper(plate)
	local metaox = string.gsub(plateup, "%s+", "")
	local ox = exports.ox_inventory:GetItem(source, 'carkey', metaox, true)
	if ox >= 1 then
		TriggerClientEvent('svn-carkeys:zamknijotworz', source)
	else
		TriggerClientEvent('esx:showNotification', source, 'Nie masz kluczyków do tego auta')
	end
end)

RegisterServerEvent('svn-addkeys')
AddEventHandler('svn-addkeys', function(plate)
	plateup = ESX.Math.Trim(plate)
	local metaox = string.gsub(plateup, "%s+", "")
	exports.ox_inventory:AddItem(source, 'carKey', 1, metaox)
end)

RegisterServerEvent('svn-removekeys')
AddEventHandler('svn-removekeys', function(plate)
	plateup = ESX.Math.Trim(plate)
	local metaox = string.gsub(plateup, "%s+", "")
	exports.ox_inventory:RemoveItem(source, 'carKey', 1, metaox)
end)