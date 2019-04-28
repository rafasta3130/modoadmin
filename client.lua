local showPlayerBlips = false
local ignorePlayerNameDistance = true
local playerNamesDist = 15
local displayIDHeight = 1.5 --Height of ID above players head(starts at center body mass)
--Set Default Values for Colors
local red = 255
local green = 255
local blue = 255
local group
local IsAdminMod = false
local godmode = false
local teleporte = false

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	print('group setted ' .. g)
	group = g
end)	

RegisterNetEvent('entraradmin')
AddEventHandler('entraradmin', function(id, name)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  ShowNotification("~b~O ~g~" .. name .. " ~b~Entrou em modo Admin!")
  ----TriggerEvent('chatMessage', "", {204, 204, 0}, "^*^2O STAFF ^1" .. name .. " ^2entrou em modo admin!")
  if pid == myId then
    IsAdminMod = true
	godmode = true
  end
end)

RegisterNetEvent('sairadmin')
AddEventHandler('sairadmin', function(id, name)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  ShowNotification("~r~O ~g~" .. name .. " ~r~Saiu de modo Admin!")
  ----TriggerEvent('chatMessage', "", {204, 204, 0}, "^*^2O STAFF ^1" .. name .. " ^2saiu do modo admin!")
  if pid == myId then
    IsAdminMod = false
	godmode = false
  end
end)

RegisterNetEvent('tpon')
AddEventHandler('tpon', function(id, name)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    teleporte = true
  end
end)

RegisterNetEvent('tpoff')
AddEventHandler('tpoff', function(id, name)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    teleporte = false
  end
end)

RegisterNetEvent('sendMessageAdmOn')
AddEventHandler('sendMessageAdmOn', function(id)
  local myId = PlayerId()
  local finalid = id
  local pid = GetPlayerFromServerId(id)
  if (pid == myId and group ~= 'user' and IsAdminMod == true) then
    TriggerServerEvent('adminson', finalid, 1)
  elseif (group ~= 'user' and pid ~= myId and IsAdminMod == true) then
    TriggerServerEvent('adminson', finalid, 1)
  elseif (group ~= 'user' and pid == myId and IsAdminMod == false) then
    TriggerServerEvent('adminson', finalid, 2)
  elseif (group ~= 'user' and pid ~= myId and IsAdminMod == false) then
    TriggerServerEvent('adminson', finalid, 2)
  end
end)

function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(1*scale, 2*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(red, green, blue, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end


Citizen.CreateThread(function ()
    while true do
        for i=0,99 do
            N_0x31698aa80e0223f8(i)
        end
        for id = 0, 31 do
            if GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then
                ped = GetPlayerPed( id )
                blip = GetBlipFromEntity( ped ) 
 
                x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

                if(ignorePlayerNameDistance) then
					if group ~= "user" and IsAdminMod == true then 
						red = 255
						green = 255
						blue = 255
						DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))
						local playerPed = GetPlayerPed(-1)
	                    local WaypointHandle = GetFirstBlipInfoId(8)						
	                    if DoesBlipExist(WaypointHandle) and teleporte == true then
		                    local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
		                    SetEntityCoords(playerPed, coord.x, coord.y, coord.z)
	                    end
					elseif group ~= "user" and IsAdminMod == false then 
				        DisableControlAction(0, 213, true)
					end
                end

                if ((distance < playerNamesDist)) then
                    if not (ignorePlayerNameDistance) then
						if group ~= "user" and IsAdminMod == true then 
							red = 255
							green = 255
							blue = 255
							DrawText3D(x2, y2, z2 + displayIDHeight, GetPlayerServerId(id))
							local playerPed = GetPlayerPed(-1)
	                        local WaypointHandle = GetFirstBlipInfoId(8)
	                        if DoesBlipExist(WaypointHandle) and teleporte == true then
		                        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
		                        SetEntityCoords(playerPed, coord.x, coord.y, coord.z)
	                        end
						elseif group ~= "user" and IsAdminMod == false then 
						    DisableControlAction(0, 213, true)
					    end					
                    end
                end  
            end
        end
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function() --Godmode
	while true do
		Citizen.Wait(1)
		if group ~= "user" and IsAdminMod == true and godmode == true then
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
		elseif group ~= "user" and IsAdminMod == false and godmode == false then
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
			SetEntityCanBeDamaged(GetPlayerPed(-1), true)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)
		if group ~= "user" and IsAdminMod == true then
    		x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    		roundx = tonumber(string.format("%.2f", x))
    		roundy = tonumber(string.format("%.2f", y))
    		roundz = tonumber(string.format("%.2f", z))
        	SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.50)
			SetTextDropshadow(1, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~r~X:~s~ "..roundx)
			DrawText(0.35, 0.90)
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.50)
			SetTextDropshadow(1, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~r~Y:~s~ "..roundy)
			DrawText(0.45, 0.90)
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.50)
			SetTextDropshadow(1, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~r~Z:~s~ "..roundz)
			DrawText(0.55, 0.90)
			heading = GetEntityHeading(GetPlayerPed(-1))
			roundh = tonumber(string.format("%.2f", heading))
        	SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.50)
			SetTextDropshadow(1, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~r~Virado para:~s~ "..roundh)
			DrawText(0.40, 0.96)
			speed = GetEntitySpeed(PlayerPedId())
			rounds = tonumber(string.format("%.2f", speed)) 
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)
			SetTextDropshadow(1, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~r~Velocidade: ~s~"..rounds)
			health = GetEntityHealth(PlayerPedId())
			DrawText(0.01, 0.62)
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.40)
			SetTextDropshadow(1, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			AddTextComponentString("~r~Vida: ~s~"..health)
			DrawText(0.01, 0.58)
			veheng = GetVehicleEngineHealth(GetVehiclePedIsUsing(PlayerPedId()))
			vehbody = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))
			if IsPedInAnyVehicle(PlayerPedId(), 1) then
			 	vehenground = tonumber(string.format("%.2f", veheng))
				vehbodround = tonumber(string.format("%.2f", vehbody))
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.40)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Vida do Motor: ~s~"..vehenground)
				DrawText(0.01, 0.50)
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.40)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Vida da carroçaria: ~s~"..vehbodround)
				DrawText(0.01, 0.54) --hehe
			end
	    end
	end
end)
