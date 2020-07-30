minetest.register_craftitem("fire_realism:fire_extinguisher", {
  description = "Fire Extinguisher",
  inventory_image = "fire_realism_fire_extinguisher.png",
  
  on_use = function(itemstack,user,pointed_thing)
    local pos = pointed_thing.above
    if pos ~= nil then
      local radius = 3
      local minp = {x=pos.x+radius,y=pos.y+radius,z=pos.z+radius}
      local maxp = {x=pos.x-radius,y=pos.y-radius,z=pos.z-radius}
      local hot_ash = minetest.find_nodes_in_area(minp,maxp,{"group:hot_ash"})
      local fire = minetest.find_nodes_in_area(minp,maxp,{"fire:basic_flame","fire:permanent_flame"})
      
      for _, _pos in ipairs(hot_ash) do
        local node = minetest.registered_nodes[minetest.get_node(_pos).name]
        local ash_type = fire_realism.split_string(node.ash_type,":")[2]
        minetest.swap_node(_pos,{name="fire_realism:ash_and_"..ash_type})
      end
      
      for _, _pos in ipairs(fire) do
        minetest.swap_node(_pos,{name="air"})
      end
    end
  end
})

minetest.register_craft({
  type = "shaped",
  output = "fire_realism:fire_extinguisher",
  recipe = {
    {"dye:red", "default:steel_ingot", "dye:red"},
    {"default:steel_ingot", "bucket:bucket_water", "default:steel_ingot"},
    {"dye:red", "default:steel_ingot", "dye:red"}
  }
})