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

![auroch render](https://github.com/sirrobzeroone/3d_armor_flyswim/blob/main/swimming_animated.gif)

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

--------------------------------------------
## What nodes are set as Flyable/Swimmable?       
--------------------------------------------
Any node which has the drawtype set as "airlike", "liquid" and "flowingliquid" will automatically be flyable or swimmable.

Big thanks to Gundul for pointing out a better way to do this.

--------------------------------------------
## Headanimation is incorporated - 5.3+ only      
--------------------------------------------
I have incorporated "headanim" mod content by LoneWolfHT as it was easier to include and then customise for this mod than try to interface
with "headanim". Full credit to LoneWolfHT for the functionality. I did modify the functionality a little so visually when in 3rd person view 
Sams head will:

~ Regular animations when looking down Sams chin now rests on his chest (about a 60 degree angle).  
~ Regular animations when looking up Sam only bends head back to the same 60 degrees.   
~ Swimming and flying you can look down full 90 degrees, straight ahead 0 degrees, however head motion is restricted to 30 degrees back.  

Make sure you disable "headanim" if you have it installed, although I found no serious issues with both enabled the mods
could fight one another for control of head position.
