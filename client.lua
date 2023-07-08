ESX = exports["es_extended"]:getSharedObject()

local ped = PlayerPedId()

RegisterNetEvent('svn-carkeys:zamknijotworz', function()
    local coords = GetEntityCoords(PlayerPedId())
    --local vehicle = GetPlayersLastVehicle()
    local czyzamkniete = GetVehicleDoorLockStatus(vehicle)

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 71)
	end

    if not DoesEntityExist(vehicle) then
        return
    end

	if not DoesEntityExist(vehicle) then
		return
	end
			if czyzamkniete <= 2 then
				SetVehicleDoorsLocked(vehicle, 4)
				SetVehicleDoorsLockedForAllPlayers(vehicle, 1)
				SetVehicleDoorShut(vehicle, 0, false)
				SetVehicleDoorShut(vehicle, 1, false)
				SetVehicleDoorShut(vehicle, 2, false)
				SetVehicleDoorShut(vehicle, 3, false)
				SetVehicleDoorShut(vehicle, 4, false)
				SetVehicleDoorShut(vehicle, 5, false)
				PlayVehicleDoorCloseSound(vehicle, 1)
				TriggerEvent('esx:showNotification', 'Pojazd Zamknięty')
				StartVehicleHorn(vehicle, 100, 0, false)
			elseif czyzamkniete > 2 then
				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				PlayVehicleDoorOpenSound(vehicle, 0)
				TriggerEvent('esx:showNotification', 'Pojazd Otwarty')
				StartVehicleHorn(vehicle, 100, 0, false)
			end
end)

local silnikKey = 246 -- Y

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(1, silnikKey) then
            DisableControlAction(0, 32, true)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
            end
        end

    end
end)

RegisterCommand('kluczyki', function()
    TriggerEvent('svn-carkeys:zamknijotworz')
end)

RegisterKeyMapping('kluczyki', 'Zamknij / Otwórz pojazd', 'keyboard', 'U')