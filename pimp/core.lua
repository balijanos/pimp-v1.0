-- pimp.core.lua
--*********************************************************************************************
--
-- ====================================================================
-- Core functions for Pencil imported pages
-- ====================================================================
--
-- File: pimp.core.lua
--
-- (c) 2018-19, IT-Gears.hu
-- 
-- Author: Janos Bali
--
-- Version 1.2
--
--*********************************************************************************************
local widget = require "widget" 
local composer = require "composer"
local json = require "json"

mIcon = require "fonts.codepoints"

local function optCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else 
        copy = orig
    end
    return copy
end

local cbPencilCore = {}

local pimpDir

cbPencilCore.copy = optCopy

function cbPencilCore.setDir(dirName)
  pimpDir = dirName
end

local appPrefix = ""

function cbPencilCore.setPrefix(prefix)
  appPrefix = prefix.."/"
end

-- ***************************************************************************************** --

function cbPencilCore.newRect(options)
  local obj
  local opt = optCopy(options)
  if opt.cornerRadius == 0 then
    -- obj = display.newRect(opt.x + opt.width/2, opt.y + opt.height/2, opt.width, opt.height)
    obj = display.newRect(opt.x, opt.y, opt.width, opt.height)
  else
    -- obj = display.newRoundedRect(opt.x + opt.width/2, opt.y + opt.height/2, opt.width, opt.height, opt.cornerRadius)
    obj = display.newRoundedRect(opt.x, opt.y, opt.width, opt.height, opt.cornerRadius)
  end
  obj.anchorX = 0
  obj.anchorY = 0
  obj.strokeWidth = opt.strokeWidth
  obj:setFillColor(unpack(opt.fillColor))
  obj:setStrokeColor(unpack(opt.strokeColor))
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  if opt.reference then
    obj.isHitTestable = true
    obj:addEventListener("touch",
      function(event)
        if event.phase=="ended" then
          composer.gotoScene(opt.reference)
        end
        return true
      end
    )
  end
  return obj
end

function cbPencilCore.newCircle(options)
  local obj
  local opt = optCopy(options)
  obj = display.newCircle(opt.x + opt.radius, opt.y + opt.radius, opt.radius)
  obj.strokeWidth = opt.strokeWidth
  obj:setFillColor(unpack(opt.fillColor))
  obj:setStrokeColor(unpack(opt.strokeColor))
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  return obj
end

function cbPencilCore.newText(options)
  local obj
  local opt = optCopy(options)
  
  obj = display.newText(opt)
  obj.x = opt.x
  obj.y = opt.y
  obj.anchorX = 0
  obj.anchorY = 0
  
  if opt.align=="left" then
    obj.anchorX = 0
  elseif opt.align=="center" then
    obj.anchorX = 0.5
    obj.x = opt.x + opt.width/2
  elseif opt.align=="right" then
    obj.anchorX = 1
    obj.x = opt.x + opt.width
  end
 
  if opt.valign=="top" then
    obj.anchorY = 0
  elseif opt.valign=="middle" then
    obj.anchorY = 0
    obj.y = opt.y + opt.height/2 - opt.fontSize/2
  elseif opt.valign=="bottom" then
    obj.anchorY = 1
  end
  
  obj:setFillColor(unpack(opt.fillColor))
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  if opt.reference then
    obj:addEventListener("touch",
      function(event)
        if event.phase=="ended" then
          composer.gotoScene(opt.reference)
        end
        return true
      end
    )
  end
  return obj
end

function cbPencilCore.newMaterialIcon(options)
  local obj
  local opt = optCopy(options)
  obj = display.newText(opt)
  obj.x = obj.x + obj.width/2
  obj.y = obj.y -- + obj.height/2
  obj.anchorX = 0.5
  obj.anchorY = 0.125
  obj:setFillColor(unpack(opt.fillColor))
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  if opt.reference then
    obj:addEventListener("touch",
      function(event)
        if event.phase=="ended" then
          composer.gotoScene(opt.reference)
        end
        return true
      end
    )
  end
  return obj
end

