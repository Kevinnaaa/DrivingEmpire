local RunService = game:GetService("RunService")
local part = script.Parent -- The part that will follow the player

-- Function to find the target player (change "PlayerName" to the actual player)
local function getTargetPlayer()
	-- For example, getting the first player in the game:
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			return player
		end
	end
	return nil
end

local targetPlayer = getTargetPlayer()

if targetPlayer then
	-- Optional: Make the part uncollidable and weightless so it doesn't glitch the player
	part.CanCollide = false
	part.Anchored = true -- We will update position manually via script

	RunService.Heartbeat:Connect(function(dt)
		local character = targetPlayer.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local hrp = character.HumanoidRootPart
			
			-- Calculate position 10 studs behind/in front of the player
			-- Using hrp.CFrame.LookVector * 10 puts it 10 studs straight ahead of where they look
			-- Or use a fixed offset like Vector3.new(0, 5, 10) for 10 studs away + slightly above
			local offset = Vector3.new(0, 3, 10) 
			local targetCFrame = hrp.CFrame * CFrame.new(offset)
			
			part.CFrame = targetCFrame
		end
	end)
end
