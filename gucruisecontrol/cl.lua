local cruisSpeed = 0
local cruiseEngaged = false
RegisterKeyMapping('cruisePlus', 'Cruise Control +/Res', 'keyboard', "HOME")
RegisterCommand("cruisePlus", function(src, args)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		cruisePlus()
	else
		cruisSpeed = 0
	end
end)
RegisterKeyMapping('cruiseMinus', 'Cruise Control -/Set', 'keyboard', "END")
RegisterCommand("cruiseMinus", function(src, args)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		cruiseMinus()
	else
		cruisSpeed = 0
	end
end)

RegisterKeyMapping('cruiseCancel', 'Cruise Control Cancel', 'keyboard', "DELETE")
RegisterCommand("cruiseCancel", function(src, args)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		cruiseCancel()
	else
		cruisSpeed = 0
	end
end)
function cruiseCancel()
	cruiseEngaged = false
end
function cruisePlus()
	if not cruiseEngaged then
		cruiseEngaged = true
		if cruisSpeed == 0 then
			cruisSpeed = GetEntitySpeed(GetPlayerPed(-1))
		end
	else
		cruisSpeed = cruisSpeed + 0.44704
	end
end
function cruiseMinus()
	if not cruiseEngaged then
		cruiseEngaged = true
		cruisSpeed = GetEntitySpeed(GetPlayerPed(-1))
	else
		if GetEntitySpeed(GetPlayerPed(-1)) > cruisSpeed then
			cruisSpeed = GetEntitySpeed(GetPlayerPed(-1))
		else
			cruisSpeed = cruisSpeed - 0.44704
		end
	end
end
Citizen.CreateThread(function()
while true do
	Citizen.Wait(100)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		if cruiseEngaged then
			if IsControlPressed(0, 72, true) then
				cruiseEngaged = false
			else
				if GetEntitySpeed(GetPlayerPed(-1)) < cruisSpeed then
					getUpToSpeed()
				end
			end
		end
	else
		cruisSpeed = 0
		cruiseEngaged = false
	end
end
end)
function getUpToSpeed()
	while GetEntitySpeed(GetPlayerPed(-1)) < cruisSpeed and cruiseEngaged do
		Citizen.Wait(0)
		SetControlNormal(0, 71, margin())
		if IsControlPressed(0, 72, true) then
			cruiseEngaged = false
		end
	end
end
function margin()
	local a = 0.0
	local dif = cruisSpeed - GetEntitySpeed(GetPlayerPed(-1))
	if dif >= 2.68224 then
		a = 1.0
		return a
	end
	if dif >= 2.2352 then
		a = 0.7
		return a
	end
	if dif >= 1.34112 then
		a = 0.5
		return a
	end
	if dif >= 0 then
		a = 0.3
		return a
	end
end