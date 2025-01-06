# Rockman 8 Practice Hack v0.01
-------------------------------
# Functionality
This speedrunning practice hack is for the Japanese version of Mega Man 8, Rockman 8. Upon starting the game and skipping the intro cutscene, stage select will load. Each stage selected will automatically provide the speedrun loadout (weapons & support items). The Exit functionality is always enabled, or the player can return to stage select by using Select + Cross. Refer to controls for access to all stages, including Wily stages.

# Compilation
Download this codebase as a zip and extract to a folder. Place "Rockman 8 - Metal Heroes (Japan).bin" and "Rockman 8 - Metal Heroes (Japan).cue" in the root folder. Run "make2.bat". The output will be placed in `/bin`.

# Controls:

## Stage Select

While selecting a Robot Master stage, hold Select to boot to part 2. This is necessary for loading checkpoints in the part 2. Most likely you will load into a bugged looking area - force a game over (Select + Cross) to fix. 

While selecting the Wily stage, hold the following buttons while selecting the stage:
- Wily 1: Circle
- Wily 2: Circle + R1
- Wily 3: Circle + L2
- Wily 4: Circle + R2

Make sure you first hold either L/R, then press Circle.

## Gameplay

- Select + Square: Set Rockman's HP to max  
- Select + Triangle: Instantly KO Rockman, forcing a reload. Use this to reload checkpoints  
- Select + Circle: Set boss HP to 1  
- Select + Cross: Instantly KO Rockman and force a game over screen  

## Checkpoints

While using checkpoint modifiers, either use Select or Select + Up to set a checkpoint, then force a death to reload. This functionality comes with risk of loading inappropriate checkpoints and bugging the game. 

Use the following combinations to set the index to the corresponding number:
- Select + L1: 0
- Select + R1: 1
- Select + L2: 2
- Select + R2: 3
- Select + Up + L1: 4
- Select + Up + R1: 5
- Select + Up + L2: 6
- Select + Up + R2: 7

For example, from stage select, hold R2 and press Circle to spawn in Wily 4. Then while in Wily 4, to access the final boss, press Select + R1 to set the checkpoint to 1. Then press Select + Triangle to reload. 

### Checkpoint indexes

#### Grenade
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Halfway
- 2 (Select + L2): Part 1 Miniboss
- 3 (Select + R2): Part 2 Start
- 4 (Select + L1): Part 2 Halfway
- 5 (Select + R1): Part 2 Boss

In order to access part 2 via checkpoint loading, you must finish part 1 to load part 2.  

#### Frost
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Sled
- 2 (Select + L2): Part 2 Start
- 3 (Select + R2): Part 2 Climb
- 4 (Select + L1): Part 2 Sled
- 5 (Select + R1): Part 2 Boss

All Frost Man checkpoints are immediately accessible.

#### Tengu
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Post-climb
- 2 (Select + L2): Part 1 Autoscroller
- 3 (Select + R2): Part 2 Start
- 4 (Select + L1): Part 2 Pre-Climb
- 5 (Select + R1): Part 2 Post-Climb
- 6 (Select + L2): Part 2 Boss

In order to access part 2 via checkpoint loading, you must finish part 1 to load part 2.  

#### Clown
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Halfway
- 2 (Select + L2): Part 1 Miniboss
- 3 (Select + R2): Part 2 Start
- 4 (Select + L1): Part 2 Halfway
- 5 (Select + R1): Part 2 Boss

In order to access part 2 via checkpoint loading, you must finish part 1 to load part 2.  

#### Duo
- 0 (Select + L1): Start
- 1 (Select + R1): Boss

#### Astro
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Maze
- 2 (Select + L2): Part 1 Tower
- 3 (Select + R2): Part 2 Start
- 4 (Select + L1): Part 2 Maze
- 5 (Select + R1): Part 2 Boss

In order to access part 2 via checkpoint loading, you must finish part 1 to load part 2. Loading checkpoint 2 while in checkpoint 1 area causes weirdness, and same with 4/5. 

#### Aqua
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Miniboss
- 2 (Select + L2): Part 2 Start
- 3 (Select + R2): Part 2 Vertical fall
- 4 (Select + L1): Part 2 Spike room
- 5 (Select + R1): Part 2 Final room
- 6 (Select + L2): Part 2 Boss

In order to access part 2 via checkpoint loading, you must finish part 1 to load part 2.  

#### Sword
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Center Room
- 2 (Select + L2): Part 1 Miniboss
- 3 (Select + R2): Part 2 Start
- 4 (Select + L1): Part 2 Halfway
- 5 (Select + R1): Part 2 Boss

In order to access part 2 via checkpoint loading, you must finish part 1 to load part 2.  

#### Search
- 0 (Select + L1): Part 1 Start
- 1 (Select + R1): Part 1 Halfway
- 2 (Select + L2): Part 2 Start
- 3 (Select + R2): Part 2 Halfway
- 4 (Select + L1): Part 2 Boss

In order to access part 2 via checkpoint loading, you must finish part 1 to load part 2.  

#### Wily 1
- 0 (Select + L1): Start
- 1 (Select + R1): Halfway
- 2 (Select + L2): Boss

#### Wily 2
- 0 (Select + L1): Start
- 1 (Select + R1): Halfway
- 2 (Select + L2): Boss

#### Wily 3
- 0 (Select + L1): Start
- 1 (Select + R1): Miniboss
- 2 (Select + L2): Halfway
- 3 (Select + R2): Boss

#### Wily 4
- 0 (Select + L1): Start
- 1 (Select + R1): Halfway
- 2 (Select + L2): Boss

## Known issues:
Forcing a death during a cutscene will softlock the game. 

Using Select + Circle to spawn in Sword Man 2 currently causes a softlock. Fight Gearna Eye instead. 

Duo does not respawn currently. 

Dying to Forte in Wily 3 may cause the stage select to hardlock the game. 

Wily 4's refights have some strangeness when leaving a fight with the bosses respawning. Forcing a reload (Select + Triangle) will fix. 

## Credits

Made by [cleartonic](https://twitch.tv/cleartonic).

Thanks to akiteru answering some questions and for their [Mega Man X4 Practice Hack](https://github.com/AkiteruSDA/MegaManX4Practice), for which this project is largely based on.
