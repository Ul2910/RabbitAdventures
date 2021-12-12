# RabbitAdventures
### Platformer game in Lua with LÖVE

#### Video Demo:  <URL HERE>
#### Description:
Map, number of obstacles, back images and their placement are randomly generated each time the game is launched (except for moving platform and chest area). Ground has 2 height levels. 
  
The main hero, rabbit, can throw carrots ('B' key) to collect veggies, contained in some obstacles (not every obstacle contains them). 
  
Player can choose level of difficulty that depends on the number of lives (from 1 to 5). Deadly objects are thorns and flying balls. When the rabbit loses one life it becomes invulnerable for a couple of seconds. 
  
The goal is to collect all veggies before reaching the moving platform, get to the other side using the platform, fight with the chest and survive of course! 
  
#### Screenshots:
<img width="1279" alt="Screen Shot 2021-12-12 at 12 54 56 PM" src="https://user-images.githubusercontent.com/75734396/145708093-8eab496b-fbbe-4f08-ab7b-be047ad93008.png">
  
<img width="1275" alt="Screen Shot 2021-12-12 at 12 57 08 PM" src="https://user-images.githubusercontent.com/75734396/145708096-edcad01d-5d92-4531-8b2b-d16412ceddd2.png">
  
<img width="1273" alt="Screen Shot 2021-12-12 at 1 04 42 PM" src="https://user-images.githubusercontent.com/75734396/145708179-9eddcc82-7904-4123-82b4-32f7ac35ba20.png">
  
<img width="1274" alt="Screen Shot 2021-12-12 at 1 01 10 PM" src="https://user-images.githubusercontent.com/75734396/145708099-8e29caff-53c4-4ce7-9ff6-eaab5d11a0c3.png">  
  
#### Contents:
- main.lua - contains callback functions		
- conf.lua - some configuration options such as window size, title; some modules set unused to reduce memory usage
- platform.lua - animation of moving platform, checking if the rabbit on it and pushing him forward	
- map_creator.lua - functions randomly generating map, filling it with obstacles and back images
- objects_animation.lua	- calculations of different animations: carrot, veggies, flying balls, thorns, moving system of coordinates; checking if colliding with an obstacle; calculating current ground level under the rabbit
- win_or_gameover.lua - checking if game is over and printing lose/win info
- objects_creator.lua - creation of objects: obstacles, back images, veggies (based on the random number passed)
- credits.txt - art, music/sounds credits
