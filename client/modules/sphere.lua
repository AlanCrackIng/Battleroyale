local Module = {};
Module.__index = Module;

---@param coords vector3
---@param radius number
---@param onExit function|nil
---@param onEnter function|nil
---@return Module
function Module:CreateSphereZone(coords, radius, onExit, onEnter)
    local self = setmetatable({}, Module);
    self.Sphere = lib.zones.sphere({
        coords = coords,
        radius = radius,
        onExit = onExit,
        onEnter = onEnter,
    });

    return self;
end;

---@param enabled boolean
---@return void 
function Module:SetDebugMode(enabled)
    self.Sphere:setDebug(enabled);
end;

---@return void
function Module:RemoveZone()
    self.Sphere:remove();
end;

return Module;
