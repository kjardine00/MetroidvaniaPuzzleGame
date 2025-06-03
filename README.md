# MetroidvaniaPuzzleGame

STOP BEING SUPER VERBOSE FOR SAKE OF OPTIMIZATION, IF IT IS CODE IT REALLY DOESN'T MATTER

================ TODO ================
Sounds?

REFACTOR LATER
- combine functions of collectable objs ? Maybe that doesn't matter
- the player script to decouple responsibilities Also don't have too just a maybe
    - a Velocity Component
    - maybe try the callable state machine, idk if I really need it through it seems to be fine so far with out it


Player Character Features
- BUG: The player keeps moving in the air when a direction is pressed. If I stop giving an input the player doesn't stop mid air
	- This bug is fixed now but the wall jump now doesn't push the player away from the wall fast enough unless the player switches their input direction AFTER the jump input
- Dash
- Finish the other animation implementations

Skeleton Features
- Use the Hit animation instead of hit flash
- Figure out how to do pathfinding

Signs
- I need to put in the dialogue manager so I can give signs text to display
