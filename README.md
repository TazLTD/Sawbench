# :hammer: Sawbench Script for QBCore + ox_inventory

A lightweight and immersive sawbench system for QBCore-based FiveM servers using `ox_target` and `ox_inventory`.

## :rocket: Features
- :mag: Target integration via `ox_target`
- :carpentry_saw: Simple wood cutting system
- :package: Uses `ox_inventory` for item management
- :clapper: Includes cutting animation with attached prop
- :speech_balloon: Fully configurable (labels, durations, distances)
- :jigsaw: Server-client synced with resource efficiency in mind
- :bug: Built-in debug logging




https://github.com/user-attachments/assets/0af755aa-9c64-4f80-a400-99e62e281794




## :package: Requirements
- [QBCore Framework](https://github.com/qbcore-framework/qb-core)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target)

## :brain: How It Works
A player approaches a placed sawbench prop.  
They interact using `ox_target`.  
The script checks if they have wood in their inventory (via `ox_inventory`).  
If yes:
- A progress bar appears.
- An animation plays with a wood prop attached to the hand.
- After completion, 1 wood is removed and 1 plank is added.

If canceled:
- The animation and prop are removed.

## 🧰 Installation

1. Download and extract the resource to your `resources` folder.
2. Ensure the folder is named `sawbench` (or match the name you use in `server.cfg`).
3. Add `ensure sawbench` to your `server.cfg`.
4. Make sure `ox_inventory`, `ox_target`, and `qb-core` are properly installed and started before this script.
5. Customize `config.lua` to fit your server (models, labels, durations, etc.).

**IMPORTANT**: If you don’t have the Sawbench animation & prop, this script will not work. You can get it here: [Tebex Store - Sawbench Animation & Prop](https://bzzz.tebex.io/package/6743379).

### Add to `ox_inventory/data/items.lua`

['wood'] = {
    label = 'Wood',
    weight = 1000,
    stack = true,
    close = true,
    description = 'A chunk of raw wood. Can be cut into planks.',
    client = {}
},

['plank'] = {
    label = 'Plank',
    weight = 800,
    stack = true,
    close = true,
    description = 'A wooden plank, cut from raw wood.',
    client = {}
},



## :raised_hands: Credits
**Script:** TazLTD  
**TazLTD Discord: https://discord.gg/XZ5Jd5WpS4**

**Animation & Prop:** Mrs.bzzz  
:shopping_cart: **Mrs.bzzz Tebex Store:** https://bzzz.tebex.io  
:speech_balloon: **Mrs.bzzz Discord:** https://discord.com/invite/PpAHBCMW97
