minetest.register_craftitem("fire_realism:charcoal_lump", {
  description = "Charcoal",
  inventory_image = "fire_realism_charcoal.png",
})

minetest.register_alias("charcoal","fire_realism:charcoal_lump")
minetest.register_alias("charcoal_lump","fire_realism:charcoal_lump")

minetest.register_craft({
  type = "fuel",
  recipe = "fire_realism:charcoal_lump",
  burntime = 40,
})

minetest.register_craft({
  type = "cooking",
  output = "fire_realism:charcoal_lump",
  recipe = "group:tree",
})