--------------------------------------------------------------------------------------
--            ________      .___    _____                                           --
--            \_____  \   __| _/   /  _  \_______  _____   ___________              --
--              _(__  <  / __ |   /  /_\  \_  __ \/     \ /  _ \_  __ \             --
--             /       \/ /_/ |  /    |    \  | \/  Y Y  (  <_> )  | \/             -- 
--            /______  /\____ |  \____|__  /__|  |__|_|  /\____/|__|                --
--                   \/      \/          \/            \/                           --
--  ___________.__                             .___   _________       .__           --
--  \_   _____/|  | ___.__. _____    ____    __| _/  /   _____/_  _  _|__| _____    --
--   |    __)  |  |<   |  | \__  \  /    \  / __ |   \_____  \\ \/ \/ /  |/     \   --
--   |     \   |  |_\___  |  / __ \|   |  \/ /_/ |   /        \\     /|  |  Y Y  \  --
--   \___  /   |____/ ____| (____  /___|  /\____ |  /_______  / \/\_/ |__|__|_|  /  --
--       \/         \/           \/     \/      \/          \/                 \/   --
--                                                                                  --
--                       Also makes Capes a 3d Armor, armor item                    --
--------------------------------------------------------------------------------------
--                                 by Sirrobzeroone                                 --
--                              Licence code LGPL v2.1                              --
--                                Cape Textures - CC0                               --
--                     Blender Model/B3Ds as per base MTG - CC BY-SA 3.0            --
--                       except "3d_armor_trans.png" CC-BY-SA 3.0                   --
--------------------------------------------------------------------------------------

----------------------------
--        Settings        --
----------------------------
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local add_capes = minetest.setting_getbool("capes_add_to_3darmor")   

if add_capes == nil then                                     -- To cover mod.conf/settings update issue
	add_capes = true
end

-------------------------------------
-- Adding new armor item for Capes --
-------------------------------------
if add_capes == true then
	if minetest.global_exists("armor") and armor.elements then
		table.insert(armor.elements, "capes")
		local mult = armor.config.level_multiplier or 1
		armor.config.level_multiplier = mult * 0.2
	end
end

----------------------------
--   Initiate files       --
----------------------------
dofile(modpath .. "/i_functions.lua")                        -- Functions

if add_capes == true then
	dofile(modpath .. "/i_example_cape.lua")                 -- Example Cape
end
-------------------------------------
--     Set Player model to use     --
-------------------------------------
local player_mod = "3d_armor_character_sfc.b3d"              -- Swim, Fly and Capes

if add_capes ~= true then
	player_mod = "3d_armor_character_sf.b3d"                 -- Swim Fly

end

--------------------------------------
-- Player model with Swim/Fly/Capes --
--------------------------------------

default.player_register_model(player_mod, {
	animation_speed = 30,
	textures = {
		armor.default_skin..".png",
		"3d_armor_trans.png",
		"3d_armor_trans.png",
	},	
	animations = {
		stand =		{x=0, y=79},
		lay =		{x=162, y=166},
		walk =		{x=168, y=187},
		mine =		{x=189, y=198},
		walk_mine = {x=200, y=219},
		sit = 		{x=81, y=160},
		swim =		{x=246,y=279}, 
		swim_atk =  {x=285, y=318},
		fly =		{x=325, y=334},
		fly_atk =   {x=340, y=349},
		fall =      {x=355, y=364},
		fall_atk =  {x=365, y=374},		
	},
})

----------------------------------------
-- Setting model on join and clearing --
--          local_animations          --  
----------------------------------------
minetest.register_on_joinplayer(function(player)
	player_api.set_model(player,player_mod)	
	player_api.player_attached[player:get_player_name()] = false
	player:set_local_animation({},{},{},{},30)
	
end)

------------------------------------------------
--  Global step to check if we player meets   --
-- Conditions for Swimming or Flying(falling) --
------------------------------------------------
minetest.register_globalstep(function()
	for _, player in pairs(minetest.get_connected_players()) do
		local controls = player:get_player_control()                     -- Get button presses
		local ani_spd = 30                                               -- Default animation speed
		local name = player:get_player_name()
		local attached_to = player:get_attach()                          -- If the players attached to something we need to know
		local privs = minetest.get_player_privs(player:get_player_name())-- Privs crude attempt to differentiate potenital flying from falling
		local pos = player:get_pos()
		local node = minetest.get_node(pos)                              -- Node player is in (lower legs)
		      node = minetest.registered_nodes[node.name].drawtype       -- Set node to node drawtype
		local node_b = minetest.get_node({x=pos.x,y=pos.y -1,z=pos.z})   -- Node below players feet
			  node_b = minetest.registered_nodes[node_b.name].drawtype   -- Set node to node drawtype
		local node_bb = minetest.get_node({x=pos.x,y=pos.y -2,z=pos.z})  -- Next node down
			  node_bb = minetest.registered_nodes[node_bb.name].drawtype -- Set node to node drawtype
		local node_bbb = minetest.get_node({x=pos.x,y=pos.y -3,z=pos.z}) -- Next node down (falling starts later)
			  node_bbb = minetest.registered_nodes[node_bbb.name].drawtype-- Set node to node drawtype
		local node_bbbb = minetest.get_node({x=pos.x,y=pos.y -4,z=pos.z})-- Next node down (falling starts later)
			  node_bbbb = minetest.registered_nodes[node_bbbb.name].drawtype-- Set node to node drawtype		
		local offset = 0                                                 -- Used for Headanim	

		if (controls.up or controls.down or 
		   controls.left or controls.right) and                          -- Must be moving in a direction
		   (controls.LMB or controls.RMB) and                            -- Must be swinging
		   node_fsable(node,"s") == true and                             -- Node player standing in must be swimmable
		   node_fsable(node_b,"s") == true then                          -- Node below must be swimmable
			player_api.set_animation(player,"swim_atk",ani_spd)			 -- Set to swimming attack animation
			offset = 90                                                  -- Offset for Headanim
			
		elseif (controls.up or controls.down or 
		    controls.left or controls.right) and                         -- Must be moving in a direction
		    node_fsable(node,"s") == true and                            -- Node player standing in must be swimmable
		    node_fsable(node_b,"s") == true then                         -- Node below must be swimmable
				player_api.set_animation(player, "swim",ani_spd) 		 -- Set to swimming animation
				offset = 90                                              -- Offset for Headanim
			
		elseif not attached_to and privs.fly == true then                -- If player attached to something dont do flying animation 		
			if(controls.up or controls.down or                           -- must also have fly privs or we should definitly be falling.
			  controls.left or controls.right) and                       -- Must be moving in a direction
			  (controls.LMB or controls.RMB) and                         -- Must be swinging
		      node_fsable(node,"a") == true and                          -- Node player is standing in must be flyable
			  node_fsable(node_b,"a") == true and                        -- node below must be flyable
			  node_fsable(node_bb,"a") == true  then                     -- node 2 down must be flyable
				player_api.set_animation(player, "fly_atk",ani_spd)		 -- Show fly attack animation
			  	offset = 90                                              -- Offset for Headanim
						
			elseif(controls.up or controls.down or 
			  controls.left or controls.right) and                       -- Must be moving in a direction
		      node_fsable(node,"a") == true and                          -- Node player is standing in must be flyable
			  node_fsable(node_b,"a") == true and                        -- node below must be flyable
			  node_fsable(node_bb,"a") == true  then                     -- node 2 down must be flyable
				player_api.set_animation(player, "fly",ani_spd)			 -- Show fly animation or swan dive if falling
			  	offset = 90                                              -- Offset for Headanim
			end	
			
		elseif not attached_to then                                      -- If player attached to something dont do falling animation		
			if(controls.LMB or controls.RMB) and                         -- Must be swinging
		      node_fsable(node,"a") == true and                          -- Node player is standing in must be flyable/fallable
			  node_fsable(node_b,"a") == true and                        -- node below must be flyable/fallable
			  node_fsable(node_bb,"a") == true  and                      -- node 2 down must be flyable/fallable
			  node_fsable(node_bbb,"a") == true and                      -- node 3 down must be flyable/fallable
			  node_fsable(node_bbbb,"a") == true  then                   -- node 4 down must be flyable/fallable
				player_api.set_animation(player, "fall_atk",ani_spd)	 -- falling and flailing around
			  	offset = 90                                              -- Offset for Headanim
						
			elseif node_fsable(node,"a") == true and                     -- Node player is standing in must be flyable/fallable
			  node_fsable(node_b,"a") == true and                        -- node below must be flyable/fallable
			  node_fsable(node_bb,"a") == true  and                      -- node 2 down must be flyable/fallable
			  node_fsable(node_bbb,"a") == true and                      -- node 3 down must be flyable/fallable
			  node_fsable(node_bbbb,"a") == true  then                   -- node 4 down must be flyable/fallable
				player_api.set_animation(player, "fall",ani_spd)		 -- falling
			  	offset = 90                                              -- Offset for Headanim
			end				
		end
		
		local check_v = minetest.is_creative_enabled                     -- this function was added in 5.3 which has the bone position change break animations fix - i think (MT #9807)
		                                                                 -- I'm not too sure how to directly test for the bone fix so I simply check for this function.

			if check_v ~= nil then                                       -- If creative_enabled function is nil we are pre-5.3
				local look_degree = -math.deg(player:get_look_vertical())-- Kept this near code				
				if look_degree > 29 and offset ~= 0 then
					offset = offset - (look_degree-30)

				elseif look_degree > 60 and offset == 0 then
					offset = offset - (look_degree-60)

				elseif look_degree < -60 and offset == 0 then
					offset = offset - (look_degree+60)			
				end
				
				-- Code by LoneWolfHT - Headanim mod MIT Licence --
				player:set_bone_position("Head", vector.new(0, 6.35, 0),vector.new(look_degree + offset, 0, 0))
				-- Code by LoneWolfHT - Headanim mod MIT Licence --	
			end
	end
end)


