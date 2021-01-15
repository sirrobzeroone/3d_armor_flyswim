-------------------------------------------
-- Example Cape                          --
-------------------------------------------
	armor:register_armor("3d_armor_flyswim:mod_cape", {
		description = "Moderators Cape",
		inventory_image = "3d_armor_flyswim_mod_cape_inv.png",
		groups = {armor_capes=1, physics_speed=1, armor_use=1000},
		armor_groups = {fleshy=5},
		damage_groups = {cracky=3, snappy=3, choppy=2, crumbly=2, level=1},
		on_equip = function(player)
					local privs = minetest.get_player_privs(player:get_player_name())				
					privs.fly = true
					minetest.set_player_privs(player:get_player_name(), privs)
				  end,
				  
		on_unequip = function(player)
					local privs = minetest.get_player_privs(player:get_player_name())
					privs.fly = nil
					minetest.set_player_privs(player:get_player_name(), privs)
				  end,
	})

	armor:register_armor("3d_armor_flyswim:cape", {
		description = "Just a Cape",
		inventory_image = "3d_armor_flyswim_cape_inv.png",
		groups = {armor_capes=1, physics_speed=1, armor_use=2000},
		armor_groups = {fleshy=5},
		damage_groups = {cracky=3, snappy=3, choppy=2, crumbly=2, level=1},
		on_equip = function(player)
                    minetest.register_globalstep(function(dtime)
			                    local name = player:get_player_name()
				                    local pos = player:getpos()
				                    if minetest.get_node(vector.new(pos.x, pos.y-2, pos.z)).name == "air" then
					                    player:set_physics_override({
						                    gravity = 0.02,
						                    jump = 0,
                                            speed = 3,
                                        })
                                    else
                                        player:set_physics_override({
						                    gravity = 1,
						                    jump = 1,
                                            speed = 1,
					                    })
				                    end
                    end)
		end,
				  
		on_unequip = function(player)
                    minetest.register_globalstep(function(dtime)
                        player:set_physics_override({
                            gravity = 1,
                            jump = 1,
                            speed = 1,
                        })                    
                    end)

		end,
	})

        minetest.register_craft({
	        output = "3d_armor_flyswim:cape",
	        recipe = {{"default:diamond","wool:cyan","default:diamond"},
			      {"default:diamond","wool:white","default:diamond"},
			      {"default:diamond","wool:cyan","default:diamond"}}
        })
