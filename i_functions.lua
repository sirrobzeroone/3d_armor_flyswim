------------------------------------------------------------------
-- ___________                   __  .__                        --
-- \_   _____/_ __  ____   _____/  |_|__| ____   ____   ______  --
--  |    __)|  |  \/    \_/ ___\   __\  |/  _ \ /    \ /  ___/  --
--  |     \ |  |  /   |  \  \___|  | |  (  <_> )   |  \\___ \   --
--  \___  / |____/|___|  /\___  >__| |__|\____/|___|  /____  >  --
--      \/             \/     \/                    \/     \/   --
------------------------------------------------------------------

armor_sf={}
----------------------------
-- add swimmable block    --
----------------------------
armor_sf.add_swimmable = function(name)
	table.insert(swimmable, name)
end

----------------------------
--   add flyable block    --
----------------------------
armor_sf.add_flyable = function(name)
	table.insert(flyable, name)
end

----------------------------
-- Check node fly/swim    --
----------------------------
function node_fsable(n_name,type)
	local compare = flyable	
		if type == "s" then
			compare = swimmable
		end
		
		for k,v in ipairs(compare) do 
			if n_name == v then
				return true
			end
		end
	return false
end






