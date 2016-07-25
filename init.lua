local registered_combos = {}

local register_combo = function(name, node_def)
	local n_tiles = table.copy(node_def.tiles)

	if not n_tiles[2] then
		n_tiles[2] = n_tiles[1]
	end
	if not n_tiles[3] then
		n_tiles[3] = n_tiles[2]
	end
	if not n_tiles[4] then
		n_tiles[4] = n_tiles[3]
	end
	if not n_tiles[5] then
		n_tiles[5] = n_tiles[4]
	end
	if not n_tiles[6] then
		n_tiles[6] = n_tiles[5]
	end

	for _,v in ipairs(registered_combos) do
		if name ~= v then
			local v_def = minetest.registered_nodes[v]

			local v_tiles = table.copy(v_def.tiles)

			if not v_tiles[2] then
				v_tiles[2] = v_tiles[1]
			end
			if not v_tiles[3] then
				v_tiles[3] = v_tiles[2]
			end
			if not v_tiles[4] then
				v_tiles[4] = v_tiles[3]
			end
			if not v_tiles[5] then
				v_tiles[5] = v_tiles[4]
			end
			if not v_tiles[6] then
				v_tiles[6] = v_tiles[5]
			end

			minetest.register_node("comboblock:"..name:gsub(":", "_").."_onc_"..v:gsub(":", "_"), {
				description = node_def.description.." on "..v_def.description,
				tiles = {n_tiles[1], v_tiles[2],
						v_tiles[3].."^("..n_tiles[3].."^comboblock_splitter.png^[makealpha:255,0,255)",
						v_tiles[4].."^("..n_tiles[4].."^comboblock_splitter.png^[makealpha:255,0,255)",
						v_tiles[5].."^("..n_tiles[5].."^comboblock_splitter.png^[makealpha:255,0,255)",
						v_tiles[6].."^("..n_tiles[6].."^comboblock_splitter.png^[makealpha:255,0,255)"},
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "normal",
				sounds = node_def.sounds,
				groups = node_def.groups,
				drop = name,
				after_destruct = function(pos, oldnode)
					minetest.set_node(pos, {name = v, param2 = oldnode.param2})
				end
			})

			-- bug is here
			---[[
			minetest.register_node("comboblock:"..v:gsub(":", "_").."_onc_"..name:gsub(":", "_"), {
				description = v_def.description.." on "..node_def.description,
				tiles = {v_tiles[1], n_tiles[2],
						n_tiles[3].."^("..v_tiles[3].."^comboblock_splitter.png^[makealpha:255,0,255)",
						n_tiles[4].."^("..v_tiles[4].."^comboblock_splitter.png^[makealpha:255,0,255)",
						n_tiles[5].."^("..v_tiles[5].."^comboblock_splitter.png^[makealpha:255,0,255)",
						n_tiles[6].."^("..v_tiles[6].."^comboblock_splitter.png^[makealpha:255,0,255)"},
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "normal",
				sounds = v_def.sounds,
				groups = v_def.groups,
				drop = v,
				after_destruct = function(pos, oldnode)
					minetest.set_node(pos, {name = name, param2 = oldnode.param2})
				end
			})
			--]]
		end
	end

	table.insert(registered_combos, name)
end

for _,v in pairs(minetest.registered_nodes) do
	local n = v.name
	local n1 = n:split('_')[1]
	if n1 == "stairs:slab" and v.paramtype2 == "facedir" then
		register_combo(n, v)
	end
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

minetest.log("warning", "[comboblock] "..table.tostring(registered_combos))
