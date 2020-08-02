minetest.register_abm({
  nodenames = {"fire:basic_flame", "fire:permanent_flame"},
  --neighbors = {"air"},
  interval = 2,
  chance = 4,
  action = function(pos)
    local _, err = pcall(fire_realism.create_ash,pos)
  end
})

minetest.register_abm({
  nodenames = {"group:hot_ash"},
  interval = 120,
  chance = 2,
  action = function(pos)
    local node = minetest.registered_nodes[minetest.get_node(pos).name]
    local ash_type = fire_realism.split_string(node.ash_type,":")[2]
    minetest.swap_node(pos,{name="fire_realism:ash_and_"..ash_type})
  end
})

minetest.register_abm({
  nodenames = {"group:cooled_ash"},
  interval = 720,
  chance = 1,
  action = function(pos)
    local _, err = pcall(fire_realism.generate_deco,pos)
  end
})

function fire_realism.create_ash(pos)
  local min = {x=pos.x+2,y=pos.y+1,z=pos.z+2}
  local max = {x=pos.x-2,y=pos.y-20,z=pos.z-2}
  local top_nodes = minetest.find_nodes_in_area_under_air(min,max,{"group:soil","group:sand"})
  for _, pos_ in ipairs(top_nodes) do
    local node = minetest.get_node(pos_)
    if math.random(1,2) == 1 then
      if minetest.get_item_group(node.name,"ash") < 1 then
        local newnode = "fire_realism:hot_ash_and_"..fire_realism.split_string(node.name,":")[2]
        minetest.swap_node(pos_,{name=newnode})
      end
    end
  end
end

function fire_realism.get_top_nodes(p1,p2)
  local t = {}
  local positions = fire_realism.get_area(p1,p2)
  for _,p in ipairs(positions) do
    local above = {x=p.x,y=p.x+1,z=p.z}
    local n_above = minetest.get_node(above).name
    if n_above == "air" then
      table.insert(t,p)
    end
  end
  return t
end

function fire_realism.get_area(first_pos, last_pos, list)
  if list == nil then list = {} end
  
  local current_pos = vector.new(first_pos.x,first_pos.y,first_pos.z)
  
  local x_amount = first_pos.x - last_pos.x +1
  local y_amount = first_pos.y - last_pos.y +1
  local z_amount = first_pos.z - last_pos.z +1
  
  for i = 1, z_amount do
    current_pos.y = first_pos.y
    for i = 1, y_amount do
      current_pos.x = first_pos.x
      for i = 1, x_amount do
        table.insert(list, vector.new(current_pos.x, current_pos.y, current_pos.z))
        current_pos.x = current_pos.x - 1
      end
      current_pos.y = current_pos.y - 1
    end
    current_pos.z = current_pos.z - 1
  end
  
  return list
end

function fire_realism.generate_deco(pos)
  --convert node
  local node = minetest.registered_nodes[minetest.get_node(pos).name]
  local newnode = node.ash_type
  minetest.swap_node(pos,{name=newnode})
  
  --generate missing decorations. This must be done first otherwise it won't look right.
  local p1 = {x=pos.x+2,y=pos.y+2,z=pos.z+2}
  local p2 = {x=pos.x-2,y=pos.y-2,z=pos.z-2}
  
  local top_nodes_rainforest = minetest.find_nodes_in_area_under_air(p1,p2,{"default:dirt_with_rainforest_litter"})
  for _, _pos in ipairs(top_nodes_rainforest) do
    if math.random(1,(5*1*5)) == 1 then
      default.grow_new_jungle_tree(_pos)
    end
  end
  
  --generate decoration
  local vm = minetest.get_voxel_manip()
  local emin, emax = vm:read_from_map(p1,p2)
  minetest.generate_decorations(vm,p1,p2)
  vm:write_to_map()
  
  --remove hot ash
  local hot_ash_nodes = minetest.find_nodes_in_area(vector.new(p1.x+1,p1.y+1,p1.z+1),vector.new(p2.x-1,p2.y-1,p2.z-1),{"group:hot_ash"})
  for _, _pos in ipairs(hot_ash_nodes) do
    local hot_ash_node = minetest.registered_nodes[minetest.get_node(pos).name]
    minetest.swap_node(_pos,{name="fire_realism:ash_and_"..fire_realism.split_string(hot_ash_node.ash_type,":")[2]})
  end
end