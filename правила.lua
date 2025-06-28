local storage = ac.storage({
    dontShowAgain = false
})

local Image = "content/cars/mt_toyota_chaser_jzx100/texture/flames/rules.png"

script.dontShowAgain = storage.dontShowAgain
script.checkboxValue = false
script.hideBanner = false

function script.drawUI()
    if script.hideBanner or script.dontShowAgain then return end

    local imgSize = vec2(1536, 1024) -- You can adjust this to fit your image size.
    local buttonSize = vec2(80, 25)
    local winSize = imgSize
    local screenSize = ui.windowSize()
    local centerPos = (screenSize - winSize) / 2

    ui.transparentWindow("WelcomeBanner", centerPos, winSize, function()
        ui.drawImage(Image, vec2(0, 0), imgSize)

        local cbPos = vec2(40, imgSize.y - 45)
        local cbSize = vec2(25, 25)
        ui.drawRect(cbPos, cbPos + cbSize, rgbm(1, 0.5, 0.8, 1))
        if script.checkboxValue then
            ui.setCursor(cbPos + vec2(0, 0))
            ui.pushFont(ui.Font.Title)
            ui.text("☑️")
            ui.popFont()
        end
        ui.setCursor(cbPos + vec2(30, 5))
        ui.text("Больше не показывать")
        if ui.rectHovered(cbPos, cbPos + cbSize) and ui.mouseClicked(0) then
            script.checkboxValue = not script.checkboxValue
        end

        local buttonX = (imgSize.x - buttonSize.x) / 2
        local buttonY = imgSize.y - buttonSize.y - 20
        local buttonPos = vec2(buttonX, buttonY)
        ui.drawRect(buttonPos, buttonPos + buttonSize, rgbm(1, 0.5, 0.8, 1))
        local label = "Принять"
        local textSize = ui.measureText(label)
        local textPos = buttonPos + (buttonSize - textSize) / 2
        ui.setCursor(textPos)
        ui.text(label)
        if ui.rectHovered(buttonPos, buttonPos + buttonSize) and ui.mouseClicked(0) then
            if script.checkboxValue then
                storage.dontShowAgain = true
                script.dontShowAgain = true
            else
                storage.dontShowAgain = false
                script.dontShowAgain = false
            end
            script.hideBanner = true
        end
    end
end
