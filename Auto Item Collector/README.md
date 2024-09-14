# Auto Item Collector

All props to the original author [ebizoe](https://www.nexusmods.com/newvegas/users/627838) of the [Auto Item Collector](https://www.nexusmods.com/newvegas/mods/77775) mod, I just made a few changes to suit my needs.

## Changelog

These are the changes I made to the scripts of the original mod:

* Option to disable the internal filter that e.g. doesn't all AIC to collect weapons and other items
  * This includes weapons that were dropped by the actor, which are listed in the UI loot menu but not covered by the regular inventory script functions.
* Option to auto collect playable world items
  * Examples: Weapons, ammo, grenades, consumables, books, junk, etc.
  * The same filters apply as within corpses & containers
  * Option to (de)activate while holding a hotkey (alt-key in my case)
  * Since items dropped from the inventory will pass the crosshair and, if this feature is enabled and the item fits the filter criteria, immediately picked up again, I added a brief grace after dropping (or selling/storing) items, in which AIC will be temporarily disabled. A simple workaround instead of e.g. keeping track of all items previously carried by the player.
  * Tip: Use a UI mod like [Recent Loot Log](https://www.nexusmods.com/newvegas/mods/80180) to see what was recently picked up by AIC
* Auto activate world activators
  * Manually configurable via a new include-list ini file (the template should include the most common activators, lines can be commented out to enabled/disable as needed)
  * NO optional hotkey, either enabled or disabled, if you need a hotkey just use the regular activation key/button
  * Examples:
    * Harvest consumables from plants
    * Disarm traps, ignore those that are already disarmed or destroyed
      * Shows the regular dialog. I didn't want to mess with that since if done correctly it requires skill checks and such and there are mods out there that do this.
      * Trap script variable are checked, so I had to add all traps I could find in the game to the AIC script meaning traps from mods are not considered and some traps might be missing (none found in my playthroughs so far)
    * Instantly disarm and auto collect mines if desired (collect world-items feature must be enabled)
    * Auto perform basically any "clickable" actions in the world, from pressing buttons, hacking terminals, to releasing hostages.
    * Auto use recharge stations and collect weapons, grenades, intel, ... in the Anchorage Battle Zone (simulation)
    * Auto collect Steel Ingots in The Pitt DLC (activators, not regular world-items)
* Auto collect owned items
  * Stealing from owned containers and stealing owned world-items
  * Option to (de)activate while holding a hotkey (some mouse button in my case)
  * Option to only take items if not detection (max. detection level configurable, e.g. only HIDDEN/CAUTION meaning no alarm when stealing)
    * This works even while standing since even though the detection level is not shown in the UI in this case, the PC is e.g. not detected when running around in an empty room.
  * Option to clear or even change ownership to the player when stealing an item
* Added support for the [Just Loot Menu](https://www.nexusmods.com/newvegas/mods/87154) mod, refreshing the HUD container content list after AIC has collected items from the currently targeted container (no more need to turn & re-targeting)
* Added "grave robbing" support
  * Many graves and burial mounds are scripted requiring a shovel to open before they can be looted. They'll now be auto-opened & looted in case the PC has a shovel in its inventory. A message will be shown in case no shovel is needed but none was found.
  * In addition to the regular base-game `Shovel` the *Point Lookout DLC* `Fertilizer shovel` can be used too (not covered by all grave-scripts, but sensible).
* Added filter list management (hotkey) features
  * Added hotkey support to container menus
  * Added left/right alt key as alternatives to the left mouse button (in conjunction with the filter-list management hotkey) to avoid transferring items to/from the container when clicking on them (simply use alt key now)
    * This also allows for keyboard-only interaction
  * Added 3 new hotkeys to quickly add/remove items to/from the custom filter lists
    * Use hotkeys `alt 0/-/=` to `remove from inclusive/exclusive list` / `add to exclusive list` / `add to inclusive list`.
    * This avoids the user the hassle of clicking through a lot of dialogs, especially to remove from one and add to another filter list, e.g. when you are like me and update your list irregularly & in bulk whenever I get back to my "home base".
    * Acoustic feedback is given when adding/removing items to/from the filter lists, including a separate sound in case the desired state is already present so one can simply spam the hotkeys through the list without without any info/confirmation message boxes.
* Added a "reverse corpse looting" feature
  * Similar to the more recent bethesda games, whenever the player targets a dropped weapon, AIC will (should) find the matching corpse and loot it as if the corpse itself was targeted.
  * This is usually not a huge deal, since corpses are mostly closer and large than the dropped weapons, but it's a nice feature to have e.g. when fighting on a catwalk, the weapon is still close to the player but the corpse has fallen down (maybe even inaccessible).

## Tips

For debugging use the following console commands:
```
; Enable
SetDebugMode 1 (GetModIndex "Auto Item Collector.esp")

; Disable (default)
SetDebugMode 0 (GetModIndex "Auto Item Collector.esp")
```

## Todos & Ideas

### Mandatory before any kind of release
* Reduce dependencies to a minimum
  * E.g. change all EditorID (traps etc.) and JLM checks to lookup by string if possible, so this mod does not depend on TTW / other mods
* Consolidate new parameters an add them to MCM
  * In a sensible way, understandable for the regular user
  * Alternatively define reasonable defaults e.g. former defaults, enabled only via new hotkeys (bare minimum, config should follow asap)
  * Also consider adding UI tools to manage the activator filters, or at least provide add the ini file to the documentation for manual editing
    * *Note that items harvested/collected from activators bypass the custom filters, e.g. `Brain Fungus` is not collected directly but added to the PC inventory by an Activator script, so the (current) way would be to remove or comment the various activators like `TTWBrainFungusActivator` from the `AIC Activator Filter.ini` file*
* Testing ... of various scenarios/settings (vs. only my defaults)
* Check all PrintDs
  * Some might be useless, generally inconsistent in style, or even invalid causing crashes (old debugging/learning stuff)
  * In doubt, remove/comment most of them (not relevant for the user)
* Add some kind of aux-timer after (manually) arming a trap to prevent immediate auto-disarming
  * Since I usually don't work with explosives or traps, I didn't look into this yet, but it would be pretty annoying for those who do (in case world-item collection/interaction is always-on w/o a modifier key)

### Optional

* Look for potential performance improvements
  * At least try to ensure "fail/return fast" since crosshair checks are done all the time and the further we go the more resources are potentially wasted
* Check terminology (maintainable code)
  * Comments, variable names, messages, etc. might be incorrect (not a modding expert, less so in my initial changes)
* <strike>Consider "reverse-looting" corpses by targeting a dropped weapon</strike> done, todo:
  * Consider ash-piles if easily possible (rarely use energy weapons, so I didn't look into this yet)
* Consider "monitoring" the dead-state of a currently targeted actor so that AIC will collect on-death vs. having to un- and re-target the actor to re-start the logic

### Low priority thoughts and ideas

* Consider special handling for world-items with onActivate scripts (vs. Activators), e.g. `Plick's Journal` `DLC04FF06PliksJournal` shows a `Read & Get Perk` OR `Cancel` dialogue
  * This particular item stays after activation, so one can still "pick it up", pickup animation shown etc. even without this mod, so this is "normal" and may not need special handling
  * In such cases the "set ownership" feature is applied, even though the item is not actually transferred to the user's inventory, which doesn't seem appropriate (even if it may have no negative side-effects)
  * There may be other cases where this kind of interaction causes problems, at least in case inclusive and hard-coded filters are disabled
* Consider removing all filters when auto-looting the addon/quest containers that give you back all your confiscated items & gear (e.g. *The Pitt*, *Mother Ship Zeta*, ...)
* Consider auto-pickpocket feature, excluding equipped items (if even enabled) and potentially based on configurable min-chance value
