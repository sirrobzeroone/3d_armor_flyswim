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
local d_fall_anim = 0                                        -- Stop fall animation from playing after pressing shift_dwn 
                                                             -- and flying otherwise looks funny flicking to falling.

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
		duck_std =  {x=380, y=380},
        duck =      {x=381, y=399},
		climb =     {x=410, y=429},   
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
		local ladder_n = minetest.get_node(pos)
		local ladder_n_b = minetest.get_node({x=pos.x,y=pos.y -1,z=pos.z})	
		local offset = 0                                                 -- Used for Headanim
		local is_slab = crouch_wa(player,pos)                            -- Function specifically for Crouch-walk work around
		local cur_anim = player_api.get_animation(player)
		local pmeta = player:get_meta()
		
		-- reset player collisionbox, eye height, speed override 
		player:set_properties({collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}})
		player:set_properties({eye_height = 1.47})
			
		if pmeta:get_int("flyswim_suss") == 1 then
		   player:set_physics_override({speed = pmeta:get_float("flyswim_orgor")})
           pmeta:set_int("flyswim_suss", 0)		   
		end

		local vel = player:get_player_velocity()		
	    local play_s = (math.sqrt(math.pow(math.abs(vel.x),2) + 
		                math.pow(math.abs(vel.y),2) + 
						math.pow(math.abs(vel.z),2) ))*3.6               -- basically 3D Pythagorean Theorem km/h

		-- Catch to stop flicking to falling when   -- 
		-- flying down and then letting go of shift --
		if controls.sneak then
			d_fall_anim = 7                                              -- each "1" == 0.05sec delay, 7 delay covers about 200Kph
	    end

		-- Sets terminal velocity to about 100Kkm/hr beyond   --
        -- this speed chunk load issues become more noticable --
		
		if vel.y < -27  and controls.sneak ~= true then			
			local tv_offset_y = -1*((-1*(vel.y+1)) + vel.y)               --(-1*(vel.y+1)) - catch those holding shift and over acceleratering when falling so dynamic end point so we dont bounce back up
			                                                              -- Remove above replace with 27 and then acclerate down (hold shift) for 5-6 secs then let go you'll "bounce" back up :)			
				player:add_player_velocity({x=0, y=tv_offset_y, z=0})	
		end

        ---------------------------------------------------------
		--            Start of Animation Cases                 --
        ---------------------------------------------------------
-----------------------------
--stop standing under slabs--
-----------------------------				
		local ch = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z})
		local ch_g = minetest.registered_nodes[ch.name].groups
		local ch_slab = 0
		for k,v in pairs(ch_g) do
			if k == "slab" then                                
				ch_slab = 1                                     
			end
		end	

		if ch_slab == 1 and
		   node_fsable(pos,2,"a") ~= true and
		   controls.sneak ~= true and
		   (controls.up == true or                                 
     		controls.down == true or                          
			controls.left == true or 
			controls.right == true) then
				player_api.set_animation(player, "duck",ani_spd/2)
				player:set_properties({collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.45, 0.3}})
				player:set_properties({eye_height = 1.27})
				
				local play_or_2 =player:get_physics_override()
				pmeta:set_int("flyswim_suss", 1)
				pmeta:set_float("flyswim_orgor", play_or_2.speed)
                player:set_physics_override({speed = play_or_2.speed*0.2})
				
		elseif ch_slab == 1 and
		   node_fsable(pos,2,"a") ~= true and
		   controls.sneak ~= true and
		   (controls.up ~= true or                                 
     		controls.down ~= true or                          
			controls.left ~= true or 
			controls.right ~= true) then
				player_api.set_animation(player, "duck_std",ani_spd)
				player:set_properties({collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.45, 0.3}})
				player:set_properties({eye_height = 1.27})   
			
-----------------------------
--      Climb Cases        --
-----------------------------
		elseif minetest.registered_nodes[ladder_n.name].climbable and     -- Player standing in node that is climable and	
		(controls.jump or controls.sneak) then                            -- Moving up or Moving down
		
			if controls.sneak and                                         -- Climbing down but at bottom of the climable node
			   minetest.registered_nodes[ladder_n_b.name].climbable ~= true then			   
			   -- #nothing
			else
			 player_api.set_animation(player, "climb",ani_spd)           -- Do climbing animation
			 --player:set_animation({x=410, y=429},30,0,true)            -- experimenting removing player_api dependancy
			end


