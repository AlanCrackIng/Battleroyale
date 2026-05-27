local Registry = require("shared.events.registry");
local Events = require("shared.events.names");
local Inventory = require("server.modules.inventory");
local Loadout = require("server.modules.loadout");

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
---@return void
function Module:AddPlayer(source)
    local loadout = Loadout:GetRandomLoadout();

    self.State.players[source] = {
        source = source,
        alive = true,
        loadout = loadout,
    };

    Inventory:GiveItems(source, Loadout:GetItems(loadout));
    Registry:Get(Events.Start):FireClient(source);
end;

---@param source number
---@return void
function Module:RemovePlayer(source)
    if not self.State.players[source] then
        return;
    end;

    Inventory:RemoveItems(source, Loadout:GetItems(self.State.players[source].loadout));
    Registry:Get(Events.Finish):FireClient(source);

    self.State.players[source] = nil;
end;

---@param message string
---@return void
function Module:Finish(message)
    for source in pairs(self.State.players) do
        Inventory:RemoveItems(source, Loadout:GetItems(self.State.players[source].loadout));
        Registry:Get(Events.Finish):FireClient(source, message);
    end;

    self.State.active = false;
    self.State.players = {};
end;

return Module;
