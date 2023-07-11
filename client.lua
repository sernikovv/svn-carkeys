ESX = exports["es_extended"]:getSharedObject()
local playerPed = PlayerPedId()

-- Blokuj odpalanie silnika

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 then
            local engineRunning = GetIsVehicleEngineRunning(vehicle)

            if not engineRunning then
                SetVehicleEngineOn(vehicle, false, true, true)
            end
        end
    end
end)

--Otwieranie / zamykanie

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 303) and IsInputDisabled(0) then
			local kordy = GetEntityCoords(playerPed)

			if IsPedInAnyVehicle(playerPed, false) then
				furagracza = GetVehiclePedIsIn(playerPed, false)
			else
				furagracza = GetClosestVehicle(kordy, 8.0, 0, 71)
			end
			local plate = GetVehicleNumberPlateText(furagracza)
			TriggerServerEvent('svn-checkkeys', plate)
			Citizen.Wait(100)
		end
	end
end)

RegisterNetEvent('svn-carkeys:otworzamknij')
AddEventHandler('svn-carkeys:otworzamknij', function()
	local kordy = GetEntityCoords(playerPed)
	local czyzamkniete = GetVehicleDoorLockStatus(furagracza)

	if IsPedInAnyVehicle(playerPed, false) then
		furagracza = GetVehiclePedIsIn(playerPed, false)
	else
		furagracza = GetClosestVehicle(kordy, 8.0, 0, 71)
	end

	if not DoesEntityExist(furagracza) then
		return
	end
			if czyzamkniete <= 2 then
				SetVehicleDoorsLocked(furagracza, 4)
				SetVehicleDoorsLockedForAllPlayers(furagracza, 1)
				SetVehicleDoorShut(furagracza, 0, false)
				SetVehicleDoorShut(furagracza, 1, false)
				SetVehicleDoorShut(furagracza, 2, false)
				SetVehicleDoorShut(furagracza, 3, false)
				SetVehicleDoorShut(furagracza, 4, false)
				SetVehicleDoorShut(furagracza, 5, false)
				PlayVehicleDoorCloseSound(furagracza, 1)
				TaskPlayAnim(PlayerPedId(), "gestures@m@standing@casual", "gesture_you_soft", 3.0, 1.0, -1, 48, 0, 0, 0, 0)
				ESX.ShowNotification('Pojazd Zamknięty')
				StartVehicleHorn(furagracza, 100, 0, false)
			elseif czyzamkniete > 2 then
				SetVehicleDoorsLocked(furagracza, 1)
				SetVehicleDoorsLockedForAllPlayers(furagracza, false)
				PlayVehicleDoorOpenSound(furagracza, 0)
				TaskPlayAnim(PlayerPedId(), "gestures@m@standing@casual", "gesture_you_soft", 3.0, 1.0, -1, 48, 0, 0, 0, 0)
				ESX.ShowNotification('Pojazd Otwarty')
				StartVehicleHorn(furagracza, 100, 0, false)
			end
end)

-- Szukanie kluczy
local searchingKeys = false
local searchedVehicles = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if IsControlJustPressed(0, 74) and not searchingKeys and IsPedInAnyVehicle(playerPed, false) then
            local hasKeys = HasItem("carkeys")

            if not hasKeys then
				local vehicleHash = GetVehiclePedIsIn(playerPed, false)
				if vehicle ~= 0 then
					StartSearchingKeys()
				end
            end
        end
    end
end)

