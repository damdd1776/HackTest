local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function to highlight a character reliably
local function highlightCharacter(character, player)
    if not character then return end -- Safety check
    local head = nil
    local retries = 10 -- Number of attempts to find Head

    -- Retry logic for finding the Head and ensuring the character is ready
    while retries > 0 and not head do
        head = character:FindFirstChild("Head")
        retries -= 1
        task.wait(0.1)
    end

    if head then
        -- Add BillboardGui for name display
        if not head:FindFirstChild("HighlightGui") then
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Size = UDim2.new(4, 0, 1, 0)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Name = "HighlightGui"

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = player.DisplayName
            textLabel.TextColor3 = Color3.new(1, 1, 0) -- Yellow
            textLabel.BackgroundTransparency = 1
            textLabel.TextScaled = true
            textLabel.Parent = billboardGui

            billboardGui.Parent = head
        end

        -- Add Highlight effect for glow
        if not character:FindFirstChild("Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.FillColor = Color3.new(0.5, 0.8, 1) -- Light blue
            highlight.OutlineColor = Color3.new(1, 1, 1) -- White
            highlight.Parent = character
        end
    else
        warn("Failed to highlight character for player: " .. player.Name)
    end
end

-- Function to handle player
local function setupPlayerHighlight(player)
    -- Highlight any already loaded character
    if player.Character then
        highlightCharacter(player.Character, player)
    end

    -- Connect CharacterAdded to handle respawns
    player.CharacterAdded:Connect(function(character)
        highlightCharacter(character, player)
    end)
end

-- Set up highlight for all players
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayerHighlight(player)
end

Players.PlayerAdded:Connect(setupPlayerHighlight)

-- Safety Loop to Retry Highlighting
-- This is in case a player's character loads late or is modified after the script runs
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and not player.Character:FindFirstChild("Highlight") then
            highlightCharacter(player.Character, player)
        end
    end
end)
