------------------------------------------------------------------
-- ___________                   __  .__                        --
-- \_   _____/_ __  ____   _____/  |_|__| ____   ____   ______  --
--  |    __)|  |  \/    \_/ ___\   __\  |/  _ \ /    \ /  ___/  --
--  |     \ |  |  /   |  \  \___|  | |  (  <_> )   |  \\___ \   --
--  \___  / |____/|___|  /\___  >__| |__|\____/|___|  /____  >  --
--      \/             \/     \/                    \/     \/   --
------------------------------------------------------------------

----------------------------------------
-- Check node fly/swim by drawtype    --
--          Thanks Gundul             -- 
----------------------------------------
function node_fsable(n_draw,type)
	
	local draw_ta = {"airlike"}
	local draw_tl = {"liquid","flowingliquid"}
	local compare = draw_ta
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




