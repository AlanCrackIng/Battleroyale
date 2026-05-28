local Config = {};

---@class BattleroyaleConfigArena
---@field center vector3
---@field radius number
---@field debug boolean
---@field Spawns vector4[]
---@field FreezeDuration number
---@field CountdownIntervals number[]

---@class BattleroyaleConfigCommands
---@field Join string
---@field Leave string
---@field Finish string
---@field Announce string

---@class BattleroyaleLoadoutItem
---@field name string
---@field count number
---@field metadata table|nil

---@class BattleroyaleLoadout
---@field name string
---@field items BattleroyaleLoadoutItem[]

---@class BattleroyaleShrinkStage
---@field radius number
---@field delay number

---@class BattleroyaleConfigShrink
---@field Enabled boolean
---@field Stages BattleroyaleShrinkStage[]

---@class BattleroyaleConfigDeath
---@field AnnounceEnabled boolean
---@field AnnounceToAll boolean
---@field CustomEvent string|false

---@class BattleroyaleConfigSpectate
---@field Enabled boolean
---@field Duration number

---@class BattleroyaleConfig
---@field Arena BattleroyaleConfigArena
---@field Commands BattleroyaleConfigCommands
---@field Loadouts BattleroyaleLoadout[]
---@field AnnouncementDuration number
---@field AnnouncementMaxLength number
---@field MinimumPlayers number
---@field MaximumPlayers number
---@field LobbyTimer number
---@field ShortTimer number
---@field Shrink BattleroyaleConfigShrink
---@field Death BattleroyaleConfigDeath
---@field Spectate BattleroyaleConfigSpectate

---@type BattleroyaleConfig
Config = {
    Arena = {
        center = vec3(0.0, 0.0, 72.0), -- replace
        radius = 100.0, -- replace
        debug = true, -- replace
        Spawns = {
            vec4(0.0, 0.0, 72.0, 0.0), -- replace
            vec4(10.0, 10.0, 72.0, 90.0), -- replace
            vec4(-10.0, -10.0, 72.0, 180.0), -- replace
            vec4(15.0, -15.0, 72.0, 270.0), -- replace
        },
        FreezeDuration = 60000, -- ms, time between teleport and loadout
        CountdownIntervals = { 60, 30, 10, 5, 4, 3, 2, 1 },
    },

    Commands = {
        Join = "brjoin",
        Leave = "brleave",
        Finish = "brfinish",
        Announce = "brannounce",
    },

    Loadouts = { -- temp data
        {
            name = "Pistol",
            items = {
                {
                    name = "WEAPON_PISTOL",
                    count = 1,
                    metadata = {
                        ammo = 60,
                        registered = false,
                    },
                },
            },
        },
        {
            name = "Combat Pistol",
            items = {
                {
                    name = "WEAPON_COMBATPISTOL",
                    count = 1,
                    metadata = {
                        ammo = 72,
                        registered = false,
                    },
                },
            },
        },
        {
            name = "SMG",
            items = {
                {
                    name = "WEAPON_SMG",
                    count = 1,
                    metadata = {
                        ammo = 120,
                        registered = false,
                    },
                },
            },
        },
    },

    AnnouncementDuration = 8000, -- 8 seconds
    AnnouncementMaxLength = 120,

    MinimumPlayers = 5, 
    MaximumPlayers = 30,
    LobbyTimer = 60000, -- 1 minute, after which the match will start after the minimal player count has been reached
    ShortTimer = 10000, -- 10 seconds, after which the match will start if the maximum player count has been reached

    Shrink = {
        Enabled = true,
        Stages = {
            { radius = 75.0, delay = 30000 },
            { radius = 50.0, delay = 60000 },
            { radius = 25.0, delay = 90000 },
        },
    },

    Death = {
        AnnounceEnabled = true,
        AnnounceToAll = true,
        CustomEvent = "battleroyale:onPlayerDeath",
    },

    Spectate = {
        Enabled = true,
        Duration = 0, -- 0 = permanent until match ends, > 0 = seconds
    },
};

return Config;
