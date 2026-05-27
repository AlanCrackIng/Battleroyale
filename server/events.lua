local Event = require("shared.events.event");
local Events = require("shared.events.names");

local ServerEvents = {};

ServerEvents.Leave = Event.new(Events.Leave):RegisterNetEvent();
ServerEvents.Start = Event.new(Events.Start):Register();
ServerEvents.Finish = Event.new(Events.Finish):Register();
ServerEvents.Announce = Event.new(Events.Announce):Register();

return ServerEvents;
