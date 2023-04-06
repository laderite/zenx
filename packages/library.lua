--[[
    Zen X Library
    by jsn#0499
]]

local Release = "v1.0"
local LibraryFolder = "ZenXLibrary"
local ConfigurationFolder = LibraryFolder .. "/Config"
local ConfigurationExtension = ".znx"

local ZenLibrary = {Flags = {}, Themes = {},   }

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- UI
local Zen = game:GetObjects("rbxassetid://13015216417")[1]
Zen.Menu.Visible = false
Zen.Parent = CoreGui
--[[if gethui then
	Zen.Parent = gethui()
elseif syn.protect_gui then 
	syn.protect_gui(Zen)
	Zen.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
	Zen.Parent = CoreGui:FindFirstChild("RobloxGui")
else
	Zen.Parent = CoreGui
end

if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == Zen.Name and Interface ~= Zen then
			Interface.Enabled = false
			Interface.Name = "Zen Old"
		end
	end
else
	for _, Interface in ipairs(CoreGui:GetChildren()) do
		if Interface.Name == Zen.Name and Interface ~= Zen then
			Interface.Enabled = false
			Interface.Name = "Zen Old"
		end
	end
end]]

-- Object Variables

local Camera = workspace.CurrentCamera
local Main = Zen.Menu
local Topbar = Main.Topbar
local Toolbar = Main.Toolbar
local TabHolder = Main.TabHolder

Zen.DisplayOrder = 100

local Minimised = false
local Hidden = false
local Debounce = false
local CFileName = nil
local CEnabled = false
local firstTab
local firstTabName

local function AddDraggingFunctionality(DragPoint, Main)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		DragPoint.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				MousePos = Input.Position
				FramePos = Main.Position

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		DragPoint.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input
			end
		end)
		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
			end
		end)
	end)
end   

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

-- Define the color range you want to loop through
local colorRange = {
    Color3.fromRGB(255, 0, 0), -- Red
    Color3.fromRGB(255, 255, 0), -- Yellow
    Color3.fromRGB(0, 255, 0), -- Green
    Color3.fromRGB(0, 255, 255), -- Cyan
    Color3.fromRGB(0, 0, 255), -- Blue
    Color3.fromRGB(255, 0, 255) -- Magenta
}

-- Find all descendants of the Zen Script Hub Library
local descendants = game.CoreGui['Zen Script Hub Library']:GetDescendants()

-- Create a table to hold frames with specified transparency values
local framesToChange = {}

-- Loop through the descendants and check the transparency of frames
for _, descendant in pairs(descendants) do
    if descendant:IsA("Frame") and descendant.Name == "ToggleBckg" or descendant.Name == "Progress" then
        table.insert(framesToChange, descendant)
    end
end

