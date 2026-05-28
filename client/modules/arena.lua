local Config = require("shared.config");
local Sphere = require("client.modules.sphere");
local Registry = require("shared.events.registry");
local Events = require("shared.events.names");

local Module = {};
Module.__index = Module;

---@class ArenaState
---@field Zone Module|nil
---@field Active boolean

---@type ArenaState
Module.State = {
    Zone = nil,
    Active = false,
};

---@type boolean|nil
Module.ZoneWarning = nil;

---@return void
function Module:OnZoneExit()
    if self.ZoneWarning then
        return;
    end;

    self.ZoneWarning = true;

    CreateThread(function()
        for i = 5, 1, -1 do
            if not self.ZoneWarning then
                lib.hideTextUI();

                return;
            end;

            lib.showTextUI(locale("zone_exit_warning", i), {
                position = "bottom-center",
            });

            Wait(1000);
        end;

        lib.hideTextUI();
        self.ZoneWarning = nil;

        Registry:Get(Events.ZoneOut):FireServer();
    end);
end;

---@return void
function Module:OnZoneEnter()
    if not self.ZoneWarning then
        return;
    end;

    self.ZoneWarning = nil;
    lib.hideTextUI();
end;

---@param radius number
---@return void
function Module:UpdateBoundary(radius)
    self:RemoveBoundary();

    self.State.Zone = Sphere:CreateSphereZone(Config.Arena.center, radius, function()
        self:OnZoneExit();
    end, function()
        self:OnZoneEnter();
    end);

    self.State.Zone:SetDebugMode(Config.Arena.visible);
end;

---@return void
function Module:CreateBoundary()
    self:RemoveBoundary();

    self.State.Zone = Sphere:CreateSphereZone(Config.Arena.center, Config.Arena.radius, function()
        self:OnZoneExit();
    end, function()
        self:OnZoneEnter();
    end);

    self.State.Zone:SetDebugMode(Config.Arena.visible);
end;

---@return void
function Module:RemoveBoundary()
    if not self.State.Zone then
        return;
    end;

    self.State.Zone:RemoveZone();
    self.State.Zone = nil;

    self.ZoneWarning = nil;
    lib.hideTextUI();
end;

---@return void
function Module:Start()
    self.State.Active = true;
    self:CreateBoundary();
end;

---@return void
function Module:Finish()
    self.State.Active = false;
    self:RemoveBoundary();
end;

return Module;
