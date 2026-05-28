local Config = require("shared.config");
local Loadout = require("server.modules.loadout");

local Module = {};
Module.__index = Module;

---@class BattleroyalePlayer
---@field source number
---@field alive boolean
---@field loadout BattleroyaleLoadout

---@type table<number, BattleroyalePlayer>
Module.List = {};

---@param source number
---@return BattleroyalePlayer|nil
function Module:Get(source)
    return self.List[source];
end;

---@param source number
---@return boolean
function Module:Exists(source)
    return self.List[source] ~= nil;
end;

---@return number
function Module:GetCount()
    local count = 0;

    for _ in pairs(self.List) do
        count = count + 1;
    end;

    return count;
end;

---@param source number
---@return boolean, string|nil
function Module:Add(source)
    if source <= 0 then
        return false, locale("join_player_only");
    end;

    if self:Exists(source) then
        return false, locale("join_already_in_match");
    end;

    if self:GetCount() >= Config.MaximumPlayers then
        return false, locale("join_match_full");
    end;

    local loadout = Loadout:GetRandomLoadout();

    if not loadout then
        return false, locale("join_no_loadouts");
    end;

    self.List[source] = {
        source = source,
        alive = true,
        loadout = loadout,
    };

    return true, nil;
end;

---@param source number
---@return BattleroyalePlayer|nil
function Module:Remove(source)
    local player = self.List[source];

    if not player then
        return nil;
    end;

    self.List[source] = nil;

    return player;
end;

---@return void
function Module:Clear()
    self.List = {};
end;

---@return table<number, BattleroyalePlayer>
function Module:GetAll()
    return self.List;
end;

return Module;