-- Loop through the frames and set their background colors to the RGB loop
task.spawn(function()
while wait() do
    for i, frame in pairs(framesToChange) do
        frame.BackgroundColor3 = colorRange[(i-1) % #colorRange + 1]
    end
end
end)

function hideMenu()
    Debounce = true
    
    TweenService:Create(Topbar.Close.ImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 1
    }):Play()
    TweenService:Create(Topbar.Close.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 1}):Play()

    TweenService:Create(Topbar.Minimize.ImageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 1
    }):Play()
    TweenService:Create(Topbar.Minimize.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 1}):Play()

    TweenService:Create(Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()

    TweenService:Create(Toolbar.FirstSeperator, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Toolbar.SecondSeperator, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()

    TweenService:Create(Toolbar.Menu.Seperator, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Toolbar.Menu.ImageButton, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()


    TweenService:Create(Toolbar.TabDisplay.Seperator, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Toolbar.TabDisplay.Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()


    TweenService:Create(Toolbar.Settings.Seperator, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Toolbar.Settings.ImageButton, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()

    for _, shadow in ipairs(Main.shadowHolder:GetChildren()) do
        TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
    end

    local tweenParams = {
        Quint = Enum.EasingStyle.Quint,
        BackgroundTransparency = 1,
        ImageColor3 = Color3.fromRGB(134, 134, 134),
        ImageTransparency = 1,
        TextTransparency = 1,
        Transparency = 1,
        Size = UDim2.new(1, 0, 0, 1),
        OtherSize = UDim2.new(0, 1, 0, 36)
    }
    
    local function hideContainerElements()
        for _, container in pairs(Main:GetChildren()) do
            if container.Name == "Container" then
                for _, side in pairs{"Left", "Right"} do
                    local sideContainer = container[side]
                    for _, frame in pairs(sideContainer:GetChildren()) do
                        if frame.ClassName == "Frame" and frame.Name ~= "ExampleSection" then
                            frame.Visible = false
                            TweenService:Create(frame.Title.TextLabel, TweenInfo.new(0.7, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()
                            for _, element in pairs(frame.Holder:GetChildren()) do
                                if element.ClassName ~= "UIListLayout" then
                                    TweenService:Create(element, TweenInfo.new(0.7, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
                                    for _, child in pairs(element:GetDescendants()) do
                                        local property = child.ClassName == "UIStroke" and "Transparency" or
                                            child.ClassName == "ImageLabel" and "ImageTransparency" or
                                            child.ClassName == "TextLabel" and "TextTransparency" or child.ClassName == "TextBox" and "TextTransparency" or 
                                            child.Name == "Progress" and "BackgroundTransparency" or
                                            child.Name == "ToggleBckg" and "BackgroundTransparency" or
                                            child.Name == "Bar" and "BackgroundTransparency" or
                                            child.Name == "Circle" and "BackgroundTransparency"
                                        if property then
                                            TweenService:Create(child, TweenInfo.new(0.7, tweenParams.Quint), {[property] = tweenParams[property]}):Play()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    hideContainerElements()
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Main.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
    TweenService:Create(Topbar, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Toolbar, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()

    wait(0.5)
    Main.Visible = false
    Minimised = true
    Debounce = false
end


function unHideMenu(firstTime)
    Debounce = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Visible = true
    Main.ExampleContainer.Visible = false
    local tweenParams = {
        Quint = Enum.EasingStyle.Quint,
        BackgroundTransparency = 0,
        ImageColor3 = Color3.fromRGB(134, 134, 134),
        ImageTransparency = 0,
        TextTransparency = 0,
        Transparency = 0,
        Size = UDim2.new(1, 0, 0, 1),
        OtherSize = UDim2.new(0, 1, 0, 36)
    }

    TweenService:Create(Main, TweenInfo.new(0.3, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    wait(0.1)

    TweenService:Create(Topbar.Close.ImageLabel, TweenInfo.new(0.7, tweenParams.Quint), {ImageColor3 = tweenParams.ImageColor3, ImageTransparency = tweenParams.ImageTransparency}):Play()
    TweenService:Create(Topbar.Close.UIStroke, TweenInfo.new(0.7, tweenParams.Quint), {Transparency = tweenParams.Transparency}):Play()
    TweenService:Create(Topbar.Minimize.ImageLabel, TweenInfo.new(0.7, tweenParams.Quint), {ImageColor3 = tweenParams.ImageColor3, ImageTransparency = tweenParams.ImageTransparency}):Play()
    TweenService:Create(Topbar.Minimize.UIStroke, TweenInfo.new(0.7, tweenParams.Quint), {Transparency = tweenParams.Transparency}):Play()
    TweenService:Create(Topbar.Title, TweenInfo.new(0.7, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()
    TweenService:Create(Toolbar.FirstSeperator, TweenInfo.new(1, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    TweenService:Create(Toolbar.SecondSeperator, TweenInfo.new(1, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    TweenService:Create(Toolbar.Menu.Seperator, TweenInfo.new(0.5, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    TweenService:Create(Toolbar.TabDisplay.Seperator, TweenInfo.new(0.5, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    TweenService:Create(Toolbar.Settings.Seperator, TweenInfo.new(0.5, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()

    TweenService:Create(Main.UIStroke, TweenInfo.new(0.5, tweenParams.Quint), {Transparency = tweenParams.Transparency}):Play()
    TweenService:Create(Topbar, TweenInfo.new(0.5, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    TweenService:Create(Toolbar, TweenInfo.new(0.5, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    TweenService:Create(Topbar.Title, TweenInfo.new(0.5, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()

    task.spawn(function()
        TweenService:Create(Toolbar.Menu.Seperator, TweenInfo.new(0.5, tweenParams.Quint), {Size = tweenParams.OtherSize}):Play()
        TweenService:Create(Toolbar.Menu.ImageButton, TweenInfo.new(0.5, tweenParams.Quint), {ImageTransparency = tweenParams.ImageTransparency}):Play()
        task.wait(0.1)

        TweenService:Create(Toolbar.TabDisplay.Seperator, TweenInfo.new(0.5, tweenParams.Quint), {Size = tweenParams.OtherSize}):Play()
        TweenService:Create(Toolbar.TabDisplay.Title, TweenInfo.new(0.5, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()
        task.wait(0.1)

        TweenService:Create(Toolbar.Settings.Seperator, TweenInfo.new(0.5, tweenParams.Quint), {Size = tweenParams.OtherSize}):Play()
        TweenService:Create(Toolbar.Settings.ImageButton, TweenInfo.new(0.5, tweenParams.Quint), {ImageTransparency = tweenParams.ImageTransparency}):Play()

        for _, v in pairs(Main.shadowHolder:GetChildren()) do
            TweenService:Create(v, TweenInfo.new(0.7, tweenParams.Quint), {ImageTransparency = 0.88}):Play()
        end
    end)

    if firstTime then
        if firstTab then
            firstTab.Visible = true
            Toolbar.TabDisplay.Title.Text = firstTabName
        end
        TweenService:Create(Toolbar.FirstSeperator, TweenInfo.new(1, tweenParams.Quint), {Size = tweenParams.Size}):Play()
        TweenService:Create(Toolbar.SecondSeperator, TweenInfo.new(1, tweenParams.Quint), {Size = tweenParams.Size}):Play()
        wait(0.1)
        TweenService:Create(Topbar.Title, TweenInfo.new(0.7, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()
        wait(0.1)
        TweenService:Create(Topbar.Minimize.ImageLabel, TweenInfo.new(0.7, tweenParams.Quint), {ImageColor3 = tweenParams.ImageColor3}):Play()
        TweenService:Create(Topbar.Minimize.ImageLabel, TweenInfo.new(0.7, tweenParams.Quint), {ImageTransparency = tweenParams.ImageTransparency}):Play()
        TweenService:Create(Topbar.Minimize.UIStroke, TweenInfo.new(0.7, tweenParams.Quint), {Transparency = tweenParams.Transparency}):Play()
        wait(0.1)
        TweenService:Create(Topbar.Close.ImageLabel, TweenInfo.new(0.7, tweenParams.Quint), {ImageColor3 = tweenParams.ImageColor3}):Play()
        TweenService:Create(Topbar.Close.ImageLabel, TweenInfo.new(0.7, tweenParams.Quint), {ImageTransparency = tweenParams.ImageTransparency}):Play()
        TweenService:Create(Topbar.Close.UIStroke, TweenInfo.new(0.7, tweenParams.Quint), {Transparency = tweenParams.Transparency}):Play()
    end

    local function showContainerElements()
        for _, container in pairs(Main:GetChildren()) do
            if container.Name == "Container" then
                for _, side in pairs{"Left", "Right"} do
                    local sideContainer = container[side]
                    for _, frame in pairs(sideContainer:GetChildren()) do
                        if frame.ClassName == "Frame" and frame.Name ~= "ExampleSection" then
                            frame.Visible = true
                            TweenService:Create(frame.Title.TextLabel, TweenInfo.new(0.7, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()
                            for _, element in pairs(frame.Holder:GetChildren()) do
                                if element.ClassName ~= "UIListLayout" then
                                    TweenService:Create(element, TweenInfo.new(0.7, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
                                    for _, child in pairs(element:GetDescendants()) do
                                        local property = child.ClassName == "UIStroke" and "Transparency" or
                                            child.ClassName == "ImageLabel" and "ImageTransparency" or
                                            child.ClassName == "TextLabel" and "TextTransparency" or child.ClassName == "TextBox" and "TextTransparency" or 
                                            child.Name == "Progress" and "BackgroundTransparency" or
                                            child.Name == "ToggleBckg" and "BackgroundTransparency" or
                                            child.Name == "Bar" and "BackgroundTransparency" or
                                            child.Name == "Circle" and "BackgroundTransparency"
                                        if property then
                                            TweenService:Create(child, TweenInfo.new(0.7, tweenParams.Quint), {[property] = tweenParams[property]}):Play()
                                        end
                                    end
                                end
                                task.wait(0.02)
                            end
                        end
                    end
                end
            end
        end
    end
    showContainerElements()


    wait(0.5)
	Minimised = false
	Debounce = false
end

function maximizeMenu()
end

function minimizeMenu()
end

function openTabHolder()
    Debounce = true
    TabHolder.BackgroundTransparency = 1
    TabHolder.MainHolder.Size = UDim2.new(0, 1, 0, 392)
    TabHolder.Visible = true

    local tweenParams = {
        Quint = Enum.EasingStyle.Quint,
        BackgroundTransparency = 0,
        TextTransparency = 0,
        Size = UDim2.new(0, 200, 0, 392),
    }

    TweenService:Create(TabHolder, TweenInfo.new(0.5, tweenParams.Quint), {BackgroundTransparency = 0.55}):Play()
    TweenService:Create(TabHolder.MainHolder, TweenInfo.new(0.3, tweenParams.Quint), {Size = tweenParams.Size}):Play()
    wait(0.2)
    for _,v in pairs(TabHolder.MainHolder.Holder:GetChildren()) do
        if v.ClassName == "TextButton" then
            TweenService:Create(v, TweenInfo.new(0.3, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
            TweenService:Create(v.UIStroke, TweenInfo.new(0.3, tweenParams.Quint), {Transparency = tweenParams.TextTransparency}):Play()
            TweenService:Create(v.TextLabel, TweenInfo.new(0.3, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()
        end
        task.wait(0.05)
    end

    wait(0.3)
    Debounce = false
end

function closeTabHolder()    
    Debounce = true
    local tweenParams = {
        Quint = Enum.EasingStyle.Quint,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        Size = UDim2.new(0, 1, 0, 392),
    }
    
    for _,v in pairs(TabHolder.MainHolder.Holder:GetChildren()) do
        if v.ClassName == "TextButton" then
            TweenService:Create(v, TweenInfo.new(0.3, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
            TweenService:Create(v.UIStroke, TweenInfo.new(0.3, tweenParams.Quint), {Transparency = tweenParams.BackgroundTransparency}):Play()
            TweenService:Create(v.TextLabel, TweenInfo.new(0.3, tweenParams.Quint), {TextTransparency = tweenParams.TextTransparency}):Play()
        end
    end
    
    wait(0.2)
    TweenService:Create(TabHolder.MainHolder, TweenInfo.new(0.3, tweenParams.Quint), {Size = tweenParams.Size}):Play()
    wait(0.2)
    TweenService:Create(TabHolder, TweenInfo.new(0.3, tweenParams.Quint), {BackgroundTransparency = tweenParams.BackgroundTransparency}):Play()
    wait(0.3)
    TabHolder.Visible = false
    Debounce = false
end

function ZenLibrary:CreateMenu(Settings)
    Main.BackgroundTransparency = 1
    Topbar.BackgroundTransparency = 1
    Topbar.Title.Text = Settings.Name
    Topbar.Title.TextTransparency = 1

    Topbar.Close.UIStroke.Transparency = 1
    Topbar.Close.ImageLabel.ImageTransparency = 1
    Topbar.Minimize.UIStroke.Transparency = 1
    Topbar.Minimize.ImageLabel.ImageTransparency = 1

    Toolbar.BackgroundTransparency = 1
    Toolbar.FirstSeperator.Size = UDim2.new(0,0,0,1)
    Toolbar.SecondSeperator.Size = UDim2.new(0,0,0,1)
    Toolbar.Menu.Seperator.Size = UDim2.new(0,1,0,0)
    Toolbar.Menu.ImageButton.ImageTransparency = 1

    Toolbar.Settings.Seperator.Size = UDim2.new(0,1,0,0)
    Toolbar.Settings.ImageButton.ImageTransparency = 1 

    Toolbar.TabDisplay.Seperator.Size = UDim2.new(0,1,0,0)
    Toolbar.TabDisplay.Title.TextTransparency = 1

    TabHolder.Visible = false

    local ExampleSection = Main.ExampleContainer.Left.ExampleSection
    ExampleSection.Visible = false

    Main.Position = UDim2.new(0.5,0,0.5,0)
    Main.Visible = false

    pcall(function()
		if not Settings.ConfigurationSaving.FileName then
			Settings.ConfigurationSaving.FileName = tostring(game.PlaceId)
		end
		if not isfolder(LibraryFolder.."/".."Configuration Folders") then
			
		end
		if Settings.ConfigurationSaving.Enabled == nil then
			Settings.ConfigurationSaving.Enabled = false
		end
		CFileName = Settings.ConfigurationSaving.FileName
		ConfigurationFolder = Settings.ConfigurationSaving.FolderName or ConfigurationFolder
		CEnabled = Settings.ConfigurationSaving.Enabled

		if Settings.ConfigurationSaving.Enabled then
			if not isfolder(ConfigurationFolder) then
				makefolder(ConfigurationFolder)
			end	
		end
	end)

    -- Tab
    local tabHandler = {}

    function tabHandler:Load()
        unHideMenu(true)
    end
    function tabHandler:CreateTab(Name)
        TabHolder.MainHolder.Holder.Example.Visible = false
        local TabButton = TabHolder.MainHolder.Holder.Example:Clone()
        TabButton.Name = Name
        TabButton.TextLabel.Text = Name
        TabButton.BackgroundTransparency = 1
        TabButton.TextLabel.TextTransparency = 1
        TabButton.UIStroke.Transparency = 1
        TabButton.Parent = TabHolder.MainHolder.Holder
        TabButton.Visible = true

        local Container = Main.ExampleContainer:Clone()
        Container.Name = "Container"
        Container.Parent = Main
        Container.Visible = false

        if firstTab == nil then
            firstTab = Container
            firstTabName = Name
        end

        TabButton.MouseButton1Click:Connect(function()
            if Debounce then return end
            for _,v in pairs(Main:GetChildren()) do
                if v.Name == "Container" then
                    v.Visible = false
                end
            end
            Toolbar.TabDisplay.Title.Text = TabButton.TextLabel.Text
            Container.Visible = true
            closeTabHolder()
        end)
        
        local sectionHandler = {}

        function sectionHandler:CreateSection(SectionSettings)
            local ExampleSection = Main.ExampleContainer.Left.ExampleSection
            local Section = ExampleSection:Clone()
            
            Section.Name = SectionSettings.Name
            Section.Title.TextLabel.Text = SectionSettings.Name
            if SectionSettings.Side == "Left" then 
                Section.Parent = Container.Left 
            else 
                Section.Parent = Container.Right 
            end
            for _,v in pairs(Section.Holder:GetChildren()) do
                if v.ClassName ~= "UIListLayout" then
                    v:Destroy()
                end
            end

            local elementHandler = {}

            function elementHandler:CreateSlider(sliderHandler)
                local Dragging = false
                -- title,min,max,start,inc,callback
                local min = sliderHandler.Min
                local max = sliderHandler.Max
                local start = sliderHandler.Default
                local inc = sliderHandler.Increment
                local suffix = sliderHandler.Suffix
            
                local Slider = ExampleSection.Holder.Slider:Clone()
                Slider.Name = sliderHandler.Name
                Slider.Title.Text = sliderHandler.Name
                Slider.Bar.BackgroundTransparency = 1
                Slider.Bar.Progress.BackgroundTransparency = 1
                Slider.Bar.Progress.Circle.BackgroundTransparency = 1
                Slider.BackgroundTransparency = 1
                Slider.UIStroke.Transparency = 1
                Slider.Title.TextTransparency = 1
                Slider.Value.TextTransparency = 1
                Slider.Visible = true
                Slider.Parent = Section.Holder
            
                local Slider,SliderMain = {Value = start}, Slider
                local value = SliderMain:FindFirstChild('Value')
                local dragging = false
            
                local function move(Input)
                    local XSize = math.clamp((Input.Position.X - SliderMain.Bar.AbsolutePosition.X) / SliderMain.Bar.AbsoluteSize.X, 0, 1)
                    local Increment = inc and (max / ((max - min) / (inc * 4))) or (max >= 50 and max / ((max - min) / 4)) or (max >= 25 and max / ((max - min) / 2)) or (max / (max - min))
                    local SizeRounded = UDim2.new((math.round(XSize * ((max / Increment) * 4)) / ((max / Increment) * 4)), 0, 1, 0) 
                    TweenService:Create(SliderMain.Bar.Progress,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = SizeRounded}):Play() 
                    local Val = math.round((((SizeRounded.X.Scale * max) / max) * (max - min) + min) * 20) / 20
                    value.Text = tostring(Val) .. suffix
                    Slider.Value = Val
                    sliderHandler.Callback(Slider.Value)
                end
            
                SliderMain.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
                SliderMain.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                game:GetService("UserInputService").InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end end)
            
                function Slider:Set(val)
                    Slider.Value = val
                    local a = tostring(val and (val / max) * (max - min) + min) or 0
                    value.Text = tostring(a) .. suffix
                    SliderMain.Bar.Progress.Size = UDim2.new((val or 0 - min) / (max - min), 0, 1, 0)
                    sliderHandler.Callback(Slider.Value)
                end	
            
                Slider:Set(start)
                return Slider
            end

            function elementHandler:CreateToggle(toggleHandler)

                local Toggle = ExampleSection.Holder.Toggle:Clone()
                Toggle.Name = toggleHandler.Name
                Toggle.TextLabel.Text = toggleHandler.Name
                Toggle.Status.ToggleBckg.BackgroundTransparency = 1
                Toggle.Status.ToggleBckg.UIStroke.Transparency = 1
                Toggle.BackgroundTransparency = 1
                Toggle.UIStroke.Transparency = 1
                Toggle.TextLabel.TextTransparency = 1
                Toggle.Visible = true
                Toggle.Parent = Section.Holder

                if not toggleHandler.CurrentValue then
                    Toggle.Status.ToggleBckg.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
                    Toggle.Status.ToggleBckg.UIStroke.Transparency = 0
                    Toggle.Status.ToggleBckg.UIStroke.Color = Color3.fromRGB(50, 50, 50)
                else
                    Toggle.Status.ToggleBckg.BackgroundColor3 = Color3.fromRGB(0, 213, 255)
                    Toggle.Status.ToggleBckg.UIStroke.Transparency = 1
                end

                Toggle.MouseEnter:Connect(function()
                    game:GetService('TweenService'):Create(Toggle, TweenInfo.new(0.6), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play()
                end)
    
                Toggle.MouseLeave:Connect(function()
                    game:GetService('TweenService'):Create(Toggle, TweenInfo.new(0.6), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                end)

                Toggle.MouseButton1Click:Connect(function()
                    if toggleHandler.CurrentValue then
                        toggleHandler.CurrentValue = false
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(29, 29, 29)}):Play()
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg.UIStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg.UIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
                    else
                        toggleHandler.CurrentValue = true
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 213, 255)}):Play()
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg.UIStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
                    end

                    local Success, Response = pcall(function()
                        toggleHandler.Callback(toggleHandler.CurrentValue)
                    end)
                    if not Success then
                        TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(40, 0, 0)}):Play()
                        TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(76, 0, 0)}):Play()
                        Toggle.TextLabel.Text = "Callback Error"
                        warn("» Zen X Callback Error ("..TextboxSettings.Name..")\n" ..tostring(Response))
                        wait(1)
                        Toggle.TextLabel.Text = toggleHandler.Name
                        TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() -- Still
                        TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                    end
                end)

                function toggleHandler:Set(newValue)
                    if newValue then
                        toggleHandler.CurrentValue = false
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(29, 29, 29)}):Play()
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg.UIStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg.UIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
                    else
                        toggleHandler.CurrentValue = true
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 213, 255)}):Play()
                        game:GetService('TweenService'):Create(Toggle.Status.ToggleBckg.UIStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
                    end

                    local Success, Response = pcall(function()
                        toggleHandler.Callback(toggleHandler.CurrentValue)
                    end)
                    if not Success then
                        TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(40, 0, 0)}):Play()
                        TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(76, 0, 0)}):Play()
                        Toggle.TextLabel.Text = "Callback Error"
                        warn("» Zen X Callback Error ("..TextboxSettings.Name..")\n" ..tostring(Response))
                        wait(1)
                        Toggle.TextLabel.Text = toggleHandler.Name
                        TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() -- Still
                        TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                    end
                end

                return toggleHandler
            end

            function elementHandler:CreateTextbox(TextboxSettings)
                local textBoxHandler = {}
                local errored = false
                local Textbox = ExampleSection.Holder.Textbox:Clone()

                Textbox.Name = TextboxSettings.Name
                Textbox.TextLabel.Text = TextboxSettings.Name
                Textbox.BackgroundTransparency = 1
                Textbox.UIStroke.Transparency = 1
                Textbox.Status.TextBox.UIStroke.Transparency = 1
                Textbox.TextLabel.TextTransparency = 1
                Textbox.Visible = true
                Textbox.Parent = Section.Holder

                Textbox.MouseEnter:Connect(function()
                    game:GetService('TweenService'):Create(Textbox, TweenInfo.new(0.6), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play()
                end)
    
                Textbox.MouseLeave:Connect(function()
                    game:GetService('TweenService'):Create(Textbox, TweenInfo.new(0.6), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                end)
    
                Textbox.Status.TextBox.FocusLost:Connect(function()
                    local Success, Response = pcall(function()
                        TextboxSettings.Callback(Textbox.Status.TextBox.Text)
                    end)
                    if not Success then
                        TweenService:Create(Textbox, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(40, 0, 0)}):Play() -- ERROR
                        TweenService:Create(Textbox.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(76, 0, 0)}):Play()
                        TweenService:Create(Textbox.Status.TextBox.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(76, 0, 0)}):Play()
                        Textbox.TextLabel.Text = "Callback Error"
                        warn("» Zen X Callback Error ("..TextboxSettings.Name..")\n" ..tostring(Response))
                        errored = true
                        wait(1)
                        errored = false
                        Textbox.TextLabel.Text = TextboxSettings.Name
                        TweenService:Create(Textbox, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() -- Still
                        TweenService:Create(Textbox.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                        TweenService:Create(Textbox.Status.TextBox.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                    else
                        if TextboxSettings.RemoveTextAfterFocusLost then
                            Textbox.Status.TextBox.Text = ""
                        end
                    end
                end)
            end

            function elementHandler:CreateButton(ButtonSettings)
                local buttonHandler = {}
                local hovering = false
                local errored = false

                local Button = ExampleSection.Holder.Button:Clone()

                Button.Name = ButtonSettings.Name
                Button.TextLabel.Text = ButtonSettings.Name
                Button.BackgroundTransparency = 1
                Button.UIStroke.Transparency = 1
                Button.Status.ActualThing.ImageLabel.ImageTransparency = 1
                Button.TextLabel.TextTransparency = 1
                Button.Visible = true
                Button.Parent = Section.Holder

                Button.MouseButton1Click:Connect(function()
                    if errored then return end
                    local Success, Response = pcall(ButtonSettings.Callback)
                    if not Success then
                        TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(40, 0, 0)}):Play() -- ERROR
                        TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(76, 0, 0)}):Play()
                        Button.TextLabel.Text = "Callback Error! Check Console"
                        warn("» Zen X Callback Error ("..ButtonSettings.Name..")\n" ..tostring(Response))
                        errored = true
                        wait(1)
                        errored = false
                        Button.TextLabel.Text = ButtonSettings.Name
                        TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play() -- Still
                        TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                    else
                        TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(49, 49, 49)}):Play() -- Clicked
                        TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                        wait(0.2)
                        if not hovering then 
                            TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                        else
                            TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play() -- Hover
                        end
                    end
                end)
    
                Button.MouseEnter:Connect(function()
                    if errored then return end
                    hovering = true
                    TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play()
                    TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                end)
    
                Button.MouseLeave:Connect(function()
                    if errored then return end
                    hovering = false
                    TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                    TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Color = Color3.fromRGB(50, 50, 50)}):Play()
                end)
    
                function buttonHandler:Set(NewButton)
                    Button.Title.Text = NewButton
                    Button.Name = NewButton
                end
    
                return buttonHandler
            end

            return elementHandler
        end

        return sectionHandler
    end

    AddDraggingFunctionality(Topbar,Main)

    return tabHandler
end

Toolbar.Menu.ImageButton.MouseButton1Click:Connect(function()
    if Debounce then return end
    if TabHolder.Visible then
        closeTabHolder()
    else
        openTabHolder()
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if (input.KeyCode == Enum.KeyCode.RightShift and not processed) then
		if Debounce then return end
		if Hidden then
			Hidden = false
			unHideMenu()
		else
			Hidden = true
			hideMenu()
		end
	end
end)

return ZenLibrary

--[[local men = ZenLibrary:CreateMenu({
   Name = "Zen Example Window",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub 2"
   },
})

local taawb = men:CreateTab('Main')
local taawb1 = men:CreateTab('Combat')
local taawb2 = men:CreateTab('Local Player / Character')
local taawb3 = men:CreateTab('Settings')

local sec = taawb:CreateSection({
    Name = "Buttons",
    Side = "Left"
})

local sec2 = taawb:CreateSection({
    Name = "Other Buttons",
    Side = "Right"
})

local se3c = taawb1:CreateSection({
    Name = "Combat Buttons",
    Side = "Left"
})

sec:CreateButton({
    Name = "Infinite Money",
    Callback = function(v)
        workspace.adadwd:Destroy()
    end
})
sec:CreateToggle({
    Name = "Auto Farm",
    Callback = function(v)
        print(v)
    end
})
sec:CreateTextbox({
    Name = "Infinite Stamina",
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        print('textbox: ' .. v)
    end
})
sec:CreateSlider({
    Name = "Infinite Gems",
    Suffix = "",
    Min = 100,
    Max = 1000,
    Default = 100,
    Increment = 100,
    Callback = function(v)
        print('value is: ' .. v)
    end
})

sec2:CreateButton({Name = "Infinite Money 2 "})
sec2:CreateButton({Name = "Infinite Stamina 2 "})
sec2:CreateButton({Name = "Infinite Gems 2 "})

se3c:CreateButton({Name = "Infinite Money 2 "})
se3c:CreateButton({Name = "Infinite Stamina 2 "})
se3c:CreateButton({Name = "Infinite Gems 2 "})

men:Load()]]

