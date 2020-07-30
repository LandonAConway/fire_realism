for i,v in ipairs(fire_realism.soil_nodes()) do

  local node = minetest.registered_nodes[v]
  local node_names = fire_realism.split_string(v,":")

  if minetest.get_item_group(v,"ash") < 1 then
    local underlay = "default_dirt.png"
    if minetest.get_item_group(v,"sand") then
      if type(node.tiles) == "string" then
        underlay = node.tiles
      elseif type(node.tiles) == "table" then
        underlay = node.tiles[1]
      end
    end
    
    minetest.register_node("fire_realism:ash_and_"..node_names[2], {
      description = "Ash and "..node.description,
      tiles = {"fire_realism_ash.png", underlay,
        {name = underlay.."^fire_realism_ash_side.png",
          tileable_vertical = false}},
      groups = {crumbly = 3, soil = 1, ash = 1, cooled_ash = 1},
      ash_type = v,
      drop = {
        items = { { items = {'default:dirt'} } }
      },
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
      drop = {
        items = { { items = {'default:dirt'} } }
      },
      sounds = default.node_sound_dirt_defaults()
    })
  end

end