function StartSearchingKeys()
	local furagracza = GetVehiclePedIsIn(playerPed, false)
	local plate = GetVehicleNumberPlateText(furagracza)
	local vehicleHash = GetVehiclePedIsIn(playerPed, false)
    searchingKeys = true
		TriggerEvent("mythic_progbar:client:progress", {
			name = "unique_action_name",
			duration = 5000,
			label = "Szukanie...",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}})
			local odds = math.random(1, 100)

			Citizen.Wait(5000)

			if odds <= 20 then
				local randomNotify = math.random(1, 3)

				if randomNotify == 1 then
					ESX.ShowNotification('Znalazłeś klucze na siedzeniu')
					TriggerServerEvent('svn-addkeys2', plate)
				elseif randomNotify == 2 then
					ESX.ShowNotification('Znalazłeś klucze w schowku')
					TriggerServerEvent('svn-addkeys2', plate)
				else
					ESX.ShowNotification('Znalazłeś klucze na desce rozdzielczej')
					TriggerServerEvent('svn-addkeys2', plate)
				end
			else
				local randomnotify2 = math.random(1, 4)
				if randomnotify2 == 1 then
					ESX.ShowNotification('Nie znalazłeś kluczy')
				elseif randomnotify2 == 2 then
					ESX.ShowNotification('Znalazłeś kluczyk pod siedzeniem lecz jest on połamany')
				elseif randomnotify2 == 3 then
					ESX.ShowNotification('Znalazłeś kluczyk w schowku lecz jest on od innego auta')
				elseif randomnotify2 == 4 then
					ESX.ShowNotification('Nie znalazłeś kluczy, natomiast znalazłeś porwany bankot 100$')
				end
			end

			searchingKeys = false
end

function HasItem(itemName)
    local playerPed = PlayerPedId()
    local playerInventory = ESX.GetPlayerData().inventory

    for i = 1, #playerInventory, 1 do
        if playerInventory[i].name == itemName then
            return true
        end
    end

    return false
end


-- Silnik
local silnikKey = 246 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local furagracza = GetVehiclePedIsIn(playerPed, false)
		local silnikonczyoff
		
		if IsPedGettingIntoAVehicle(playerPed) then
			silnikonczyoff = (GetIsVehicleEngineRunning(furagracza)) 
			if not (silnikonczyoff) then
				SetVehicleEngineOn(furagracza, false, true, true) 
				DisableControlAction(2, 71, true)
			end
		end
		
		if IsPedInAnyVehicle(playerPed, false) and not IsEntityDead(playerPed) and (not GetIsVehicleEngineRunning(furagracza)) then
			DisableControlAction(2, 71, true) 
		end
		
		if (IsControlJustReleased(0, silnikKey) or IsDisabledControlJustReleased(0, silnikKey)) and furagracza ~= nil and furagracza ~= 0 and GetPedInVehicleSeat(furagracza, 0) then
			local plate = GetVehicleNumberPlateText(furagracza)
				TriggerServerEvent('svn-silnik', plate)
					if not (silnikonczyoff) then
						silnikonczyoff = true
						DisableControlAction(2, 71, false)
					else
						silnikonczyoff = false 
						DisableControlAction(2, 71, true)
					end
		end
		
		if IsPedInAnyVehicle(playerPed, false) and IsControlPressed(2, 75) and not IsEntityDead(playerPed) then
			if (GetIsVehicleEngineRunning(furagracza)) then
				Citizen.Wait(150)
				SetVehicleEngineOn(furagracza, true, true, false) 
				TaskLeaveVehicle(playerPed, furagracza, 0)
			else
				TaskLeaveVehicle(playerPed, furagracza, 0)
			end
		end
    end
end)

RegisterNetEvent('svn-carkeys:silnik')
AddEventHandler('svn-carkeys:silnik', function(ped)
	local furagracza = GetVehiclePedIsIn(playerPed, false)
    if furagracza ~= nil and furagracza ~= 0 and GetPedInVehicleSeat(furagracza, 0) then
        SetVehicleEngineOn(furagracza, (not GetIsVehicleEngineRunning(furagracza)), true, true)
		SetVehicleJetEngineOn(furagracza, true)
		ESX.ShowNotification('Przekręcono kluczyki pojazdu o Nr. Rej. ' ..GetVehicleNumberPlateText(furagracza))
	end
end)
