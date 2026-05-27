local Registry = require("shared.events.registry");
local Events = require("shared.events.names");
local Inventory = require("server.modules.inventory");
local Loadout = require("server.modules.loadout");
local Announcer = require("server.modules.announcer");

local Module = {};
Module.__index = Module;

---@class BattleroyalePlayer
---@field source number
---@field alive boolean
---@field loadout BattleroyaleLoadout

---@class BattleroyaleMatchState
---@field active boolean
---@field players table<number, BattleroyalePlayer>

---@type BattleroyaleMatchState
Module.State = {
    active = false,
    players = {},
};

---@param source number
---@return boolean
function Module:IsPlayerInMatch(source)
    return self.State.players[source] ~= nil;
end;

---@return number
function Module:GetPlayerCount()
    local count = 0;

    for _ in pairs(self.State.players) do
        count = count + 1;
    end;

    return count;
end;

---@param source number
---@return boolean, string|nil
function Module:AddPlayer(source)
    if source <= 0 then
        return false, locale("join_player_only");
    end;

    if self:IsPlayerInMatch(source) then
        return false, locale("join_already_in_match");
    end;

    local loadout = Loadout:GetRandomLoadout();

    if not loadout then
        return false, locale("join_no_loadouts");
    end;

    self.State.players[source] = {
        source = source,
        alive = true,
        loadout = loadout,
    };

    self.State.active = true;

    Inventory:GiveItems(source, Loadout:GetItems(loadout));
    Registry:Get(Events.Start):FireClient(source);

    return true, nil;
end;

---@param source number
---@return boolean, string|nil
function Module:RemovePlayer(source)
    if not self.State.players[source] then
        return false, locale("leave_not_in_match");
    end;

    Inventory:RemoveItems(source, Loadout:GetItems(self.State.players[source].loadout));
    Registry:Get(Events.Finish):FireClient(source);

    self.State.players[source] = nil;

    if self:GetPlayerCount() <= 0 then
        self.State.active = false;
    end;

    return true, nil;
end;

---@param message string
---@return boolean, string|nil
function Module:Announce(message)
    if not self.State.active then
        return false, locale("announce_no_active_match");
    end;

    if self:GetPlayerCount() <= 0 then
        return false, locale("announce_no_players");
    end;

    return Announcer:SendToPlayers(self.State.players, message);
end;

---@param message string
---@return boolean, string|nil
function Module:Finish(message)
    if not self.State.active then
        return false, locale("finish_no_active_match");
    end;

    if self:GetPlayerCount() <= 0 then
        return false, locale("finish_no_players");
    end;

    local valid, error = Announcer:ValidateMessage(message);

    if not valid then
        return false, error;
    end;

    for source in pairs(self.State.players) do
        Inventory:RemoveItems(source, Loadout:GetItems(self.State.players[source].loadout));
        Registry:Get(Events.Finish):FireClient(source, message);
    end;

    self.State.active = false;
    self.State.players = {};

    return true, nil;
end;

return Module;
