local Config = require("shared.config");

local Module = {};
Module.__index = Module;

math.randomseed(os.time());

---@return BattleroyaleLoadout
function Module:GetRandomLoadout()
    local index = math.random(1, #Config.Loadouts);

    return Config.Loadouts[index];
end;

---@param loadout BattleroyaleLoadout
---@return BattleroyaleLoadoutItem[]
function Module:GetItems(loadout)
    return loadout.items;
end;

return Module;
