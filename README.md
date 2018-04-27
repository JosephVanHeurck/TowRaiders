# TowRaiders
https://github.com/JosephVanHeurck/towRaiders

SID: 215077234

# Game's Current State
- Game starts up in the combat module in a test state
- Player can play their first turn and can only use the attack action

# Setup
- Open "Tower Raiders.xcodeproj" to access project in xcode
- Run Game using the play button

# Directory Structure
- Master Directory (contains backlog.txt, changelog.txt, licences.txt and README.md)
  - Tower Raiders (Contains all the important project files)
     - Assets.xcassets (contains all assets)
     - Base.Iproj (contains storyboards for screens)
     - Data (contains data files)
      - Session Data (contains data relevant to current Exploration)
      - Account Data (contains all data revelant to the player's account or in this case save)
      - Game Data (contains all base statistics for game objects and characters as well as dialogue scripts)
      - Animation (contains data of animation items to be used in combat)
  - Tower RaiderTests (Excess files used for testing purposes)
  - Tower RaiderTestsUI (Excess files used for testing purposes)

# Henry comments 2/April

(Henry is expecting a readme.md, licenses.txt, and changelog.whatever)

# Henry comments 13/April
- Still missing SIDs.
- Not enough commits + changelog items to pass at this frequency.
- I couldn't find your text-based data. Create a root folder "data/" and put all your JSON files in there.
- You're still missing a licenses.txt file.

# Joseph update 20/April
Sorry about the not having the readme displayed I seem to have a problem with syncing my desktop github folder with github.com. Although that doesnt excuse the lack of commits recently.
I've moved the changelog that was in my original readme file into a dedicated changelog.txt, made a licences.txt and created the data files as required of me.
Again, sorry for the lack of commits, theres no excuse. And thanks for reminding me.

Currently I'm a bit behind schedule as the combat module hasn't been tested in full yet. Upon creating a bunch of fitting test data in PlayerPartyData.csv and CombatEnemyData.csv located in the "Data/Session Data" and WeaponList.csv in "Data/Account Data" I will be able to test and tweak the majority of the combat module.

Once I've finished with the Combat Module I will move on to the Exploration and Hub Modules. As I am behind they will cut into time planned for user testing.

As for asset creation, my artist is now in the final phases of map creation and will soon move on to character design.

# Henry comments 27/April
- I haven't seen any updates in a few days?
- Great to see you starting to work with data.
- Your changelog needs a lot of work
- It's the end of Week 7, I suspect you just need to be spending a lot more time on this to make progress, that's all :)

