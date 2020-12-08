------------------------------------------------------------------
-- ___________                   __  .__                        --
-- \_   _____/_ __  ____   _____/  |_|__| ____   ____   ______  --
--  |    __)|  |  \/    \_/ ___\   __\  |/  _ \ /    \ /  ___/  --
--  |     \ |  |  /   |  \  \___|  | |  (  <_> )   |  \\___ \   --
--  \___  / |____/|___|  /\___  >__| |__|\____/|___|  /____  >  --
--      \/             \/     \/                    \/     \/   --
------------------------------------------------------------------

----------------------------------------
-- Check specific node fly/swim       --
-- 1=player feet, 2=one below feet,   --
--          Thanks Gundul             -- 
----------------------------------------
function node_fsable(pos,num,type)
	
	local draw_ta = {"airlike"}
	local draw_tl = {"liquid","flowingliquid"}
	local compare = draw_ta
	local node = minetest.get_node({x=pos.x,y=pos.y-(num-1),z=pos.z})
	local n_draw = minetest.registered_nodes[node.name].drawtype
		
		if type == "s" then
			compare = draw_tl
		end
		
		for k,v in ipairs(compare) do		 
			if n_draw == v then
				return true
			end
		end
	return false
end

-----------------------------------------------
--  Check X number nodes down fly/Swimmable  --
-----------------------------------------------
function node_down_fsable(pos,num,type)

local draw_ta = {"airlike"}
local draw_tl = {"liquid","flowingliquid"}
local i = 0
local nodes = {}
local result ={}
local compare = draw_ta
	while (i < num ) do
		table.insert(nodes, minetest.get_node({x=pos.x,y=pos.y-i,z=pos.z}))
		i=i+1
	end

	if type == "s" then
		compare = draw_tl
	end	
		
	for k,v in pairs(nodes) do
		n_draw = minetest.registered_nodes[v.name].drawtype
			for k2,v2 in ipairs(compare) do 
				if n_draw == v2 then
				  	table.insert(result,"t")
				end
			end
	end	
	
	if #result == num then
		return true
	else
	    return false
	end
end

------------------------------------------
--  Workaround for odd crouch behaviour --
------------------------------------------
function crouch_wa(player,pos)
	local is_slab = 0                                             -- is_slab var holder 0=not_slab, 1=slab 
	local pos_w = {}                                              -- Empty table
	local angle = (player:get_look_horizontal())*180/math.pi      -- Convert Look direction to angles
	
		if angle <= 45 or angle >= 315 then                       -- +Z North
			pos_w={x=pos.x,y=pos.y+1,z=pos.z+1}
			
		elseif angle > 45 and angle < 135 then                    -- -X West
			pos_w={x=pos.x-1,y=pos.y+1,z=pos.z}
			
		elseif angle >= 135 and angle <= 225 then                 -- -Z South
			pos_w={x=pos.x,y=pos.y+1,z=pos.z-1}
			
		elseif angle > 225 and angle < 315 then                  -- +X East
			pos_w={x=pos.x+1,y=pos.y+1,z=pos.z}			
		end

	local check = minetest.get_node(pos_w)                       -- Get the node that is in front of the players look direction
	local check_g = minetest.registered_nodes[check.name].groups -- Get the groups assigned to node                                             
		for k,v in pairs(check_g) do
			if k == "slab" then                                  -- Any of the keys == slab then slab
				is_slab = 1                                      -- is_slab set to 1
			end
		end	
	
	return is_slab                                               -- return 1 or 0
		
end






