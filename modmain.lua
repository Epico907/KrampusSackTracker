local _G = GLOBAL
local Text = require "widgets/text"

local UPDATE_INTERVAL = 1
local SEARCH_RADIUS = 5000
local FONT_SIZE = 28

local function FindNearestKrampus(player)
    if player == nil or player.Transform == nil then
        return nil
    end

    local px, py, pz = player.Transform:GetWorldPosition()
    local nearest = nil
    local nearest_distance_sq = nil

    for _, entity in pairs(_G.Ents) do
        if entity ~= nil
            and entity.prefab == "krampus"
            and entity.Transform ~= nil
            and (entity.IsValid == nil or entity:IsValid()) then

            local x, y, z = entity.Transform:GetWorldPosition()
            local dx = x - px
            local dz = z - pz
            local distance_sq = dx * dx + dz * dz

            if distance_sq <= SEARCH_RADIUS * SEARCH_RADIUS
                and (nearest_distance_sq == nil or distance_sq < nearest_distance_sq) then
                nearest = entity
                nearest_distance_sq = distance_sq
            end
        end
    end

    if nearest ~= nil then
        return nearest, math.sqrt(nearest_distance_sq), px, pz
    end

    return nil
end

local function GetDirectionArrow(dx, dz)
    local angle = math.atan2(dz, dx)
    local octant = math.floor(angle / (math.pi / 4) + 0.5) % 8
    local arrows = {
        [0] = "→", [1] = "↗", [2] = "↑", [3] = "↖",
        [4] = "←", [5] = "↙", [6] = "↓", [7] = "↘",
    }
    return arrows[octant]
end

AddClassPostConstruct("widgets/controls", function(self)
    local player = self.owner
    if player == nil or self.krampus_tracker ~= nil then
        return
    end

    -- bottom_root acompanha a área inferior do HUD e mantém o texto
    -- posicionado acima do inventário.
    local anchor = self.bottom_root or self
    local tracker = anchor:AddChild(Text(_G.CHATFONT, FONT_SIZE, "Krampus: procurando..."))
    tracker:SetHAlign(_G.ANCHOR_MIDDLE)
    tracker:SetVAlign(_G.ANCHOR_MIDDLE)
    tracker:SetRegionSize(520, 50)
    tracker:SetPosition(0, 115, 0)
    tracker:Show()

    self.krampus_tracker = tracker

    player:DoPeriodicTask(UPDATE_INTERVAL, function()
        if self.krampus_tracker ~= tracker then
            return
        end

        if not player:IsValid() then
            tracker:Hide()
            return
        end

        local krampus, distance, px, pz = FindNearestKrampus(player)
        if krampus ~= nil then
            local kx, ky, kz = krampus.Transform:GetWorldPosition()
            tracker:SetString(string.format("Krampus %s  |  %.0f", GetDirectionArrow(kx - px, kz - pz), distance))
        else
            tracker:SetString("Krampus: não detectado")
        end
        tracker:Show()
    end)
end)
