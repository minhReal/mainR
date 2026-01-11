--[[
      Place this script in StarterGui
]]
-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
 
local Player = Players.LocalPlayer
local Remote = ReplicatedStorage:WaitForChild("Exe")
 
-- [[ CONFIGURATION ]] --
local GAMEPASS_ID = 0 -- if someone buys ur gamepass, theyll get the cooldown adjusted
local TARGET_PLACE_ID = 0
local ADMIN_LIST = { -- The people whose names are listed here will have their cooldown adjusted without needing to buy a gamepass
[game.CreatorId] = true,
[10982829993877] = true,
}
 
-- [[ THEME & COLORS ]] --
local THEME_COLOR = Color3.fromRGB(46, 204, 113)
local BG_COLOR = Color3.fromRGB(20, 20, 20)
local BUTTON_GRAY = Color3.fromRGB(50, 50, 50)
local COLOR_ON = Color3.fromRGB(46, 204, 113)
local COLOR_OFF = Color3.fromRGB(192, 57, 43)
 
local CURRENT_LANG = "EN"
local EXECUTION_MODE = "SERVER"
local IS_COOLDOWN = false
 
-- [[ LANGUAGE DATA ]] --
local LANG = {
EN = {
TAB_EXE = "MAIN", TAB_REQ = "IDS",
BTN_CLEAR = "CLEAR", BTN_RUN = "RUN", BTN_RESPAWN = "RESPAWN", BTN_REJOIN = "REJOIN", BTN_USE = "USE",
SET_LANG = "LANGUAGE", SET_MODE = "MODE", SET_R6 = "R6 (suck)", SET_CAM = "FIX CAMERA",
VAL_SERVER = "SERVER", VAL_CLIENT = "CLIENT", VAL_CLICK = "CLICK",
TIT_ERR = "Error", TIT_LOADING = "Server", TIT_FAIL = "Failed", TIT_SUCCESS = "Success", TIT_WARN = "Warning", TIT_SYS = "System",
MSG_NO_ID = "ID Not Found!", MSG_LOADING = "Loading ID: ", MSG_FAIL = "Module Error/Private/Deleted.",
MSG_SUCCESS = "Executed functions: ", MSG_NO_FUNC = "No functions found.",
    MSG_R6_ON = "Auto R6: ON", MSG_R6_OFF = "Auto R6: OFF", MSG_CAM = "Camera Fixed!", MSG_MODE = "Mode switched to: "
    },
    VN = {
    TAB_EXE = "MAIN", TAB_REQ = "IDS",
    BTN_CLEAR = "XÓA", BTN_RUN = "CHẠY", BTN_RESPAWN = "RESPAWN", BTN_REJOIN = "REJOIN", BTN_USE = "DÙNG",
    SET_LANG = "NGÔN NGỮ", SET_MODE = "CHẾ ĐỘ", SET_R6 = "R6", SET_CAM = "SỬA CAMERA",
    VAL_SERVER = "SERVER", VAL_CLIENT = "CLIENT", VAL_CLICK = "NHẤN",
    TIT_ERR = "LỖI", TIT_LOADING = "SERVER", TIT_FAIL = "THẤT BẠI", TIT_SUCCESS = "THÀNH CÔNG", TIT_WARN = "CẢNH BÁO", TIT_SYS = "HỆ THỐNG",
    MSG_NO_ID = "Không tìm thấy ID!", MSG_LOADING = "Đang tải ID: ", MSG_FAIL = "Script lỗi/Private/Đã xóa.",
    MSG_SUCCESS = "Đã chạy số hàm: ", MSG_NO_FUNC = "Không tìm thấy hàm chạy.",
    MSG_R6_ON = "Tự động R6: BẬT", MSG_R6_OFF = "Tự động R6: TẮT", MSG_CAM = "Đã sửa Camera!", MSG_MODE = "Đã đổi chế độ: "
    }
    }
    
    -- [[ DATABASE ]] --
    local SCRIPT_DATABASE = {
    {Name = "KJ", ID = "17776365113"},
    {Name = "Infection", ID = "8317917339"},
    {Name = "Spawn Car", ID = "6886067324"},
    {Name = "MC Script", ID = "0x42E865914ADB"},
    {Name = "Mafia", ID = "82428270854492"},
    {Name = "Gojo", ID = "16689350444"},
    {Name = "Guest 1337", ID = "81657562726106"},
    }
    
    -- [[ FUNCTIONS ]] --
    local function FixCamera()
        local cam = workspace.CurrentCamera
        cam.CameraType = Enum.CameraType.Custom
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            cam.CameraSubject = Player.Character.Humanoid
        end
        local L = LANG[CURRENT_LANG]
        StarterGui:SetCore("SendNotification", {Title=L.SET_CAM, Text=L.MSG_CAM})
    end
    
    local function RejoinServer()
        if #game.Players:GetPlayers() <= 1 then
            Player:Kick("Rejoining...")
            task.wait()
            TeleportService:Teleport(game.PlaceId, Player)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
        end
    end
    
    -- [[ REMOTE HANDLING ]] --
    Remote.OnClientEvent:Connect(function(action, data)
        if action == "Notify" then
            local L = LANG[CURRENT_LANG]
            local title = L[data.Title] or data.Title
            local msg = L[data.Msg] or data.Msg
            if data.Extra then msg = msg .. data.Extra end
            StarterGui:SetCore("SendNotification", {Title = title, Text = msg, Duration = 3})
        end
    end)
    
    -- [[ GUI SETUP ]] --
    local GUI_NAME = "Ex"
    if Player.PlayerGui:FindFirstChild(GUI_NAME) then Player.PlayerGui[GUI_NAME]:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GUI_NAME
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Player.PlayerGui
    
    -- [[ GUI TOGGLE ]]
    local ToggleGui = Instance.new("TextButton")
    ToggleGui.Size = UDim2.new(0, 50, 0, 50)
    ToggleGui.Position = UDim2.new(0, 15, 1, -70)
    ToggleGui.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleGui.Text = "<\\>"
    ToggleGui.TextSize = 17
    ToggleGui.TextColor3 = THEME_COLOR
    ToggleGui.Font = Enum.Font.FredokaOne
    ToggleGui.Parent = ScreenGui
    Instance.new("UICorner", ToggleGui).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", ToggleGui).Color = THEME_COLOR
    
    -- [[ TUTORIAL ARROW ]] --
    local ArrowLabel = Instance.new("TextLabel")
    ArrowLabel.Name = "TutorialArrow"
    ArrowLabel.Size = UDim2.new(0, 60, 0, 40)
    ArrowLabel.BackgroundTransparency = 1
    ArrowLabel.Text = "◄"
    ArrowLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    ArrowLabel.TextSize = 40
    ArrowLabel.Font = Enum.Font.GothamBold
    ArrowLabel.Position = UDim2.new(0, 70, 1, -65)
    ArrowLabel.Parent = ScreenGui
    
    local ArrowTween = TweenService:Create(ArrowLabel, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Position = UDim2.new(0, 80, 1, -65)})
    ArrowTween:Play()
    
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 320)
    Main.Position = UDim2.new(0.5, -275, 0.5, -160)
    Main.BackgroundColor3 = BG_COLOR
    Main.Visible = false
    Main.ClipsDescendants = true 
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_COLOR
    Stroke.Transparency = 0.5
    Stroke.Parent = Main
    
    -- [[ DRAGGABLE ]] --
    local function makeDraggable(topbarObject, object)
        local dragging, dragInput, dragStart, startPos
        local function update(input)
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        topbarObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = object.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
                end
                end)
                    topbarObject.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
                    end)
                    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
                    end
                        makeDraggable(Main, Main)
                        
                        -- [[ HEADER SETUP ]] --
                        local Header = Instance.new("Frame")
                        Header.Size = UDim2.new(1, 0, 0, 45)
                        Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        Header.ZIndex = 10
                        Header.Parent = Main
                        Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
                        
                        local SettingsPanel = Instance.new("Frame")
                        SettingsPanel.Size = UDim2.new(0, 160, 1, -45)
                        SettingsPanel.Position = UDim2.new(0, -160, 0, 45)
                        SettingsPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                        SettingsPanel.BorderSizePixel = 0
                        SettingsPanel.ZIndex = 8
                        SettingsPanel.Parent = Main
                        
                        local SettingsList = Instance.new("UIListLayout")
                        SettingsList.Parent = SettingsPanel
                        SettingsList.SortOrder = Enum.SortOrder.LayoutOrder
                        SettingsList.Padding = UDim.new(0, 5)
                        local SetPad = Instance.new("UIPadding")
                        SetPad.PaddingLeft = UDim.new(0, 10)
                        SetPad.PaddingTop = UDim.new(0, 10)
                        SetPad.Parent = SettingsPanel
                        
                        local SettingBtn = Instance.new("TextButton")
                        SettingBtn.Size = UDim2.new(0, 45, 0, 45)
                        SettingBtn.BackgroundTransparency = 1
                        SettingBtn.Text = "⚙"
                        SettingBtn.TextColor3 = THEME_COLOR
                        SettingBtn.TextSize = 24
                        SettingBtn.ZIndex = 11
                        SettingBtn.Parent = Header
                        
                        local TabExe = Instance.new("TextButton")
                        TabExe.Size = UDim2.new(0.5, -22, 1, 0)
                        TabExe.Position = UDim2.new(0, 45, 0, 0)
                        TabExe.BackgroundTransparency = 1
                        TabExe.Text = LANG[CURRENT_LANG].TAB_EXE
                        TabExe.TextColor3 = Color3.new(1,1,1)
                        TabExe.Font = Enum.Font.GothamBold
                        TabExe.ZIndex = 11
                        TabExe.Parent = Header
                        
                        local TabHub = Instance.new("TextButton")
                        TabHub.Size = UDim2.new(0.5, -22, 1, 0)
                        TabHub.Position = UDim2.new(0.5, 22, 0, 0)
                        TabHub.BackgroundTransparency = 1
                        TabHub.Text = LANG[CURRENT_LANG].TAB_REQ
                        TabHub.TextColor3 = Color3.fromRGB(150, 150, 150)
                        TabHub.Font = Enum.Font.GothamBold
                        TabHub.ZIndex = 11
                        TabHub.Parent = Header
                        
                        local Indicator = Instance.new("Frame")
                        Indicator.Size = UDim2.new(0.5, -22, 0, 3)
                        Indicator.Position = UDim2.new(0, 45, 1, -3)
                        Indicator.BackgroundColor3 = THEME_COLOR
                        Indicator.BorderSizePixel = 0
                        Indicator.ZIndex = 11
                        Indicator.Parent = Header
                        
                        local Container = Instance.new("Frame")
                        Container.Size = UDim2.new(1, 0, 1, -45)
                        Container.Position = UDim2.new(0, 0, 0, 45)
                        Container.BackgroundTransparency = 1
                        Container.ZIndex = 1
                        Container.Parent = Main
                        
                        local TextObjects = {
                        TabExe = TabExe, TabHub = TabHub, BtnClear = nil, BtnRun = nil, BtnRespawn = nil, BtnRejoin = nil,
                        Settings = {}, HubItems = {}
                        }
                        
                        -- [[ UPDATE LANGUAGE ]] --
                        local function UpdateLanguage()
                            local L = LANG[CURRENT_LANG]
                            TextObjects.TabExe.Text = L.TAB_EXE
                            TextObjects.TabHub.Text = L.TAB_REQ
                            
                            if TextObjects.BtnClear then TextObjects.BtnClear.Text = L.BTN_CLEAR end
                            if TextObjects.BtnRun and not IS_COOLDOWN then TextObjects.BtnRun.Text = L.BTN_RUN end
                            if TextObjects.BtnRespawn then TextObjects.BtnRespawn.Text = L.BTN_RESPAWN end
                            if TextObjects.BtnRejoin then TextObjects.BtnRejoin.Text = L.BTN_REJOIN end
                            
                            if TextObjects.Settings["LANGUAGE"] then TextObjects.Settings["LANGUAGE"].Label.Text = L.SET_LANG end
                            if TextObjects.Settings["MODE"] then 
                                TextObjects.Settings["MODE"].Label.Text = L.SET_MODE 
                                TextObjects.Settings["MODE"].Btn.Text = (EXECUTION_MODE == "SERVER") and L.VAL_SERVER or L.VAL_CLIENT
                            end
                            if TextObjects.Settings["R6"] then TextObjects.Settings["R6"].Label.Text = L.SET_R6 end
                            if TextObjects.Settings["FIX CAMERA"] then 
                                TextObjects.Settings["FIX CAMERA"].Label.Text = L.SET_CAM 
                                TextObjects.Settings["FIX CAMERA"].Btn.Text = L.VAL_CLICK
                            end
                            
                            for i, itemData in pairs(TextObjects.HubItems) do
                                itemData.UseBtn.Text = L.BTN_USE
                            end
                        end
                        
                        -- [[ SETTINGS CREATOR ]] --
                        local function createSetItem(key, text, type, callback, initialState)
                            local F = Instance.new("Frame")
                            F.Size = UDim2.new(1, -10, 0, 40)
                            F.BackgroundTransparency = 1
                            F.ZIndex = 9
                            F.Parent = SettingsPanel
                            
                            local L = Instance.new("TextLabel")
                            L.Size = UDim2.new(1,0,0,15)
                            L.BackgroundTransparency = 1
                            L.Text = text
                            L.TextColor3 = Color3.fromRGB(200,200,200)
                            L.Font = Enum.Font.Gotham
                            L.TextSize = 10
                            L.ZIndex = 9
                            L.Parent = F
                            
                            local B = Instance.new("TextButton")
                            B.Size = UDim2.new(1,0,0,20)
                            B.Position = UDim2.new(0,0,0,18)
                            B.Font = Enum.Font.GothamBold
                            B.TextColor3 = Color3.new(1,1,1)
                            B.TextSize = 11
                            B.ZIndex = 9
                            B.Parent = F
                            Instance.new("UICorner", B).CornerRadius = UDim.new(0,4)
                            
                            TextObjects.Settings[key] = {Label = L, Btn = B}
                            
                            if type == "Toggle" then
                                B.Text = initialState and "ON" or "OFF"
                                B.BackgroundColor3 = initialState and COLOR_ON or COLOR_OFF
                                B.MouseButton1Click:Connect(function()
                                    local newState = not (B.Text == "ON")
                                    B.Text = newState and "ON" or "OFF"
                                    B.BackgroundColor3 = newState and COLOR_ON or COLOR_OFF
                                    callback(newState)
                                end)
                            else
                                B.Text = initialState
                                B.BackgroundColor3 = BUTTON_GRAY
                                B.MouseButton1Click:Connect(function() callback(B) end)
                                end
                                end
                                    
                                    -- [[ SETTINGS ITEMS ]] --
                                    createSetItem("LANGUAGE", "LANGUAGE", "Toggle", function(state)
                                        if CURRENT_LANG == "EN" then CURRENT_LANG = "VN" else CURRENT_LANG = "EN" end
                                        TextObjects.Settings["LANGUAGE"].Btn.Text = (CURRENT_LANG == "VN") and "VN" or "EN"
                                        TextObjects.Settings["LANGUAGE"].Btn.BackgroundColor3 = BUTTON_GRAY
                                        UpdateLanguage()
                                    end, "EN")
                                    TextObjects.Settings["LANGUAGE"].Btn.Text = "EN"; TextObjects.Settings["LANGUAGE"].Btn.BackgroundColor3 = BUTTON_GRAY
                                    
                                    createSetItem("MODE", "MODE", "Toggle", function(state)
                                        if EXECUTION_MODE == "SERVER" then EXECUTION_MODE = "CLIENT" else EXECUTION_MODE = "SERVER" end
                                        local L = LANG[CURRENT_LANG]
                                        TextObjects.Settings["MODE"].Btn.Text = (EXECUTION_MODE == "SERVER") and L.VAL_SERVER or L.VAL_CLIENT
                                        TextObjects.Settings["MODE"].Btn.BackgroundColor3 = BUTTON_GRAY
                                        StarterGui:SetCore("SendNotification", {Title="Mode", Text=L.MSG_MODE .. EXECUTION_MODE})
                                    end, "SERVER")
                                    TextObjects.Settings["MODE"].Btn.Text = "SERVER"; TextObjects.Settings["MODE"].Btn.BackgroundColor3 = BUTTON_GRAY
                                    
                                    createSetItem("R6", "AUTO R6", "Toggle", function(state)
                                        Remote:FireServer("ToggleR6", state)
                                    end, false)
                                    
                                    createSetItem("FIX CAMERA", "FIX CAMERA", "Btn", function(btn) FixCamera() end, "CLICK")
                                        
                                        -- [[ PAGE 1: EXECUTOR ]] --
                                        local PageExe = Instance.new("Frame")
                                        PageExe.Size = UDim2.new(1, 0, 1, 0)
                                        PageExe.BackgroundTransparency = 1
                                        PageExe.Parent = Container
                                        
                                        local Input = Instance.new("TextBox")
                                        Input.Size = UDim2.new(1, -20, 0, 180)
                                        Input.Position = UDim2.new(0, 10, 0, 10)
                                        Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                        Input.Text = ""
                                        Input.PlaceholderText = 'require(ID)("' .. Player.Name .. '")'
                                        Input.TextColor3 = THEME_COLOR
                                        Input.Font = Enum.Font.Code
                                        Input.TextSize = 13
                                        Input.TextXAlignment = "Left"
                                        Input.TextYAlignment = "Top"
                                        Input.MultiLine = true
                                        Input.ClearTextOnFocus = false
                                        Input.Parent = PageExe
                                        Instance.new("UICorner", Input)
                                        
                                        local Clear = Instance.new("TextButton")
                                        Clear.Size = UDim2.new(0, 50, 0, 20)
                                        Clear.Position = UDim2.new(1, -60, 0, 150)
                                        Clear.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                                        Clear.Text = LANG[CURRENT_LANG].BTN_CLEAR
                                        Clear.TextColor3 = Color3.new(1,1,1)
                                        Clear.Font = Enum.Font.GothamBold
                                        Clear.TextSize = 10
                                        Clear.Parent = Input
                                        Instance.new("UICorner", Clear)
                                        Clear.MouseButton1Click:Connect(function() Input.Text = "" end)
                                            TextObjects.BtnClear = Clear
                                            
                                            local BtnArea = Instance.new("Frame")
                                            BtnArea.Size = UDim2.new(1, -20, 0, 75)
                                            BtnArea.Position = UDim2.new(0, 10, 1, -85)
                                            BtnArea.BackgroundTransparency = 1
                                            BtnArea.Parent = PageExe
                                            
                                            local Run = Instance.new("TextButton")
                                            Run.Size = UDim2.new(1, 0, 0, 35)
                                            Run.BackgroundColor3 = THEME_COLOR
                                            Run.Text = LANG[CURRENT_LANG].BTN_RUN
                                            Run.TextColor3 = Color3.new(1,1,1)
                                            Run.Font = Enum.Font.GothamBlack
                                            Run.Parent = BtnArea
                                            Instance.new("UICorner", Run)
                                            TextObjects.BtnRun = Run
                                            
                                            -- [[ BUTTON HANDLERS ]] --
                                            local function mkBtn(txtKey, col, act, pos, width, isLoc, objKey)
                                                local b = Instance.new("TextButton")
                                                b.Size = UDim2.new(width, -5, 0, 30)
                                                b.Position = pos
                                                b.BackgroundColor3 = col
                                                b.Text = LANG[CURRENT_LANG][txtKey]
                                                b.TextColor3 = Color3.new(1,1,1)
                                                b.Font = Enum.Font.GothamBold
                                                b.Parent = BtnArea
                                                Instance.new("UICorner", b)
                                                b.MouseButton1Click:Connect(function() if isLoc then act() else Remote:FireServer(act) end end)
                                                    TextObjects[objKey] = b
                                                end
                                                
                                                mkBtn("BTN_RESPAWN", Color3.fromRGB(192, 57, 43), "Respawn", UDim2.new(0,0,0,45), 0.5, false, "BtnRespawn")
                                                mkBtn("BTN_REJOIN", Color3.fromRGB(41, 128, 185), RejoinServer, UDim2.new(0.5,0,0,45), 0.5, true, "BtnRejoin")
                                                
                                                -- [[ EXECUTE WITH COOLDOWN ]] --
                                                Run.MouseButton1Click:Connect(function()
                                                    if IS_COOLDOWN then return end
                                                    
                                                    local cooldownTime = 4.5 -- u can adjust this 🔴
                                                    local isAdmin = ADMIN_LIST[Player.UserId]
                                                    local hasGamepass = false
                                                    
                                                    local success, owns = pcall(function()
                                                        return MarketplaceService:UserOwnsGamePassAsync(Player.UserId, GAMEPASS_ID)
                                                    end)
                                                    if success and owns then hasGamepass = true end
                                                    
                                                    if isAdmin then
                                                        cooldownTime = 0  -- this is the admin cooldown adjustment
                                                    elseif hasGamepass then 
                                                        cooldownTime = 0.5 -- this is the main part of the cooldown for those who buy the gamepass
                                                    end
                                                    
                                                    if EXECUTION_MODE == "SERVER" then 
                                                        Remote:FireServer("Execute", Input.Text)
                                                    else 
                                                        local f = loadstring(Input.Text); if f then f() end 
                                                    end
                                                    
                                                    if cooldownTime <= 0 then return end
                                                    
                                                    IS_COOLDOWN = true
                                                    Run.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                                                    
                                                    local step = 0.1
                                                    for i = cooldownTime, 0, -step do
                                                        if not Main.Parent then break end
                                                        Run.Text = string.format("%.1fs", i)
                                                        task.wait(step)
                                                    end
                                                    
                                                    IS_COOLDOWN = false
                                                    Run.BackgroundColor3 = THEME_COLOR
                                                    Run.Text = LANG[CURRENT_LANG].BTN_RUN
                                                end)
                                                
                                                -- [[ PAGE 2: IDS ]] --
                                                local PageHub = Instance.new("ScrollingFrame")
                                                PageHub.Size = UDim2.new(1, -20, 1, -20)
                                                PageHub.Position = UDim2.new(0, 10, 0, 10)
                                                PageHub.BackgroundTransparency = 1
                                                PageHub.Visible = false
                                                PageHub.AutomaticCanvasSize = Enum.AutomaticSize.Y
                                                PageHub.CanvasSize = UDim2.new(0,0,0,0)
                                                PageHub.ScrollBarThickness = 6
                                                PageHub.Parent = Container
                                                local UIList = Instance.new("UIListLayout")
                                                UIList.Parent = PageHub; UIList.Padding = UDim.new(0, 8); UIList.SortOrder = Enum.SortOrder.LayoutOrder
                                                
                                                for i, info in pairs(SCRIPT_DATABASE) do
                                                    local Item = Instance.new("Frame")
                                                    Item.Size = UDim2.new(1, -5, 0, 50)
                                                    Item.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                                    Item.Parent = PageHub
                                                    Instance.new("UICorner", Item)
                                                    
                                                    local N = Instance.new("TextLabel")
                                                    N.Size = UDim2.new(1, -60, 1, 0)
                                                    N.Position = UDim2.new(0, 10, 0, 0)
                                                    N.BackgroundTransparency = 1
                                                    N.Text = info.Name
                                                    N.TextColor3 = THEME_COLOR
                                                    N.Font = Enum.Font.GothamBold
                                                    N.TextSize = 20
                                                    N.TextXAlignment = "Left"
                                                    N.Parent = Item
                                                    
                                                    local Use = Instance.new("TextButton")
                                                    Use.Size = UDim2.new(0, 50, 0, 30)
                                                    Use.Position = UDim2.new(1, -60, 0, 10)
                                                    Use.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                                                    Use.Text = LANG[CURRENT_LANG].BTN_USE
                                                    Use.TextColor3 = Color3.new(1,1,1)
                                                    Use.Font = Enum.Font.GothamBold
                                                    Use.Parent = Item
                                                    Instance.new("UICorner", Use)
                                                    
                                                    TextObjects.HubItems[i] = {UseBtn = Use}
                                                    
                                                    Use.MouseButton1Click:Connect(function()
                                                        Input.Text = 'require(' .. info.ID .. ')("' .. Player.Name .. '")'
                                                        TabExe.TextColor3 = Color3.new(1,1,1); TabHub.TextColor3 = Color3.fromRGB(150, 150, 150)
                                                        TweenService:Create(Indicator, TweenInfo.new(0.3), {Position = UDim2.new(0, 45, 1, -3)}):Play()
                                                        PageExe.Visible = true; PageHub.Visible = false
                                                    end)
                                                end
                                                
                                                -- [[ TAB SWITCHING ]] --
                                                TabExe.MouseButton1Click:Connect(function()
                                                    TabExe.TextColor3 = Color3.new(1,1,1); TabHub.TextColor3 = Color3.fromRGB(150, 150, 150)
                                                    TweenService:Create(Indicator, TweenInfo.new(0.3), {Position = UDim2.new(0, 45, 1, -3)}):Play()
                                                    PageExe.Visible = true; PageHub.Visible = false
                                                end)
                                                TabHub.MouseButton1Click:Connect(function()
                                                    TabHub.TextColor3 = Color3.new(1,1,1); TabExe.TextColor3 = Color3.fromRGB(150, 150, 150)
                                                    TweenService:Create(Indicator, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 22, 1, -3)}):Play()
                                                    PageExe.Visible = false; PageHub.Visible = true
                                                end)
                                                
                                                -- [[ SETTINGS TOGGLE ]] --
                                                local isSetOpen = false
                                                SettingBtn.MouseButton1Click:Connect(function()
                                                    isSetOpen = not isSetOpen
                                                    if isSetOpen then
                                                        SettingsPanel.Visible = true
                                                        TweenService:Create(SettingsPanel, TweenInfo.new(0.3), {Position = UDim2.new(0,0,0,45)}):Play()
                                                        TweenService:Create(Container, TweenInfo.new(0.3), {Position = UDim2.new(0,160,0,45), Size = UDim2.new(1,-160,1,-45)}):Play()
                                                    else
                                                        TweenService:Create(SettingsPanel, TweenInfo.new(0.3), {Position = UDim2.new(0,-160,0,45)}):Play()
                                                        TweenService:Create(Container, TweenInfo.new(0.3), {Position = UDim2.new(0,0,0,45), Size = UDim2.new(1,0,1,-45)}):Play()
                                                    end
                                                end)
                                                
                                                -- [[ MAIN TOGGLE ]] --
                                                local isOpen = false
                                                ToggleGui.MouseButton1Click:Connect(function()
                                                    if ArrowLabel then ArrowLabel:Destroy(); ArrowLabel = nil end
                                                    
                                                    isOpen = not isOpen
                                                    if isOpen then
                                                        Main.Visible = true; Main.Size = UDim2.new(0, 550, 0, 0)
                                                        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 550, 0, 320)}):Play()
                                                    else
                                                        local t = TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 550, 0, 0)})
                                                        t:Play()
                                                        t.Completed:Connect(function() Main.Visible = false end)
                                                        end
                                                        end)
                                                           
