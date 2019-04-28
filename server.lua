

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end
 
  TriggerEvent('es:addCommand', 'sairadmin', function(source, user)
  	local grupos = getIdentity(source)
	local nome = getIdentity(source)
    if grupos.group == 'admin' or grupos.group == 'superadmin' then
	    TriggerClientEvent("sairadmin", -1, source, nome.name)
	end	
  end)
  
  TriggerEvent('es:addCommand', 'entraradmin', function(source, user)
  	local grupos = getIdentity(source)
	local nome = getIdentity(source)
    if grupos.group == 'admin' or grupos.group == 'superadmin' then
	    TriggerClientEvent("entraradmin", -1, source, nome.name)
	end	
  end)
  
  TriggerEvent('es:addCommand', 'tpon', function(source, user)
  	local grupos = getIdentity(source)
	local nome = getIdentity(source)
    if grupos.group == 'admin' or grupos.group == 'superadmin' then
	    TriggerClientEvent("tpon", -1, source, nome.name)
		TriggerClientEvent('chatMessage', source, "^3 TP'S Ativados!")
	end	
  end)
  
  TriggerEvent('es:addCommand', 'tpoff', function(source, user)
  	local grupos = getIdentity(source)
	local nome = getIdentity(source)
    if grupos.group == 'admin' or grupos.group == 'superadmin' then
	    TriggerClientEvent("tpoff", -1, source, nome.name)
		TriggerClientEvent('chatMessage', source, "^3 TP'S Desativados!")
	end	
  end)
  
  TriggerEvent('es:addCommand', 'admin', function(source, args, user)
    TriggerClientEvent('chatMessage', source,"^1 Administradores Online:")
    TriggerClientEvent("sendMessageAdmOn", -1, source)
  end, {help = 'Mostra os Administradores Online!'})

  
RegisterServerEvent('adminson')
AddEventHandler('adminson', function(id1, modo)
  local nome = getIdentity(source)
  local grupos = getIdentity(source)
  if grupos.group == 'admin' or grupos.group == 'superadmin' then
    if modo == 1 then
      TriggerClientEvent('chatMessage', id1, "^2 STAFF | ^1" .. nome.name .. " ^0[^2MODO ADMIN^0]")
    elseif modo == 2 then
      TriggerClientEvent('chatMessage', id1, "^2 STAFF | ^1" .. nome.name .. " ^0[^2MODO NORMAL^0]")
	end
  end
end)