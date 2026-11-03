local _G = GLOBAL
local Text = require "widgets/text"

local UPDATE_INTERVAL = 1
local SEARCH_RADIUS = 5000
local FONT_SIZE = 28

local function FindNearestSack(player)
    if player == nil or player.Transform == nil then
        return nil
    end

    local px, py, pz = player.Transform:GetWorldPosition()
    local nearest = nil
    local nearest_distance_sq = nil

    for _, entity in pairs(_G.Ents) do
        if entity ~= nil
            and entity.prefab == "krampus_sack"
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

AddClassPostConstruct("screens/playerhud", function(self)
    if self.krampus_sack_tracker ~= nil or self.owner == nil then
        return
    end

    local player = self.owner
    local tracker = self:AddChild(Text(_G.CHATFONT, FONT_SIZE, "Krampus Sack: procurando..."))
    tracker:SetHAlign(_G.ANCHOR_MIDDLE)
    tracker:SetVAlign(_G.ANCHOR_MIDDLE)
    tracker:SetRegionSize(520, 50)
    tracker:SetPosition(0, -180, 0)
    tracker:Show()

    self.krampus_sack_tracker = tracker

    player:DoPeriodicTask(UPDATE_INTERVAL, function()
        -- Não chama IsValid no widget Text: ele não implementa esse método.
        if self.krampus_sack_tracker ~= tracker then
            return
        end

        if player:IsValid() == false then
            tracker:Hide()
            return
        end

        local sack, distance, px, pz = FindNearestSack(player)
        if sack ~= nil then
            local sx, sy, sz = sack.Transform:GetWorldPosition()
            tracker:SetString(string.format("Krampus Sack %s  |  %.0f", GetDirectionArrow(sx - px, sz - pz), distance))
        else
            tracker:SetString("Krampus Sack: não detectado")
        end
        tracker:Show()
    end)
end)
