# RabbitAdventures
### Platformer game in Lua with LÖVE

#### Video Demo:  <URL HERE>
#### Description:
Map, number of obstacles, back images and their placement are randomly generated each time the game is launched (except for moving platform and chest area). Ground has 2 height levels. 
  
The main hero, rabbit, can throw carrots ('B' key) to collect veggies, contained in some obstacles (not every obstacle contains them). 
  
Player can choose level of difficulty that depends on the number of lives (from 1 to 5). Deadly objects are thorns and flying balls. When the rabbit loses one life it becomes invulnerable for a couple of seconds. 
  
The goal is to collect all veggies before reaching the moving platform, get to the other side using the platform, fight with the chest and survive of course! 
  
#### Screenshots:

![StarterScreen](Screenshots/StarterScreen.png)

![GameplayScreen](Screenshots/GameplayScreen.png)

![GameOverScreen](Screenshots/GameOverScreen.png)

![WinScreen](Screenshots/WinScreen.png)
  
#### Contents:
- main.lua - contains callback functions		
- conf.lua - some configuration options such as window size, title; some modules set unused to reduce memory usage
- platform.lua - animation of moving platform, checking if the rabbit on it and pushing him forward	
- map_creator.lua - functions randomly generating map, filling it with obstacles and back images
- objects_animation.lua	- calculations of different animations: carrot, veggies, flying balls, thorns, moving system of coordinates; checking if colliding with an obstacle; calculating current ground level under the rabbit
- win_or_gameover.lua - checking if game is over and printing lose/win info
- objects_creator.lua - creation of objects: obstacles, back images, veggies (based on the random number passed)
- credits.txt - art, music/sounds credits
