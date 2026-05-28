local Event = require("shared.events.event");
local Events = require("shared.events.names");

local ClientEvents = {};

ClientEvents.Start = Event.new(Events.Start):RegisterNetEvent();
ClientEvents.Finish = Event.new(Events.Finish):RegisterNetEvent();
ClientEvents.Announce = Event.new(Events.Announce):RegisterNetEvent();
ClientEvents.Shrink = Event.new(Events.Shrink):RegisterNetEvent();
ClientEvents.PlayerDied = Event.new(Events.PlayerDied):RegisterNetEvent();
ClientEvents.Spectate = Event.new(Events.Spectate):RegisterNetEvent();
ClientEvents.ZoneOut = Event.new(Events.ZoneOut):Register();

return ClientEvents;
