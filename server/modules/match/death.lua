local Config = require("shared.config");
local Registry = require("shared.events.registry");
local Events = require("shared.events.names");

local Module = {};
Module.__index = Module;

---@param source number
---@param killer number|nil
---@return void
function Module:HandleDeath(source, killer)
    self:Spectate(source, killer);
    self:FireCustomEvent(source, killer);
    self:FireDeathEvent(source);
end;

---@param source number
---@param killer number|nil
---@return void
function Module:FireDeathEvent(source)
    Registry:Get(Events.PlayerDied):FireClient(source);
end;

---@param source number
---@param killer number|nil
---@return void
function Module:Spectate(source, killer)
    if not Config.Spectate.Enabled or not killer then
        return;
    end;

    if killer <= 0 then
        return;
    end;

    Registry:Get(Events.Spectate):FireClient(source, killer, Config.Spectate.Duration);
end;

---@param source number
---@param killer number|nil
---@return void
function Module:FireCustomEvent(source, killer)
    if not Config.Death.CustomEvent then
        return;
    end;

    if type(Config.Death.CustomEvent) ~= "string" then
        return;
    end;

    TriggerEvent(Config.Death.CustomEvent, source, killer);
end;

---@param source number
---@param killer number|nil
---@return void
function Module:AnnounceDeath(source, killer)
    if not Config.Death.AnnounceEnabled then
        return;
    end;

    local name = GetPlayerName(source);
    local killerName = (killer and killer > 0) and GetPlayerName(killer) or nil;
    local message;

    if killerName then
        message = locale("player_eliminated_by", name, killerName);
    else
        message = locale("player_eliminated", name);
    end;

    if Config.Death.AnnounceToAll then
        TriggerClientEvent(Events.Announce, -1, message);
    elseif killerName then
        Registry:Get(Events.Announce):FireClient(killer, message);
    end;
end;

return Module;
