local Config = require("shared.config");
local Sphere = require("client.modules.sphere");

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

---@return void
function Module:TeleportToArena()
    local ped = PlayerPedId();
    local spawn = Config.Arena.spawn;

    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z, false, false, false, false);
    SetEntityHeading(ped, spawn.w);
end;

---@param radius number
---@return void
function Module:UpdateBoundary(radius)
    self:RemoveBoundary();

    self.State.Zone = Sphere:CreateSphereZone(Config.Arena.center, radius, function()
        self:TeleportToArena();
    end);

    self.State.Zone:SetDebugMode(Config.Arena.visible);
end;

---@return void
function Module:CreateBoundary()
    self:RemoveBoundary();

    self.State.Zone = Sphere:CreateSphereZone(Config.Arena.center, Config.Arena.radius, function()
        self:TeleportToArena();
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
end;

---@return void
function Module:Start()
    self.State.Active = true;
    self:TeleportToArena();
    self:CreateBoundary();
end;

---@return void
function Module:Finish()
    self.State.Active = false;
    self:RemoveBoundary();
end;

return Module;
