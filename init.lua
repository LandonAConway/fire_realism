fire_realism = {}

function fire_realism.soil_nodes()
  local nodes = {}
  for k,v in pairs(minetest.registered_nodes) do
    if minetest.get_item_group(k,"soil") > 0 or minetest.get_item_group(k,"sand") > 0 then
      table.insert(nodes,k)
    end
  end
  return nodes
end

function fire_realism.split_string (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  
  local t = {}
  if string.find(inputstr, sep) then
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
  else
    table.insert(t, inputstr)
  end
  
  return t
end

dofile(minetest.get_modpath("fire_realism") .. "/charcoal.lua")
dofile(minetest.get_modpath("fire_realism") .. "/nodes.lua")
dofile(minetest.get_modpath("fire_realism") .. "/fire_extinguisher.lua")
dofile(minetest.get_modpath("fire_realism") .. "/abms.lua")