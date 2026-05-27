local Config = {};

---@class BattleroyaleConfigArena
---@field center vector3
---@field spawn vector4
---@field radius number
---@field debug boolean

---@class BattleroyaleLoadoutItem
---@field name string
---@field count number
---@field metadata table|nil

---@class BattleroyaleLoadout
---@field name string
---@field items BattleroyaleLoadoutItem[]

---@class BattleroyaleConfig
---@field Arena BattleroyaleConfigArena
---@field Loadouts BattleroyaleLoadout[]
---@field AnnouncementDuration number

---@type BattleroyaleConfig
Config = {
    Arena = {
        center = vec3(0.0, 0.0, 72.0), -- replace
        spawn = vec4(0.0, 0.0, 72.0, 0.0), -- replace
        radius = 100.0, -- replace
        debug = true, -- replace
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
};

return Config;
