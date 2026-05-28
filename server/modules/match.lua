local Config = require("shared.config");

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
---@field queuing boolean
---@field timer number
---@field players table<number, BattleroyalePlayer>

---@type BattleroyaleMatchState
Module.State = {
    active = false,
    queuing = false,
    timer = nil,
    players = {},
};

---@param source number
---@return boolean
function Module:IsPlayerInMatch(source)
    return self.State.players[source] ~= nil;
end;

---@param duration number
function Module:SetTimer(duration)
    if self.State.timer then
        self.State.timer:forceEnd(false);
        self.State.timer = nil;
    end;

    self.State.timer = lib.timer(duration, function()
        self:StartMatch();
    end);
end;

---@return number
function Module:GetPlayerCount()
    local count = 0;

    for _ in pairs(self.State.players) do
        count = count + 1;
    end;

    return count;
end;

---@return boolean
function Module:CanStartMatch()
    local playerCount = self:GetPlayerCount();

    if self.State.queuing and playerCount >= Config.MaximumPlayers then
        self:SetTimer(Config.ShortTimer);
    end;

    return playerCount >= Config.MinimumPlayers and playerCount <= Config.MaximumPlayers;
end;

---@return void
function Module:StartMatch()
    if not self:CanStartMatch() then
        self.State.queuing = false;
        self.State.timer = nil;

        Announcer:SendToPlayers(self.State.players, locale("match_cancelled_not_enough_players"));

        return;
    end;

    self.State.queuing = false;
    self.State.active = true;
    self.State.timer = nil;

    for source in pairs(self.State.players) do
        Inventory:GiveItems(source, Loadout:GetItems(self.State.players[source].loadout));
        Registry:Get(Events.Start):FireClient(source);
    end;
end;

---@param source number
---@return boolean, string|nil
function Module:AddPlayer(source)
    if source <= 0 then
        return false, locale("join_player_only");
    end;

    if self.State.active then
        return false, locale("join_match_already_active");
    end;

    if self:IsPlayerInMatch(source) then
        return false, locale("join_already_in_match");
    end;

    if self:GetPlayerCount() >= Config.MaximumPlayers then
        return false, locale("join_match_full");
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

    if self:CanStartMatch() and not self.State.queuing then
        self.State.queuing = true;
        self:SetTimer(Config.LobbyTimer);
    end;

    return true, nil;
end;

---@param source number
---@return boolean, string|nil
function Module:RemovePlayer(source)
    if not self.State.players[source] then
        return false, locale("leave_not_in_match");
    end;

    if self.State.active then
        Inventory:RemoveItems(source, Loadout:GetItems(self.State.players[source].loadout));
    end;

    Registry:Get(Events.Finish):FireClient(source);

    self.State.players[source] = nil;

    local playerCount = self:GetPlayerCount();

    if playerCount <= 0 then
        if self.State.timer then
            self.State.timer:forceEnd(false);
            self.State.timer = nil;
        end;

        self.State.active = false;
        self.State.queuing = false;
    elseif self.State.queuing and playerCount < Config.MinimumPlayers then
        if self.State.timer then
            self.State.timer:forceEnd(false);
            self.State.timer = nil;
        end;

        self.State.queuing = false;
    elseif self.State.active and playerCount <= 1 then
        self:Finish(locale("finish_last_player_standing"));
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

    local valid, err = Announcer:ValidateMessage(message);
    if not valid then
        return false, err;
    end;

    for source in pairs(self.State.players) do
        Inventory:RemoveItems(source, Loadout:GetItems(self.State.players[source].loadout));
        Registry:Get(Events.Finish):FireClient(source, message);
    end;

    self.State.active = false;
    self.State.queuing = false;
    self.State.players = {};

    if self.State.timer then
        self.State.timer:forceEnd(false);
        self.State.timer = nil;
    end;

    return true, nil;
end;

return Module;