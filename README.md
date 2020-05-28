# DungeonCrawl

A simple Roguelike to experiment with procedural dungeon generation.

## Goals
* A fully operational single dungeon
  * quest goal
  * items
  * monsters
  * traps
  * secret rooms?
* Character leveling
  * stats
  * skills
* Quests
  * random quest
* Items
  * weapons
  * armor
  * scrolls
  * potions (healing, poison, etc.)
  * treasure
* Monsters
    * Jelly Cube
    * Giant Bat
    * Skeleton
    * Shadow
    * Giant Spider
    * Ghast
* Traps
  * tbd

## Dungeon Generation

See the `DungeonGenerator` class. Its `build()` method returns a `DungeonModel` containing a `GridMap` and a list of `RoomModel`s.

Based on the algorithms described by Bob Nystrom in [Rooms And Mazes](http://journal.stuffwithstuff.com/2014/12/21/rooms-and-mazes/).
  