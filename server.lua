ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('svn-checkkeys')
AddEventHandler('svn-checkkeys', function(plate)
	local rejka = string.upper(plate)
	local daln = string.gsub(rejka, "%s+", "")
	local metaox = exports.ox_inventory:GetItem(source, 'carkey', daln, true)
	if metaox >= 1 then
		TriggerClientEvent('svn-carkeys:otworzamknij', source)
	else
		TriggerClientEvent('esx:showNotification', source, 'Nie masz kluczyków do tego auta')
	end
end)

RegisterNetEvent('svn-silnik')
AddEventHandler('svn-silnik', function(plate)
	local rejka = string.upper(plate)
	local daln = string.gsub(rejka, "%s+", "")
	local ped = source
	local metaox = exports.ox_inventory:GetItem(source, 'carkey', daln, true)
	if metaox >= 1 then
		TriggerClientEvent('svn-carkeys:silnik', ped)
	else
		Citizen.Wait(10)
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nie masz kluczyków do tego auta')
	end
end)

RegisterServerEvent('svn-addkeys')
AddEventHandler('svn-addkeys', function(plate)
	rejka = ESX.Math.Trim(plate)
	local daln = string.gsub(rejka, "%s+", "")
	exports.ox_inventory:AddItem(source, 'carKey', 1, daln)
end)

RegisterServerEvent('svn-removekeys')
AddEventHandler('svn-removekeys', function(plate)
	rejka = ESX.Math.Trim(plate)
	local daln = string.gsub(rejka, "%s+", "")
	exports.ox_inventory:RemoveItem(source, 'carKey', 1, daln)
end)

RegisterServerEvent('svn-addkeys2', function(plate)
	rejka = ESX.Math.Trim(plate)
	local daln = string.gsub(rejka, "%s+", "")
	exports.ox_inventory:AddItem(source, 'carKey', 1, daln)
end)
