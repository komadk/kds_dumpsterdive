# KD-Scripts - Dumpster Diving

A FiveM resource for ESX that allows players to search through dumpsters and trash cans for potentially valuable items.

## Features

- Search dumpsters and trash cans throughout the map
- Different animations for dumpsters vs. trash cans
- Tiered loot system with different rarities (common, uncommon, rare)
- Chance to find special items like gold watches and alive chickens
- Customizable cooldowns for searching
- Full integration with ox_inventory, ox_target, and ox_lib

## Dependencies

- [es_extended](https://github.com/esx-framework/esx-legacy)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)

## Installation

1. Make sure you have all dependencies installed and running
2. Place the `koma_dumpsterdive` folder in your resources directory
3. Add `ensure koma_dumpsterdive` to your server.cfg
4. Restart your server or start the resource manually

## Configuration

The script can be configured in the `config.lua` file:

- Adjust cooldown timers
- Modify which models are considered dumpsters or trash cans
- Change animations used for searching
- Add or remove items that can be found
- Adjust item drop chances and tiers
- Modify maximum items found per search

## Usage

Players can:
- Use the ox_target interaction to search dumpsters and trash cans

Admins can:
- Use the `/dumpsterreward [type]` command to test rewards (type: 'dumpster' or 'trashcan')

## Notes

- Items from the item list must exist in your ox_inventory configuration
- This script uses ox_lib notifications by default 

## Author
- KD-Scripts
- https://discord.gg/43CeeMUfxW

## Version
1.0.0 