-----------------------------
--       Swim Cases        --
-----------------------------	
		elseif (controls.up or controls.down or 
		   controls.left or controls.right) and                          -- Must be moving in a direction
		   (controls.LMB or controls.RMB) and                            -- Must be swinging
			node_down_fsable(pos,2,"s") == true then                     -- Node player standing in and 1 below must be swimmable
			player_api.set_animation(player,"swim_atk",ani_spd)			 -- Set to swimming attack animation
			offset = 90                                                  -- Offset for Headanim
			
		elseif (controls.up or controls.down or 
		    controls.left or controls.right) and                         -- Must be moving in a direction
			node_down_fsable(pos,2,"s") == true then                     -- Node player standing in and 1 below must be swimmable
				player_api.set_animation(player, "swim",ani_spd) 		 -- Set to swimming animation
				offset = 90                                              -- Offset for Headanim

			
		elseif
			controls.sneak == true and
			node_down_fsable(pos,1,"s") == true then                     -- Node player standing in swimmable
				player_api.set_animation(player, "swim",ani_spd) 		 -- Set to swimming animation
				player:set_properties({collisionbox = {-0.4, 0, -0.4, 0.4, 0.5, 0.4}})
				player:set_properties({eye_height = 0.7}) 
				offset = 90                                              -- Offset for Headanim

-----------------------------
--      Sneak Cases        --
-----------------------------
    ----------------------------------------------------------
    -- Crouch-walk workaround Start			                             -- This is to workaround the strange crouch-walk behaviour, 
																		 -- can only walk halfway under 1st slab then stops,
																		 -- This workaround allows walking through 1st strangly blocked slab
		elseif controls.sneak == true and                                -- Must be sneaking
			controls.up == true and                                      -- Must be moving forwards
			node_fsable(pos,2,"a") ~= true and                           -- No air node below feet
			play_s <= 1 and is_slab == 1 then                            -- Speed < 1 kph and node infront and up 1 must be slab see functions                      

				player_api.set_animation(player, "duck",ani_spd/2)       -- Set to duck/crouch animation	
				player:set_properties({collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.0, 0.3}}) -- Workaround set collision box to 1 high
				player:set_properties({eye_height = 1.27})               -- eye hieght dropped a bit
    -- Crouch-walk workaround end
    ----------------------------------------------------------
	
		elseif controls.sneak == true and                                -- Must be sneaking
			node_fsable(pos,2,"a") ~= true and                           -- No air node below feet		
			(controls.up == true or                                      -- Moving in a direction otherwise we are standing
     		 controls.down == true or                          
			 controls.left == true or 
			 controls.right == true) then                       
	
				player_api.set_animation(player, "duck",ani_spd/2)	
				player:set_properties({collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.45, 0.3}})
				player:set_properties({eye_height = 1.27})

		elseif controls.sneak == true and                                -- Must be sneaking
			node_fsable(pos,2,"a") ~= true and	                         -- No air node below feet	
			(controls.up ~= true or                                      -- Not moving in any direction
     		 controls.down ~= true or                          
			 controls.left ~= true or 
			 controls.right ~= true) then                       
	
				player_api.set_animation(player, "duck_std",ani_spd)
				player:set_properties({collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.45, 0.3}})
				player:set_properties({eye_height = 1.27})	


