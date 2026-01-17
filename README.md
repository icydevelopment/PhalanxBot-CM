CM's mode is added to PhalanxBot(7.40).

Currently, both teams required to have a human captain.

AP game mode remains unchanged.
Copy and paste hero_selection.lua file to folder \Steam\steamapps\workshop\content\570\2873408973. 
Copy and paste cm_position_config.lua file to folder \Steam\steamapps\workshop\content\570\2873408973\Library.
Captain's mode utilizes picks order for role decision.So:
The default order is below.
Pick 5 -> Hard Support
Pick 4 -> Soft Support
Pick 3 -> Offlane
Pick 2 -> Midlane
Pick 1 -> Safelane

The default order can be modified by each human captain but indicating roles in chat as "-pos 5 4 3 2 1". You can indicate it in any order you want. It saves the last message positions before game starts, you can indicate it from pick phase to item-buying phase.
For example, if your last indication is "-pos 3-4-2-1-5".
Pick 1 -> Offlane
Pick 2 -> Soft Support
Pick 3 -> Midlane
Pick 4 -> Safelane
Pick 5 -> Hard Support

You can pick whichever you want and the bots play the remaining roles. It works same for both dire and radiant teams.

***You must be sure that the hero that you pick for the role is included in PhalanxRoles file in directory \Steam\steamapps\workshop\content\570\2873408973\Library
