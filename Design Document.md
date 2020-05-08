# Dungeon Crawl Design Document

A traditional roguelike where an adventurer explores a series of multilevel dungeons to complete a quest, find treasure, and gain experience. 
Dungeons are procedurally generated 2D maps. Gameplay is turn-based.

## Gameplay

The game is a series of quests, each requiring the player to explore a dungeon. 
Dungeon exploration is turn-based. 
Each turn the player can do one of the following:

* move one space
* attack
* pick up an item
* use an item
* rest(?)

Dungeons are dark so the player can only see 1-3 spaces away. Using a torch increases that distance. 
(Does torch require player to not use a shield?)
Items (such as weapons and shields) can be enchanted with light spells in place of a torch.

The player has a limited amount of health that is lost during combat and by traps; and can be regained by potions and scrolls.

Managing health must be balanced against another limiting factor. 
This is TBD but could be:
* a hunger mechanism, as is common in traditional roguelites
* fatigue, which could be affected by the player's stats
* time, which could be implemented by an actual timer or by an increasing monster alert level that causes monsters to spawn at higher rates the longer the player stays on a level.

Deaths are permanent with no carry-over between games.

## Story

Details to be fleshed out later (perhaps based on Beowulf?).
Story progression will be based on a series of fixed quests that become available when the player hits specific levels.
Between those story quests will be random quests that let the player get more experience, better weapons, and treasure.
The story will end with a final quest when the player reaches TBD level.

### Quests

Look at [Quests in Roguelikes](http://www.roguebasin.com/index.php?title=Quests_in_Roguelikes) for inspiration.

## Player Character

The player can be male (Geoffrey) or female (Rosalind).
There may be an option to choose a race but initially the player will always be human.

The player starts with randomly generated attributes which they can adjust to suit their play-style.
(If races are implemented, choosing the race is what adjusts the initial attributes.)

### Attributes

The player has the following attributes. These are initially randomly generated.
They can be increased in small amounts as the player advances levels.

* Strength: Affects how much melee damage a player deals; what melee weapons can be used; and physical skills.
* Wisdom: Affects spell-casting damage; what scrolls can be used; and magical skills.
* Dexterity: Affects how much ranged damage a player deals; what ranged weapons can be used; and nimble skills.

### Skills

All skills start at level 1.
As the player advances in level, they can choose which skills to increase.

(Stretch: have the skills advance based on play style? For example, a player that uses melee weapons more often in combat will automatically have melee weapon skill increase.)

#### Physical Skills

* One-handed weapons: Affects damage done with one-handed weapons; and provides access to better one-handed weapons.
* Two-handed weapons: Affects damage done with two-handed weapons; and provides access to better two-handed weapons.
* TBD

#### Magical Skills

* Combat spells: Affects damage done with combat spells; and provides access to better combat spells.
* Healing spells: Affects amount of health healed by spells; and provides access to better healing spells.
* Summoning spells: Provides access to spells that summon creatures that will fight for the player.
* TBD

#### Nimble Skills

* Bows: Affects damage done with bows; and provides access to better bows.
* Crossbows: Affects damage done with crossbows; and provides access to better crossbows.
* Perception: Affects ability to detect hidden traps, doors, and monsters.
* Sneak: Affects ability to move without being detected; and provides ability to backstab monsters.
* TBD

### Levels

The player starts at level 1.
Players earn experience for defeating monsters, casting spells(?), detecting hidden objects(?), and completing a quest. The maximum level is TBD (20?).

Player level requirements and bonuses:
* TBD

## Towns and NPCs

Between dungeons, the player needs a way to get new quests; buy/sell items and treasure; and interact with NPCs in ways that make the world feel "real".

The specifics for how this will work are TBD.

Initially the player will have a quest giver that provides the next quest; gives rewards for completing a quest; and has some limited ability to let the players buy and sell items and treasure.

## Items

* Melee weapons (one-handed; two-handed)
* Ranged weapons (bows; crossbows)
* Shields
* Torches
* Wearables (armor, rings, necklaces, amulets)
* Consumables (potions, scrolls, anything consumed by use)
* Charged items (items that can only be used x times unless recharged)
* Loot/junk to sell/scrap
* Food(?)

Magical items have to be identified to know what they are.
Some sort of hint system should provide clues to the attentive player.
Otherwise they aren't identified until they player uses them or uses a spell, scroll, or NPC to identify them.

## Monsters

* Different strategies for different monsters
* Monster alert level
  * The longer you stay on a level and the more monsters you see, the more they seek you out
  * Alternative to hunger?