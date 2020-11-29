                 _, __,    _, __, _, _  _, __,                    
                ~_) | \   / \ |_) |\/| / \ |_)                    
                 _) |_/   |~| | \ |  | \ / | \                    
                 ~  ~     ~ ~ ~ ~ ~  ~  ~  ~ ~                    
    __, _,  , _ _ _, _  _,    _, _  _ _ _, _ _, _ _ _, _  _,
    |_  |   \ | | |\ | / _   (_  |  | | |\/| |\/| | |\ | / _
    |   |_,  \| | | \| \ /   , ) |/\| | |  | |  | | | \| \ /
    ~   ~ ~   ) ~ ~  ~  ~     ~  ~  ~ ~ ~  ~ ~  ~ ~ ~  ~  ~ 
             ~'           
                                            
---------------------------
## Information
---------------------------
This is a small utility mod which adds some new animations to the default 3d_armor animations, the new animations are:

	|         | Start | End | FPS |
	|---------|-------|-----|-----|
	|Swim     |  246  | 279 |  30 |
	|Swim Atk |  285  | 318 |  30 |
	|Fly      |  325  | 334 |  30 |
	|Fly Atk  |  340  | 349 |  30 |
	|Fall     |  355  | 364 |  30 |
	|Fall Atk |  365  | 374 |  30 |
	
		
I have done my best to trigger the animations in the correct circumstances when viewing the player model in 3rd person. 

I have only tested this against minetest version 5.3 however it should work with any 5.X version assuming 3d_armor makes no radical changes,
without 3d_armor this mod does nothing.

Don't forget to delete "i_example_cape.lua" before using in a game, although I didn't create a reciepe for it so you would need creative/give access to get one.

![auroch render](https://github.com/sirrobzeroone/Animal_Models/blob/main/Auroch%20(Cow%20Ancestor)/Auroch_family_picture.png)

---------------------------
## Why are Capes Included?     
---------------------------
I found it best to keep capes included in this mod with the option to enable or disable. This is because capes needs the new b3d player model so they
are displayed as part of armor instead of part of the player. However as I didn't want to force anyone into using capes as armor items I created a second
optional player model which keeps capes with the player textures.

The above would create a circular dependancy if capes was it's own mod. Capes would  have a dependency on Fly/Swim but Fly/Swim needs to know if Capes mod 
is present so as to load the correct b3d player model.

Given the above I have kept capes inside this mod with an option to enable/disable it under Settings>>All Settings>>Mods>>3d_armor_flyswim by default capes are set to Enabled/true

Capes provide minimal additional armor, about half as much as wooden boots by default. 

---------------------------
## What nodes are set as Flyable/Swimmable?       
---------------------------
###Flyable
"air"
"default:cloud"

### Swimmable
"default:water_source"
"default:water_flowing"
"default:river_water_source"
"default:river_water_flowing"
"default:lava_source"
"default:lava_flowing"
			
Given the way the checks are done there is no need to remove these names if they don't exist in your game/world, simply make sure to add the
flyable and swimmable blocks for your game/world.

---------------------------
## How to add more Flyable/Swimmable Node Types?       
---------------------------
To add additional nodes that are swimmable or flyable either add there names directly to "i_nodes_fly_swim.lua"
or if I've written them correctly you should be able to use these directly in your mod:

### For flyable
armor_sf.add_flyable("modname:nodename")

eg armor_sf.add_flyable("gases:hydrogen")

### For Swimmable
armor_sf.add_swimmable("modname:nodename")

eg armor_sf.add_swimmable("color_water:green_water")