local addonName = "GreatVault"
local dbName = "GreatVaultDB"
local addonLoadedEvent = "ADDON_LOADED"
local whiteColor = "|cFFFFFFFF"
local greatVaultFrame
local db
local icon = LibStub("LibDBIcon-1.0")
local hideIconParameter = "remove"
local showIconParameter = "add"
SLASH_VAULT_TOGGLE1 = "/gv"
SLASH_VAULT_TOGGLE2 = "/vault"

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
    type = "data source",
    text = addonName,
    icon = "Interface\\ICONS\\garrison_bronzechest",
    OnClick = function(button,buttonPressed)
        if buttonPressed == "RightButton" then
            onIconRightClick()
        else
            onIconLeftClick()
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then
            return
        end
        tooltip:AddLine(whiteColor .."Great Vault")
        tooltip:AddLine("Click to toggle the Great Vault")
        tooltip:AddLine("Right-click to lock Minimap Button")
        tooltip:AddLine(string.format("Chat Commands: %s and %s for toggle", SLASH_VAULT_TOGGLE1, SLASH_VAULT_TOGGLE2))
        tooltip:AddLine(string.format("Parameter: '%s' and '%s' for Icon", hideIconParameter, showIconParameter))
    end,
})

local defaultSavedVars = {	global = {minimap = {hide = false,},},}

function greatVault_OnEvent(self, event, ...)
    if event == addonLoadedEvent and ... == addonName then
        addMinimapIcon()
        tinsert(UISpecialFrames,"WeeklyRewardsFrame")
        self:UnregisterEvent(addonLoadedEvent)
    end
end

function addMinimapIcon()
    db = LibStub("AceDB-3.0"):New(dbName, defaultSavedVars).global
    icon:Register(addonName, LDB, db.minimap)
    if db.minimap.hide then
        icon:Show(addonName)
    end
end

SlashCmdList["VAULT_TOGGLE"] = function(msg)
    if msg == hideIconParameter then
        db.minimap.hide = true
        icon:Hide(addonName)
    elseif msg == showIconParameter then
        db.minimap.hide = false
        icon:Show(addonName)
    else
        toggleGreatVault()
    end
end

function greatVault_OnLoad(self)
    self:RegisterEvent(addonLoadedEvent)
end

function onIconRightClick()
    if db.minimap.lock then
        icon:Unlock(addonName)
    else
        icon:Lock(addonName)
    end
end

function onIconLeftClick()
    toggleGreatVault()
end

function toggleGreatVault()
    if not greatVaultFrame then
        loadGreatVaultFrame()
    end
    if greatVaultFrame:IsShown() then
        hideGreatVault()
    else
        showGreatVault()
    end
end

function loadGreatVaultFrame()
    LoadAddOn("Blizzard_WeeklyRewards")
    greatVaultFrame = WeeklyRewardsFrame
end

function showGreatVault()
    greatVaultFrame:Show()
end

function hideGreatVault()
    greatVaultFrame:Hide()
end