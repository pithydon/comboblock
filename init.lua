comboblock = {index = {
	["default:wood"] = "stairs:slab_wood",
	["default:junglewood"] = "stairs:slab_junglewood",
	["default:pine_wood"] = "stairs:slab_pine_wood",
	["default:acacia_wood"] = "stairs:slab_acacia_wood",
	["default:aspen_wood"] = "stairs:slab_aspen_wood",
	["default:stone"] = "stairs:slab_stone",
	["default:cobble"] = "stairs:slab_cobble",
	["default:stonebrick"] = "stairs:slab_stonebrick",
	["default:desert_stone"] = "stairs:slab_desert_stone",
	["default:desert_cobble"] = "stairs:slab_desert_cobble",
	["default:desert_stonebrick"] = "stairs:slab_desert_stonebrick",
	["default:sandstone"] = "stairs:slab_sandstone",
	["default:sandstonebrick"] = "stairs:slab_sandstonebrick",
	["default:obsidian"] = "stairs:slab_obsidian",
	["default:obsidianbrick"] = "stairs:slab_obsidianbrick",
	["default:brick"] = "stairs:slab_brick",
	["farming:straw"] = "stairs:slab_straw",
	["default:steelblock"] = "stairs:slab_steelblock",
	["default:copperblock"] = "stairs:slab_copperblock",
	["default:bronzeblock"] = "stairs:slab_bronzeblock",
	["default:goldblock"] = "stairs:slab_goldblock"
}}
local creative = minetest.setting_getbool("creative_mode")
for k,v1 in pairs(comboblock.index) do
	local v1_def = minetest.registered_nodes[v1]
	local v1_groups = table.copy(v1_def.groups)
	v1_groups.not_in_creative_inventory = 1
	local v1_tiles = table.copy(v1_def.tiles)
	if not v1_tiles[2] then
		v1_tiles[2] = v1_tiles[1]
	end
	if not v1_tiles[3] then
		v1_tiles[3] = v1_tiles[2]
	end
	if not v1_tiles[4] then
		v1_tiles[4] = v1_tiles[3]
	end
	if not v1_tiles[5] then
		v1_tiles[5] = v1_tiles[4]
	end
	if not v1_tiles[6] then
		v1_tiles[6] = v1_tiles[5]
	end
	for _,v2 in pairs(comboblock.index) do
		if v1 ~= v2 then
			local v2_def = minetest.registered_nodes[v2]
			local v2_tiles = table.copy(v2_def.tiles)
			if not v2_tiles[2] then
				v2_tiles[2] = v2_tiles[1]
			end
			if not v2_tiles[3] then
				v2_tiles[3] = v2_tiles[2]
			end
			if not v2_tiles[4] then
				v2_tiles[4] = v2_tiles[3]
			end
			if not v2_tiles[5] then
				v2_tiles[5] = v2_tiles[4]
			end
			if not v2_tiles[6] then
				v2_tiles[6] = v2_tiles[5]
			end
			minetest.register_node("comboblock:"..v1:split(":")[2].."_onc_"..v2:split(":")[2], {
				description = v1_def.description.." on "..v2_def.description,
				tiles = {v1_tiles[1], v2_tiles[2],
						v2_tiles[3].."^("..v1_tiles[3].."^comboblock_splitter.png^[makealpha:255,0,255)",
						v2_tiles[4].."^("..v1_tiles[4].."^comboblock_splitter.png^[makealpha:255,0,255)",
						v2_tiles[5].."^("..v1_tiles[5].."^comboblock_splitter.png^[makealpha:255,0,255)",
						v2_tiles[6].."^("..v1_tiles[6].."^comboblock_splitter.png^[makealpha:255,0,255)"},
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "normal",
				sounds = v1_def.sounds,
				groups = v1_groups,
				drop = v1,
				after_destruct = function(pos, oldnode)
					minetest.set_node(pos, {name = v2, param2 = oldnode.param2})
				end
			})
		end
	end
	minetest.override_item(v1, {
		on_place = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.under
			if pointed_thing.type ~= "node" or minetest.is_protected(pos, placer:get_player_name()) then
				return
			end
			local node = minetest.get_node(pos)
			if node.name == v1 then
				minetest.swap_node(pos, {name = k, param2 = 0})
				if not creative then
					itemstack:take_item()
					return itemstack
				end
			else
				for _,v in pairs(comboblock.index) do
					if node.name == v then
						minetest.swap_node(pos, {name = "comboblock:"..v1:split(":")[2].."_onc_"..v:split(":")[2], param2 = node.param2})
						if not creative then
							itemstack:take_item()
							return itemstack
						end
						return
					end
				end
				return minetest.item_place(itemstack, placer, pointed_thing, param2)
			end
		end,
	})
end
