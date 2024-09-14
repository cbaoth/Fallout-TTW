# Auto Item Collector

All props to the original author [ebizoe](https://www.nexusmods.com/newvegas/users/627838) of the [Auto Item Collector](https://www.nexusmods.com/newvegas/mods/77775) mod, I just made a few changes to suit my needs.

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
* <strike>Consider looting corpses when a dropped weapon is targeted</strike> done, todo:
  * Consider ash-piles if easily possible (rarely use energy weapons, so I didn't look into this yet)
  * Consider adding option to disable the feature in case it e.g. has a noticeable performance impact or is just not desired
* Consider "monitoring" the dead-state of a currently targeted actor so that AIC will collect on-death vs. having to un- and re-target the actor to re-start the logic

### Low priority thoughts and ideas

* Consider special handling for world-items with onActivate scripts (vs. Activators), e.g. `Plick's Journal` `DLC04FF06PliksJournal` shows a `Read & Get Perk` OR `Cancel` dialogue
  * This particular item stays after activation, so one can still "pick it up", pickup animation shown etc. even without this mod, so this is "normal" and may not need special handling
  * In such cases the "set ownership" feature is applied, even though the item is not actually transferred to the user's inventory, which doesn't seem appropriate (even if it may have no negative side-effects)
  * There may be other cases where this kind of interaction causes problems, at least in case inclusive and hard-coded filters are disabled
* Consider removing all filters when auto-looting the addon/quest containers that give you back all your confiscated items & gear (e.g. *The Pitt*, *Mother Ship Zeta*, ...)
* Consider auto-pickpocket feature, excluding equipped items (if even enabled) and potentially based on configurable min-chance value
