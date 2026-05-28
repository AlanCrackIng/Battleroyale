local Config = require("shared.config");
local Registry = require("shared.events.registry");
local Events = require("shared.events.names");
local Inventory = require("server.modules.inventory");
local Loadout = require("server.modules.loadout");
local Announcer = require("server.modules.announcer");

local State = require("server.modules.match.state");
local Players = require("server.modules.match.player");
local Shrink = require("server.modules.match.shrink");
local Death = require("server.modules.match.death");

local Module = {};
Module.__index = Module;

---@return boolean
function Module:IsActive()
    return State:IsActive();
end;

---@return boolean
function Module:IsPlayerInMatch(source)
    return Players:Exists(source);
end;

---@return number
function Module:GetPlayerCount()
    return Players:GetCount();
end;

---@return number
function Module:GetAliveCount()
    return Players:GetAliveCount();
end;

---@return boolean
function Module:CanStartMatch()
    if not State:IsQueuing() then
        return false;
    end;

    return Players:GetCount() >= Config.MinimumPlayers;
end;

---@return void
function Module:StartMatch()
    if not self:CanStartMatch() then
        State:Reset();

        Announcer:SendToPlayers(Players:GetAll(), locale("match_cancelled_not_enough_players"));

        return;
    end;

    State:SetActive(true);
    State:CancelTimer();

    for source in pairs(Players:GetAll()) do
        local player = Players:Get(source);

        if player then
            Inventory:GiveItems(source, Loadout:GetItems(player.loadout));
            Registry:Get(Events.Start):FireClient(source);
        end;
    end;

    Shrink:Start(function(radius)
        for source in pairs(Players:GetAll()) do
            Registry:Get(Events.Shrink):FireClient(source, radius);
        end;
    end);
end;

---@param source number
---@return boolean, string|nil
function Module:AddPlayer(source)
    if State:IsActive() then
        return false, locale("join_match_already_active");
    end;

    local success, error = Players:Add(source);

    if not success then
        return false, error;
    end;

    local count = Players:GetCount();

    if count >= Config.MaximumPlayers then
        if not State:IsQueuing() then
            State:SetQueuing(true);
        end;

        State:SetTimer(Config.ShortTimer, function()
            self:StartMatch();
        end);
    elseif count >= Config.MinimumPlayers and not State:IsQueuing() then
        State:SetQueuing(true);
        State:SetTimer(Config.LobbyTimer, function()
            self:StartMatch();
        end);
    end;

    return true, nil;
end;

---@param source number
---@param killer number|nil
---@return boolean, string|nil
function Module:EliminatePlayer(source, killer)
    if not State:IsActive() then
        return false, locale("finish_no_active_match");
    end;

    if not Players:Exists(source) then
        return false, locale("leave_not_in_match");
    end;

    local player = Players:Get(source);

    if not player or not player.alive then
        return false, nil;
    end;

    Inventory:RemoveItems(source, Loadout:GetItems(player.loadout));
    player.alive = false;

    Death:AnnounceDeath(source, killer);
    Death:HandleDeath(source, killer);

    if Players:GetAliveCount() <= 1 then
        self:Finish(locale("finish_last_player_standing"));

        return true, nil;
    end;

    return true, nil;
end;

---@param source number
---@return boolean, string|nil
function Module:RemovePlayer(source)
    if not Players:Exists(source) then
        return false, locale("leave_not_in_match");
    end;

    local player = Players:Get(source);
    local wasDead = player and not player.alive;

    if State:IsActive() then
        if not wasDead then
            Inventory:RemoveItems(source, Loadout:GetItems(player.loadout));
        end;

        Inventory:GiveItems(source, Loadout:GetItems(player.loadout));
    end;

    if not wasDead then
        Registry:Get(Events.Finish):FireClient(source);
    end;

    Players:Remove(source);

    local count = Players:GetCount();
    local aliveCount = Players:GetAliveCount();

    if count <= 0 then
        State:Reset();
    elseif State:IsQueuing() and count < Config.MinimumPlayers then
        State:CancelTimer();
        State:SetQueuing(false);
    elseif State:IsActive() and not wasDead and aliveCount <= 1 then
        self:Finish(locale("finish_last_player_standing"));
    end;

    return true, nil;
end;

---@param message string
---@return boolean, string|nil
function Module:Announce(message)
    if not State:IsActive() then
        return false, locale("announce_no_active_match");
    end;

    if Players:GetCount() <= 0 then
        return false, locale("announce_no_players");
    end;

    return Announcer:SendToPlayers(Players:GetAll(), message);
end;

---@param message string
---@return boolean, string|nil
function Module:Finish(message)
    if not State:IsActive() then
        return false, locale("finish_no_active_match");
    end;

    if Players:GetCount() <= 0 then
        return false, locale("finish_no_players");
    end;

    local valid, error = Announcer:ValidateMessage(message);

    if not valid then
        return false, error;
    end;

    for source in pairs(Players:GetAll()) do
        local player = Players:Get(source);

        if player then
            if player.alive then
                Inventory:RemoveItems(source, Loadout:GetItems(player.loadout));
            end;

            Registry:Get(Events.Finish):FireClient(source, message);
        end;
    end;

    Shrink:Stop();
    State:Reset();
    Players:Clear();

    return true, nil;
end;

return Module;
