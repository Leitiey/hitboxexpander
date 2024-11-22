local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Create the UI elements for the ScrollingFrame (adjusting the hitbox size)
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 318, 0, 438)
frame.Position = UDim2.new(0.374, 0, 0.228, 0 )
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Darker background color
frame.BackgroundTransparency = 0  -- Slight transparency for a modern look
frame.Parent = screenGui

-- Add a UICorner for rounded corners to the frame
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)  -- Rounded corners
frameCorner.Parent = frame

-- Add a shadow effect for a more modern feel (using a second frame as a shadow)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, 0, 0, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.ZIndex = frame.ZIndex - 1
shadow.Parent = frame

local scrollBar = Instance.new("TextButton")
scrollBar.Size = UDim2.new(0, 200, 0, 40)
scrollBar.Position = UDim2.new(0.217, 0, 0.393, 0)
scrollBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Modern blue color
scrollBar.Text = "Hitbox Size: 0"
scrollBar.TextColor3 = Color3.fromRGB(0, 0, 0)
scrollBar.TextSize = 18
scrollBar.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 200, 0, 40)
label.Position = UDim2.new(0.204, 0, 0.007, 0)
label.BackgroundTransparency = 1
label.Text = "hitbox expander v.1"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 17
label.Parent = frame

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 200, 0, 40)
credit.Position = UDim2.new(0.186, 0, 0.062, 0)
credit.BackgroundTransparency = 1
credit.Text = "by: floki"
credit.TextColor3 = Color3.fromRGB(255, 255, 255)
credit.TextSize = 15
credit.Parent = frame

frame.Active = true
frame.Selectable = true
frame.Draggable = true


-- Add a UICorner for rounded corners to the button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)  -- Rounded corners for button
buttonCorner.Parent = scrollBar

local hitboxSize = 1  -- Default hitbox size multiplier

-- Function to adjust the hitboxes
local function updateHitboxes()
	-- Loop through all players in the game
	for _, player in ipairs(Players:GetPlayers()) do
		-- Skip if the player does not have a character
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local character = player.Character
			local humanoidRootPart = character.HumanoidRootPart

			-- Check if the blue box exists, if not, create it
			local existingHitboxIndicator = character:FindFirstChild("HitboxIndicator")
			if not existingHitboxIndicator then
				local hitboxIndicator = Instance.new("Part")
				hitboxIndicator.Name = "HitboxIndicator"
				hitboxIndicator.Size = Vector3.new(5, 10, 5)  -- Default size
				hitboxIndicator.Position = humanoidRootPart.Position
				hitboxIndicator.Anchored = true
				hitboxIndicator.CanCollide = false
				hitboxIndicator.Material = Enum.Material.SmoothPlastic
				hitboxIndicator.Color = Color3.fromRGB(0, 0, 255)
				hitboxIndicator.Transparency = 0.5  -- Transparent blue box
				hitboxIndicator.Parent = character
			end

			-- Resize the blue box based on the hitboxSize multiplier
			local hitboxIndicator = character:FindFirstChild("HitboxIndicator")
			hitboxIndicator.Size = Vector3.new(5 * hitboxSize, 10 * hitboxSize, 5 * hitboxSize)  -- Adjust size
			hitboxIndicator.Position = humanoidRootPart.Position  -- Ensure box follows player position
		end
	end
end

-- Adjust the hitbox size based on slider position
scrollBar.MouseButton1Down:Connect(function()
	local mouseMoveConnection
	mouseMoveConnection = player:GetMouse().Move:Connect(function()
		-- Calculate the new hitbox size based on the horizontal position of the mouse
		local mouseX = player:GetMouse().X
		hitboxSize = math.clamp((mouseX - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0.1, 5)  -- Size ranges from 0.1 to 5
		scrollBar.Text = "Hitbox Size: " .. math.round(hitboxSize, 2)  -- Update button text to reflect size
	end)

	-- Stop tracking when the mouse button is released
	player:GetMouse().Button1Up:Connect(function()
		mouseMoveConnection:Disconnect()
	end)
end)

-- Continuously update the hitboxes every frame
RunService.Heartbeat:Connect(function()
	updateHitboxes()
end)
