# Core Fault
Source code for the Playdate game "Core Fault", made by me (SquidGod) and davemakes. A mini Vampiror Survivors-like game where you control a remoted operated mining droid, using crank operated movement to weave around and fight enemies, get upgrades, and run it back. I handled most of the code, and davemakes handled all the art, music, sfx, and most of the game balancing. You can find it on [Catalog](https://play.date/games/core-fault/) and [Itch IO](https://squidgod.itch.io/core-fault). 

<img src="https://github.com/user-attachments/assets/d899a755-b080-4fdd-b17c-8e6daf68337c" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/8d9094c4-5fa4-4ad9-baa1-c8719d4d9440" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/bb47bad9-1c90-497e-9590-076618aa1954" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/363f3a4f-704d-40b3-8174-c4860253377f" width="400" height="240"/>

## Project Structure
- `scripts/`
  - `audio/`
    - `musicPlayer.lua` - A music manager used to manage the songs being played
    - `sfxPlayer.lua` - A small helper class to play sfx without reloading the sound file every time
    - `soundFiles.lua` - A data file to load all the sounds at once in the beginning, for performance reasons
  - `data/`
    - `enemyStats.lua` - Holds all enemy stats, so we can change it in one place
    - `equipmentData.lua` - Holds all equipment stats
    - `playerStats.lua` - Holds all base player stats
    - `spawnProbabilities.lua` - Holds all the enemy spawn weights for each depth level
    - `storedDataManager.lua` - Manages saving and loading data
    - `unlockData.lua` - Holds all the unlocks and their stats
    - `upgradeData.lua` - Holds all upgrade stats
  - `game/`
    - `gameUI/`
      - `selectionPanel.lua` - The UI for selecting equipment or upgrades during the run
      - `streakBackground.lua` - The dynamically animated streaking background
      - `swapPanel.lua` - The UI for swapping out your equipment
    - `gameManager.lua` - The overall game state manager that manages the entire run from start to finish
    - `gameOverScene.lua` - The final scene in a run that shows your results
    - `startScene.lua` - The beginning scene in a run that shows you your initial equipment choices
    - `upgradeScene.lua` - The scene between levels that allows you to upgrade your droid
  - `level/`
    - `enemies/` - Houses all the enemies
      - `crab.lua`
      - `crabMedium.lua`
      - `enemy.lua` - The parent enemy class that all the enemies extend
      - `enemyProjectile.lua` - Class that handles the projectile object for enemies
      - `fly.lua`
      - `flyMedium.lua`
      - `slime.lua`
      - `slimeMedium.lua`
    - `mapGeneration/`
      - `mapGenerator.lua` - Generates all the walls and layout of a level
      - `mapPatterns.lua` - A data file that stores all the different layout types, which I separated out for organization
    - `ore/`
      - `ore.lua` - The individual class that instances the ore in a level
      - `oreSpawner.lua` - Manages spawning ore in empty spots, keeping track of the ore mined, and drawing the ore count
    - `player/`
      - `equipment/` - Holds all the equipment constructors
        - `components/` - A sort of pseudo-entity component system that was created to share functionality/code between equipment
          - `doesAOEDamage.lua`
          - `doesDamage.lua`
          - `equipment.lua` - Parent class for all equipment, and handles upgrading the equipment based on level
          - `firesProjectile.lua`
          - `followsPlayer.lua`
          - `hasCooldown.lua`
          - `projectile.lua`
        - `beam.lua`
        - `discharge.lua`
        - `peaShooter.lua`
        - `plasmaCannon.lua`
        - `pocketDrill.lua`
        - `radioWaves.lua`
        - `shockProd.lua`
        - `staticField.lua`
        - `subterraneanRocket.lua`
      - `upgrades/` - Holds all upgrade constructors
        - `attackSpeed.lua`
        - `critChance.lua`
        - `critDamage.lua`
        - `damage.lua`
        - `health.lua`
        - `healthRegen.lua`
        - `moveSpeed.lua`
        - `piercing.lua`
        - `restoration.lua`
      - `healthbar.lua` - Keeps track of player health and draws the health bar
      - `player.lua` - Handles pretty much everything related to the player (movement, drawing, collision, equipment, upgrades, etc.)
    - `hud.lua` - Manages drawing the XP and remaining time
    - `levelScene.lua` - Scene for managing each individual level, which parents everything else in this folder
  - `libraries/`
    - `AnimatedSprite.lua` - By Whitebrim: animation state machine
    - `SceneManager.lua` - The scene manager that I made a tutorial on that manages switching between scenes
  - `title/`
    - `titleScene.lua` - Title screen UI
    - `unlockScene.lua` - Unlocks screen UI
- `main.lua` - Globals, main update, and handles loop to update projectiles

## License
All code is licensed under the terms of the MIT license.