function cbPencilCore.newButton(options)
  local obj
  local opt = optCopy(options)
  opt.x = opt.x + opt.width/2
  opt.y = opt.y + opt.height/2
  obj = widget.newButton(opt)
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  if opt.reference then
    obj:addEventListener("touch",
      function(event)
        if event.phase=="ended" then
          composer.gotoScene( opt.reference)
        end
        return true
      end
    )
  end
  return obj
end

function cbPencilCore.newSpinner(options)
  local obj
  local opt = optCopy(options)
  opt.x = opt.x + opt.width/2
  opt.y = opt.y + opt.height/2
  obj = widget.newSpinner(opt)
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  return obj
end

function cbPencilCore.newImageRect(options)
  local obj
  local opt = optCopy(options)
  opt.image = appPrefix.."refimages/"..opt.image
  obj = display.newImageRect(opt.image,system.ResourceDirectory,opt.width,opt.height)
  obj.x = opt.x
  obj.y = opt.y
  obj.anchorX = 0
  obj.anchorY = 0
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  if opt.reference then
    obj:addEventListener("touch",
      function(event)
        if event.phase=="ended" then
          composer.gotoScene( opt.reference)
        end
        return true
      end
    )
  end
  return obj
end

function cbPencilCore.newSwitch(options)
  local obj
  local opt = optCopy(options)
  opt.x = opt.x + opt.width/2
  opt.y = opt.y -- + opt.height/2
  obj = widget.newSwitch(opt)
  obj.anchorX = 0.5
  obj.anchorY = 0
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  return obj
end

function cbPencilCore.newSlider(options)
  local obj
  local opt = optCopy(options)
  opt.x = opt.x + opt.width/2
  opt.y = opt.y + opt.height/2
  obj = widget.newSlider(opt)
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  return obj
end

function cbPencilCore.newProgressView(options)
  local obj
  local opt = optCopy(options)
  opt.x = opt.x + opt.width/2
  opt.y = opt.y + opt.height/2
  obj = widget.newProgressView(opt)
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  obj:setProgress( opt.progress )
  return obj
end

function cbPencilCore.newTabBar(options)
  local obj
  local opt = optCopy(options)
  opt.left = opt.left
  opt.top = opt.top
  obj = widget.newTabBar(opt)
  if opt.sceneGroup then
    opt.sceneGroup:insert(obj)
  end
  return obj
end

-- Generic widgets handlers
local genericWidgets = {
  ["newTextField"] = "pimp.widget.newTextField",
  ["newTextBox"]   = "pimp.widget.newTextBox",
  ["newWebView"]   = "pimp.widget.newWebView",
  ["newMapView"]   = "pimp.widget.newMapView",
}

function cbPencilCore.newGenericObject(options)
  local opt = optCopy(options)
  opt.x = opt.x + opt.width/2
  opt.y = opt.y + opt.height/2
  if genericWidgets[opt.genericType] then
    local gw = require (genericWidgets[opt.genericType])
    local obj = gw(opt)
    if opt.sceneGroup then
      opt.sceneGroup:insert(obj)
    end
    return obj
  end
  return {}
end

-- native show/hide
function cbPencilCore.showNativeObjects(sceneObjects,objectOptions)
  if objectOptions then
    for o,opt in pairs(objectOptions) do
      if opt.genericType then
        sceneObjects[o].isVisible = objectOptions[o].isVisible
      end
    end
  end
end

function cbPencilCore.hideNativeObjects(sceneObjects,objectOptions)
  local any
  if objectOptions then
    for o,opt in pairs(objectOptions) do
      if opt.genericType then
        sceneObjects[o].isVisible = false
        any = true
      end
    end
    if any then native.setKeyboardFocus(nil) end
  end
end

function cbPencilCore.destroyNativeObjects(sceneObjects,objectOptions)
  if objectOptions then
    for o,opt in pairs(objectOptions) do
      if opt.genericType and opt.removeSelf then
        sceneObjects[o]:removeSelf()
        sceneObjects[o] = nil
      end
    end
  end
end

return cbPencilCore