-----------------------------
--      Flying Cases       --
-----------------------------						
		elseif not attached_to and privs.fly == true then                -- If player attached to something dont do flying animation 
			if(controls.up or controls.down or                           -- must also have fly privs or we should definitly be falling.
			  controls.left or controls.right) and                       -- Must be moving in a direction
			  (controls.LMB or controls.RMB) and                         -- Must be swinging
		      node_down_fsable(pos,3,"a") == true and                    -- Node player is standing in must be flyable and 2 down
			  (vel.y >= 0 or controls.sneak == true) then
				player_api.set_animation(player, "fly_atk",ani_spd)		 -- Show fly attack animation
			  	offset = 90                                              -- Offset for Headanim
						
			elseif(controls.up or controls.down or 
			  controls.left or controls.right) and                       -- Must be moving in a direction
		      node_down_fsable(pos,3,"a") == true and                    -- Node player is standing in must be flyable and 2 down
			  (vel.y >= 0 or controls.sneak == true) then
				player_api.set_animation(player, "fly",ani_spd)			 -- Show fly animation or swan dive if falling
			  	offset = 90                                              -- Offset for Headanim
				
			elseif (controls.up or controls.down or 
			  controls.left or controls.right) and                       -- Must be moving in a direction
			  controls.sneak ~= true and                                 -- catch case to stop fall animation from playing
			  d_fall_anim > 0 and                                        -- when player has been flying down
		      node_down_fsable(pos,3,"a") == true then                   -- Node player is standing in must be flyable and 2 down
				player_api.set_animation(player, "fly",ani_spd)	         -- Show fly down animation (add fly down animation)
				d_fall_anim = d_fall_anim - 1
			  	offset = 90                                              -- Offset for Headanim
			
			elseif controls.sneak ~= true and                            -- catch case to stop fall animation from playing
			  d_fall_anim > 0 and                                        -- when player has been flying down
		      node_down_fsable(pos,3,"a") == true then                   -- Node player is standing in must be flyable and 2 down
				player_api.set_animation(player, "stand",ani_spd)	     -- Show fly down animation (add fly down animation)
				d_fall_anim = d_fall_anim - 1
			  	offset = 90                                              -- Offset for Headanim
				
			elseif controls.sneak ~= true and                            -- not pressing down and
			  vel.y < 0 and                                              -- We have velocity downwards (negative y blocks)
			  (controls.LMB or controls.RMB) and                         -- Must be swinging			  
		      node_down_fsable(pos,3,"a") == true then                   -- Node player is standing in must be flyable and 2 down
				player_api.set_animation(player, "fall_atk",ani_spd)	 -- Show falling
			  	offset = 90                                              -- Offset for Headanim
			
			elseif controls.sneak ~= true and                            -- not pressing down and
			  vel.y < 0 and                                              -- We have velocity downwards (negative y blocks) 
		      node_down_fsable(pos,3,"a") == true then                   -- Node player is standing in must be flyable and 2 down
				player_api.set_animation(player, "fall",ani_spd)	     -- Show falling
				
			  	offset = 90                                              -- Offset for Headanim
			end	
			
-----------------------------
--      Falling Cases      --
-----------------------------			
		elseif not attached_to and 
		    controls.sneak ~= true then                                  -- If player attached to something dont do falling animation		
			if(controls.LMB or controls.RMB) and                         -- Must be swinging
		      vel.y < -0.5 and                                           -- We have velocity downwards (negative y blocks) need 0.5 as slight engine in-accuracy when standing on cliff edge? 
			  node_down_fsable(pos,5,"a") == true then                   -- Node player is standing in and 4 below must be flyable/fallable
				player_api.set_animation(player, "fall_atk",ani_spd)	 -- falling and flailing around
			  	offset = 90                                              -- Offset for Headanim
						
			elseif vel.y < -0.5 and                                      -- We have velocity downwards (negative y blocks) need 0.5 as slight engine in-accuracy when standing on cliff edge? 
			  node_down_fsable(pos,5,"a") == true then                   -- Node player is standing in and 4 below must be flyable/fallable
				player_api.set_animation(player, "fall",ani_spd)		 -- falling
			  	offset = 90                                              -- Offset for Headanim			
			end
		end
        ---------------------------------------------------------
		--            End of Animation Cases                   --
        ---------------------------------------------------------


        ---------------------------------------------------------
		--              Post MT 5.3 Head Animation             --
        ---------------------------------------------------------		
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
		--minetest.chat_send_all(play_s.." km/h")	-- for diagnosing chunk emerge issues when falling currently unsolved
		
	end	
end)


