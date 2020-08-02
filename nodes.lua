function fire_realism.generate_drops(drops, n)
  if type(drops) == "string" then
    drops = {items={{items={"fire_realism:charcoal_lump"}, rarity = 4},{items={drops}}}}
    return drops
  end
  
  if type(drops) == "nil" then
    drops = {items={{items={"fire_realism:charcoal_lump"}, rarity = 4},{items={n}}}}
    return drops
  end
  
  drops.max_items = drops.max_items or 1
  drops.items = drops.items or {}
  
  local charcoal = {items = {"fire_realism:charcoal_lump"}, rarity = 4}
  
  table.insert(drops.items,1,charcoal)
  
  return drops
end

for i,v in ipairs(fire_realism.soil_nodes()) do

  local node = minetest.registered_nodes[v]
  local node_names = fire_realism.split_string(v,":")
  local drops = fire_realism.generate_drops(node.drop,v)

  if minetest.get_item_group(v,"ash") < 1 then
    local underlay = "default_dirt.png"
    if type(node.tiles) == "string" then
      underlay = node.tiles
    elseif type(node.tiles) == "table" then
      underlay = node.tiles[2] or node.tiles[1]
    end
    
    minetest.register_node("fire_realism:ash_and_"..node_names[2], {
      description = "Ash and "..node.description,
      tiles = {"fire_realism_ash.png", underlay,
        {name = underlay.."^fire_realism_ash_side.png",
          tileable_vertical = false}},
      groups = {crumbly = 3, soil = 1, ash = 1, cooled_ash = 1},
      ash_type = v,
      drop = drops,
      sounds = default.node_sound_dirt_defaults()
    })
    
    minetest.register_node("fire_realism:hot_ash_and_"..node_names[2], {
      description = "Hot Ash and "..node.description,
      tiles = {"fire_realism_ash_hot.png", underlay,
        {name = underlay.."^fire_realism_ash_hot_side.png",
          tileable_vertical = false}},
      paramtype = "light",
      light_source = 4,
      groups = {crumbly = 3, soil = 1, ash = 1, hot_ash = 1, igniter = 1},
      ash_type = v,
      drop = drops,
      sounds = default.node_sound_dirt_defaults()
    })
  end

end