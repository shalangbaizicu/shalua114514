local WHITELIST = {
    [8673199150] = true,
}

local OrionLib
local success, err = pcall(function()
    OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shalangbaizicu/sl/main/shaluaui3.0.lua"))()
end)
if not success or not OrionLib then
    warn("Orion库加载失败: " .. (err or "未知错误"))
    return
end

-- 服务与变量初始化
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- 白名单验证
if not WHITELIST[player.UserId] then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "未授权访问",
            Text = "您的ID不在白名单中",
            Duration = 5,
            Icon = "rbxassetid://9108657181"
        })
    end)
    
    if WHITELIST[player.UserId] then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "未授权访问",
            Text = "您的ID不在白名单中",
            Duration = 5,
            Icon = "rbxassetid://9108657181"
        })
    end)
    
    local RestrictWindow = OrionLib:MakeWindow({
        Name = "访问受限",
        Theme = "Dark",
        Icon = "rbxassetid://9108657181"
    })
    local InfoTab = RestrictWindow:MakeTab({Name = "权限不足"})
    InfoTab:AddParagraph("提示", "请联系管理员添加白名单")
    InfoTab:AddParagraph("您的ID", tostring(player.UserId))
    OrionLib:Init()
    return
end

-- 工具函数：创建圆角
local function makeRound(obj, radius)
    if obj and obj:IsA("GuiObject") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = radius or UDim.new(0.5, 0)
        corner.Parent = obj
    end
end

-- 创建主窗口
local Window = OrionLib:MakeWindow({
    Name = "版本选择",
    SaveConfig = true,
    IntroText = "搜索白名单已完成",
    Theme = "FlatBlue",
    Icon = "rbxassetid://4483345998"
})

-- 欢迎通知
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "版本选择",
        Text = "已就绪",
        Duration = 4,
        Icon = "rbxassetid://4483345998"
    })
end)

-- 作者信息标签页
local AuthorTab = Window:MakeTab({Name = "作者信息", Icon = "rbxassetid://4483345998"})
AuthorTab:AddParagraph("作者", "砂狼")

-- 圆形按钮生成器
local function addRoundButton(tab, config)
    local btn = tab:AddButton(config)
    if btn.Instance and btn.Instance:IsA("GuiButton") then
        btn.Instance.Size = UDim2.new(0, 120, 0, 36)
        makeRound(btn.Instance)
        
        local hover = Instance.new("UIScale")
        hover.Scale = 1
        hover.Parent = btn.Instance
        
        local enterConn = btn.Instance.MouseEnter:Connect(function() hover.Scale = 1.05 end)
        local leaveConn = btn.Instance.MouseLeave:Connect(function() hover.Scale = 1 end)
        
        btn.Instance.AncestryChanged:Connect(function(_, parent)
            if not parent then
                enterConn:Disconnect()
                leaveConn:Disconnect()
            end
        end)
    end
    return btn
end

-- 玩家信息标签页
local PlayerTab = Window:MakeTab({Name = "玩家信息", Icon = "rbxassetid://4483345998"})
local executorName = "未知"
pcall(function() executorName = identifyexecutor() or "未知" end)

PlayerTab:AddParagraph("用户名", player.Name)
PlayerTab:AddParagraph("用户ID", tostring(player.UserId))
PlayerTab:AddParagraph("注入器", executorName)
PlayerTab:AddParagraph("服务器ID", tostring(game.GameId))
PlayerTab:AddParagraph("白名单状态", "<font color='green'>已授权</font>")

local ScriptCenterTab = Window:MakeTab({Name = "版本选择", Icon = "rbxassetid://4483346000"})

addRoundButton(ScriptCenterTab, {
    Name = "加载V1",
    Callback = function()
        OrionLib:MakeNotification({Name = "提示", Content = "正在加载...", Time = 3})
        task.spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/shalangbaizicu/shalua114514/main/shalang7.0.lua", true))()
            end)
            if success then
                OrionLib:MakeNotification({Name = "成功", Content = "加载完成", Time = 3})
            else
                OrionLib:MakeNotification({Name = "失败", Content = "错误: " .. err, Time = 3})
            end
        end)
    end,
    Color = Color3.fromRGB(123, 104, 238)
})