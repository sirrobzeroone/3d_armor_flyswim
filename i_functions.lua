------------------------------------------------------------
--        ___ _        __       ___        _              --
--       | __| |_  _  / _|___  / __|_ __ _(_)_ __         --
--       | _|| | || | > _|_ _| \__ \ V  V / | '  \        --
--       |_| |_|\_, | \_____|  |___/\_/\_/|_|_|_|_|       --
--          |__/                                          --
--                   Crouch and Climb                     --
------------------------------------------------------------
--                      Functions                         --
------------------------------------------------------------

----------------------------------------
-- Get Player model and textures

function armor_fly_swim.get_player_model()

	-- player_api only  (simple_skins uses)
	local player_mod = "character_sf.b3d"
	local texture = {"character.png",
	                 "3d_armor_trans.png"}

	-- 3d_armor only nil capes (simple_skins uses)
	if armor_fly_swim.is_3d_armor and
	   not armor_fly_swim.add_capes and
	   not armor_fly_swim.is_skinsdb  then

		player_mod = "3d_armor_character_sf.b3d"
		texture = {armor.default_skin..".png",
			       "3d_armor_trans.png",
				   "3d_armor_trans.png"}
	end

	-- 3d_armor only with capes (simple_skins uses)
	if armor_fly_swim.is_3d_armor and
	   armor_fly_swim.add_capes and
	   not armor_fly_swim.is_skinsdb then

		player_mod = "3d_armor_character_sfc.b3d"
		texture = {armor.default_skin..".png",
		           "3d_armor_trans.png",
				   "3d_armor_trans.png"}
	end

	-- skins_db with 3d_armor or without (clothes_2 uses)
	if armor_fly_swim.is_skinsdb then
		player_mod = "skinsdb_3d_armor_character_5.b3d"
		texture = {"blank.png",
		           "blank.png",
				   "blank.png",
				   "blank.png"}
	end

	return player_mod,texture
end

----------------------------------------
-- Get WASD, pressed = true

function armor_fly_swim.get_wasd_state(controls)

	local rtn = false

	if controls.up == true or
       controls.down == true or
	   controls.left == true or
	   controls.right == true then

		rtn = true
	end

	return rtn
end

----------------------------------------
-- Node above solid

function armor_fly_swim.node_above_solid(pos)

	local node_check = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z})
	local rtn = false 
	
	if minetest.registered_nodes[node_check.name] then

		local nc_draw = minetest.registered_nodes[node_check.name].drawtype

		if nc_draw ~= "liquid" and
		   nc_draw ~= "flowingliquid" and
		   nc_draw ~= "airlike" and
		   nc_draw ~= "plantlike" then

			rtn = true
		end
	end
	
	return rtn
end

-----------------------------------------------
-- Get X number nodes down drawtype and return
-- Thanks Gundul
function armor_fly_swim.get_node_down_drawtype(pos,num)

local i = 0
local nodes = {}
local result ={}
	while (i < num ) do
		table.insert(nodes, minetest.get_node({x=pos.x,y=pos.y-i,z=pos.z}))
		i=i+1
	end

	local n_draw
	
	for k,node in pairs(nodes) do
		local n_draw
		
		if minetest.registered_nodes[node.name] then
			n_draw = minetest.registered_nodes[node.name].drawtype
		else
			n_draw = "normal"
		end
		table.insert(result, n_draw)
	end
	return result 
end


-----------------------------------------------
--  Check X number nodes down fly/swimmable

function armor_fly_swim.node_down_check(nodes,num,type)

local draw_ta = {"airlike", "plantlike"}
local draw_tl = {"liquid","flowingliquid"}
local compare = draw_ta
local result = {}
local i = 1

	if type == "s" then
		compare = draw_tl
	end
	
	while (i <= num) do
			local n_draw = nodes[i]

			for k2,v2 in ipairs(compare) do
				if n_draw == v2 then
				  	table.insert(result,"t")
				end
			end
		i = i+1
	end

	if #result == num then
		return true
	else
	    return false
	end
end


------------------------------------------
-- Workaround for slab edge crouch

function crouch_wa(player,pos)
	local is_slab = 0
	local pos_w = {}
	local angle = (player:get_look_horizontal())*180/math.pi      -- Convert Look direction to angles

		-- +Z North
		if angle <= 45 or angle >= 315 then
			pos_w={x=pos.x,y=pos.y+1,z=pos.z+1}

		-- -X West
		elseif angle > 45 and angle < 135 then
			pos_w={x=pos.x-1,y=pos.y+1,z=pos.z}

		-- -Z South
		elseif angle >= 135 and angle <= 225 then
			pos_w={x=pos.x,y=pos.y+1,z=pos.z-1}

		-- +X East
		elseif angle > 225 and angle < 315 then
			pos_w={x=pos.x+1,y=pos.y+1,z=pos.z}
		end

	local check = minetest.get_node(pos_w)

	if minetest.registered_nodes[check.name] then
		local check_g = minetest.get_item_group(check.name, "slab")

		if check_g ~= 0 then
			is_slab = 1
		end
	end

	-- return 1 or 0, need to update to bool
	return is_slab
end
