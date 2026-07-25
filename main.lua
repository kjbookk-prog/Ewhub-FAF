--[[
	EWEHUB - Farm A Fish Integration
	Kompatibel dengan NovaUI v1.1.0 (English Version)
]]

local NovaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kjbookk-prog/Ewhub-repo/refs/heads/main/Uipler.lua"))()

local Window = NovaUI:CreateWindow({
	Title       = "EWEHUB",
	SubTitle    = "Farm A Fish Edition",
	Theme       = "Default",
	Width       = 960,
	Height      = 600,
	Watermark   = true,
	ConfigName  = "EWEHUB_FAF_Config",
	Status      = { Online = true, Updated = true },
	LibraryName = "NovaUI",
	Version     = "v1.1.0",
	Discord     = "discord.gg/xdv74qutx5",
})

-- Tab: Farm A Fish
local FarmTab = Window:CreateTab({
	Title    = "Farm A Fish",
	Subtitle = "Select Your Executor",
	Icon     = "gamepad",
})

-- Section: Pilihan Executor
local ExecutorSection = FarmTab:CreateSection("EXECUTOR SELECTION")

-- Tombol 1: Delta
ExecutorSection:CreateButton({
	Title       = "Delta Executor",
	Description = "Run the specific EWEHUB script for Delta",
	ButtonText  = "Execute →",
	Callback    = function()
		local success, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/kjbookk-prog/Ewehub-FAF/refs/heads/main/ewehub.lua"))()
		end)
		
		if success then
			Window:Notify({
				Title    = "Success",
				Content  = "Delta script executed successfully!",
				Type     = "Success",
				Duration = 4,
			})
		else
			Window:Notify({
				Title    = "Failed",
				Content  = "Error: " .. tostring(err),
				Type     = "Error",
				Duration = 5,
			})
		end
	end,
})

-- Tombol 2: Codex
ExecutorSection:CreateButton({
	Title       = "Codex Executor",
	Description = "Run Moonkey Hub script for Codex",
	ButtonText  = "Execute →",
	Callback    = function()
		local success, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/RVNGG145/Moonkey-Hub/refs/heads/main/MoonkeyHub"))()
		end)
		
		if success then
			Window:Notify({
				Title    = "Success",
				Content  = "Codex script executed successfully!",
				Type     = "Success",
				Duration = 4,
			})
		else
			Window:Notify({
				Title    = "Failed",
				Content  = "Error: " .. tostring(err),
				Type     = "Error",
				Duration = 5,
			})
		end
	end,
})

-- Tombol 3: Lainnya (Menyusul)
ExecutorSection:CreateButton({
	Title       = "Other Executors",
	Description = "Support for other executors coming soon",
	ButtonText  = "Soon",
	Callback    = function()
		Window:Notify({
				Title    = "Information",
				Content  = "Other executors are coming soon!",
				Type     = "Info",
				Duration = 4,
		})
	end,
})

-- Notifikasi Awal
Window:Notify({
	Title    = "EWEHUB Loaded",
	Content  = "Please select your executor to begin.",
	Type     = "Info",
	Duration = 4,
})
