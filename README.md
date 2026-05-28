# Battleroyale

A battle royale script for FiveM. Players can join, get a random loadout, and get teleported to the arena. Last one standing wins.

## How it works

- Players join via `/brjoin`. Once enough players have joined, a timer starts.
- When the timer runs out, all players are teleported to their own spawn point and frozen.
- A countdown appears: 60, 30, 10, 5, 4, 3, 2, 1.
- After the countdown, players receive their weapons and can move. The game has started.
- The zone shrinks over time. Stay inside the zone, otherwise you get a warning. If you're still outside after 5 seconds, you're out.
- If you die, you can spectate your killer (if enabled) until the match ends.
- Last one standing wins.

## Why we built it this way

### Modular and clean

Each part has its own file. Player tracking, zone shrinking, death handling — they're all separate. That makes it easy to change something without breaking the rest.

### Configurable

Almost everything is in `shared/config.lua`: spawns, timers, loadouts, whether the zone shrinks, whether kills get announced, whether spectating is on and for how long.

## Configuration

Edit `shared/config.lua`:

- `Arena.Spawns` — spawn positions (add enough for your max player count)
- `Arena.FreezeDuration` — how long players are frozen after teleport (in milliseconds)
- `Arena.CountdownIntervals` — at which seconds the countdown shows up
- `Shrink.Stages` — when and how far the zone shrinks
- `Death` — whether kills get announced and if a custom event fires
- `Spectate` — whether spectating is on and for how long (0 = until match ends)
