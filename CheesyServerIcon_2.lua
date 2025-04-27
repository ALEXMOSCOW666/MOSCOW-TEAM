--CheesyManiac Server Icon Script v2.0

local scriptVersion = "2.0"
ac.debug("1. Cheesy Icon Script", 'v'..scriptVersion)
ac.debug("2. Original Source: ", "https://github.com/CheesyManiac/")

local screensize = vec2(ac.getSim().windowWidth, ac.getSim().windowHeight)
local debugFlash, debugImage, debugLines, imageMetaLoaded = false, false, false, 0
setInterval(function () debugFlash = not debugFlash end, 0.5)
ui.setAsynchronousImagesLoading(true)

-- 👇 Указываем нужные ссылки на гифки
local image_0_source = 'https://i.imgur.com/WsxqQfA.gif'  -- левая гифка
local image_1_source = 'https://i.imgur.com/ghi35Hg.gif'  -- центральная гифка

-- ⏱️ Таймер на 5 секунд для центральной гифки
local centerImageTimer = 5.0
local centerImageVisible = true

local function loadImageMeta()
    if imageMetaLoaded < 3 then
        image_0 = {
            ['src'] = ui.GIFPlayer(image_0_source),
            ['sizeX'] = ui.imageSize(image_0_source).x,
            ['sizeY'] = ui.imageSize(image_0_source).y,
            ['paddingX'] = 10,
            ['paddingY'] = 10,
            ['scale'] = 0.5
        }

        image_1 = {
            ['src'] = ui.GIFPlayer(image_1_source),
            ['sizeX'] = ui.imageSize(image_1_source).x,
            ['sizeY'] = ui.imageSize(image_1_source).y,
            ['paddingX'] = 10,
            ['paddingY'] = 10,
            ['scale'] = 0.5
        }

        imageMetaLoaded = imageMetaLoaded + 1
    end
end

local function drawdebugLines()
    ui.drawLine(vec2(0, screensize.y/2), vec2(screensize.x, screensize.y/2), rgbm.colors.red, 2)
    ui.drawText(" X-axis", vec2(0, screensize.y/2), rgbm.colors.red)
    ui.drawLine(vec2(screensize.x/2, 0), vec2(screensize.x/2, screensize.y), rgbm.colors.blue, 2)
    ui.drawText(" Y-axis", vec2(screensize.x/2, 0), rgbm.colors.blue)
end

local function positionImage(image, position, debug, scaleOverride)
    local scale = scaleOverride or image.scale
    local pos = {
        ['top_left'] =      vec2(image.paddingX, image.paddingY),
        ['top_center'] =    vec2((screensize.x/2)-(image.sizeX/2*scale), image.paddingY),
        ['top_right'] =     vec2((screensize.x)-(image.sizeX*scale)-image.paddingX, image.paddingY),
        ['center_left'] =   vec2(image.paddingX, (screensize.y/2)-(image.sizeY/2*scale)),
        ['center_center'] = vec2(screensize.x/2-(image.sizeX/2*scale)+image.paddingX, screensize.y/2-(image.sizeY/2*scale)+image.paddingY),
        ['center_right'] =  vec2(screensize.x-(image.sizeX*scale)-image.paddingX, screensize.y/2-(image.sizeY/2*scale)),
        ['bottom_left'] =   vec2(image.paddingX, screensize.y-(image.sizeY*scale)-image.paddingY),
        ['bottom_center'] = vec2(screensize.x/2-(image.sizeX/2*scale), screensize.y-(image.sizeY*scale)-image.paddingY),
        ['bottom_right'] =  vec2((screensize.x)-(image.sizeX*scale)-image.paddingX, screensize.y-(image.sizeY*scale)-image.paddingY)
    }

    if debug then
        display.rect({
            pos = pos[position] - vec2(image.paddingX, image.paddingY),
            size = vec2(ui.imageSize(image.src)*scale + vec2(image.paddingX, image.paddingY):scale(2)),
            color = rgbm(0, 0, 0, 0.5)
        })
        if debugFlash then
            display.rect({
                pos = pos[position] - vec2(1, 1),
                size = vec2(ui.imageSize(image.src)*scale) + vec2(2, 2),
                color = rgbm(1, 0, 0, 0.5)
            })
        end
    end

    display.image({
        image = image.src,
        pos = pos[position],
        size = vec2(ui.imageSize(image.src)*scale),
        color = rgbm.colors.white,
        uvStart = vec2(0, 0),
        uvEnd = vec2(1, 1)
    })
end

local creditTimer = 0.5
local creditPos = 0

function script.update(dt)
    ac.debug('Driver In Setup Menu', ac.getSim().isInMainMenu)
    if not ac.getSim().isInMainMenu then
        if creditTimer >= 0 then
            creditTimer = creditTimer - dt
        end
        creditPos = (-0.01 * 10^(-2 * creditTimer + math.log(500)/math.log(10)) + 2) * 20

        -- ⏱️ Обновление таймера для центральной гифки
        if centerImageVisible then
            centerImageTimer = centerImageTimer - dt
            if centerImageTimer <= 0 then
                centerImageVisible = false
            end
        end
    end

    loadImageMeta()
end

ui.registerOnlineExtra(ui.Icons.Bug, "Server Icon Debug", function () return true end, function ()
    if ui.checkbox("Draw Image Boundary Boxes", debugImage) then debugImage = not debugImage end
    if ui.checkbox("Draw Screen Center Lines", debugLines) then debugLines = not debugLines end
end, function (okClicked) end, ui.OnlineExtraFlags.Admin)

function script.drawUI()
    if creditTimer > 0 then
        display.rect({ pos = vec2(screensize.x/2 - 120, creditPos - 5), size = vec2(240, 40), color = rgbm(0, 0, 0, 0.5) })
        display.text({
            text = 'Server Icon Script v' .. scriptVersion .. '\n    by CheesyManiac',
            pos = vec2((screensize.x/2) - 92, creditPos),
            letter = vec2(8, 16),
            font = 'aria',
            color = rgbm.colors.white
        })
    end

    if debugLines then
        drawdebugLines()
    end

    -- 👈 Левая гифка (всегда)
    positionImage(image_0, 'center_left', debugImage)

    -- 🎯 Центральная гифка (только 5 секунд)
    if centerImageVisible then
        positionImage(image_1, 'center_center', debugImage)
    end
end
