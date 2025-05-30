# MetroidvaniaPuzzleGame

STOP BEING SUPER VERBOSE FOR SAKE OF OPTIMIZATION, IF IT IS CODE IT REALLY DOESN'T MATTER

================ TODO ================
Remove players previous code
Tweak the wall jump physics to be better
Implement LadderClimbing
Right now the player hit box collision colides with the enemy 4-5 times on 1 attack 
- Maybe I should remove the hit boxes from all but 1 frame
- Give the enemy hurtbox some sort of duplicate attack detection to prevent the hurt() signal call

BIG TODO:
REORGANIZE PROJECT File structure and pieces



Player Character Features
- Climb Ladders
- Interact with stuff
- BUG: The player keeps moving in the air when a direction is pressed. If I stop giving an input the player doesn't stop mid air


Skeleton Features
- Use the Hit animation instead of hit flash
- Figure out how to do pathfinding

===V-SYNC setting was set to Disabled in the project settings to follow a tutorial===
