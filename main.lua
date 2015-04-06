gui = require "kraidGUI"
loveBackend = require "kraidGUILove"

function onClose_subWinA(window)
	subACheckbox:setParam("checked", false)
	return true
end

function onCheck_checkboxA(checkbox)
	subWindowB:setParam("visible", checkbox.checked)
end

function love.load()
	loveBackend.init(gui)

	sceneModeGUI = gui.widgets.Base()

	sceneWindow = gui.widgets.Window{parent = sceneModeGUI, text = "Scene", position = {100, 100}, width = 300, height = 600, closeable = false}

	subWindowB = gui.widgets.Window{parent = sceneWindow, text = "Child B", position = {50, 50}, width = 100, height = 100, onClose = onClose_subWinA}
	subBLabel = gui.widgets.Label{parent = subWindowB, text = "Label B2", position = {20, 50}}

	subWindowA = gui.widgets.Window{parent = sceneWindow, text = "Child A", position = {150, 100}, width = 200, height = 200}
	subACheckbox = gui.widgets.Checkbox{parent = subWindowA, position = {5, 120}, onCheck = onCheck_checkboxA}
	subAButton = gui.widgets.Button{parent = subWindowA, text = "Button A", position = {5, 55}, width = 190, height = 35, onMouseUp = function(button) print("KLICK") end}

	propertiesWindow = gui.widgets.Window{parent = sceneModeGUI, text = "Properties", position = {700, 200}, width = 350, height = 600, closeable = false}

	hiddenCheckboxLabel = gui.widgets.Label{parent = propertiesWindow, text = "hidden"}
	hiddenCheckbox = gui.widgets.Checkbox{parent = propertiesWindow}
	enabledCheckboxLabel = gui.widgets.Label{parent = propertiesWindow, text = "enabled"}
	enabledCheckbox = gui.widgets.Checkbox{parent = propertiesWindow}
	loadButton = gui.widgets.Button{parent = propertiesWindow, text = "Load", height = 30, minWidth = 50}
	saveButton = gui.widgets.Button{parent = propertiesWindow, text = "Save", height = 30, minWidth = 50}
	saveAsButton = gui.widgets.Button{parent = propertiesWindow, text = "Save As..", height = 30, minWidth = 50}

	propertiesLayout = gui.layouts.LineLayout(propertiesWindow)
	propertiesWindow:setParam("onResize", function(window) propertiesLayout:arrange() end)

	propertiesLayout:setParam("padding", 5)
	propertiesLayout:setParam("padding-top", 30)
	propertiesLayout:setParam("spacing", 5)

	propertiesLayout:newLine()
	propertiesLayout:addWidget(hiddenCheckbox)
	propertiesLayout:addWidget(hiddenCheckboxLabel)

	propertiesLayout:newLine()
	propertiesLayout:addWidget(enabledCheckbox)
	propertiesLayout:addWidget(enabledCheckboxLabel)

	propertiesLayout:newLine()
	propertiesLayout:addWidget(loadButton)

	propertiesLayout:newLine()
	propertiesLayout:addWidget(saveButton)
	propertiesLayout:addWidget(saveAsButton)

	propertiesLayout:arrange()

	love.graphics.setBackgroundColor(150, 150, 150)
end

function love.update()
	sceneModeGUI:update()
end

function love.textinput(text)
	if gui.widgets.focused then
		gui.widgets.focused.textInput(text)
	end
end

function love.mousepressed(x, y, button)
	sceneModeGUI:mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
	sceneModeGUI:mouseReleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	sceneModeGUI:mouseMove(x, y, dx, dy)
end

function love.keypressed(key)
	if gui.widgets.focused then
		gui.widgets.focused.keyPressed(key)
	end
end

function love.draw()
	sceneModeGUI:draw()

	love.graphics.print("subWindowB visible " .. tostring(subWindowB.visible), 0, 25)

	if not sceneWindow.hovered and not propertiesWindow.hovered then
		love.graphics.print("IN EDITOR VIEW", 0, 0)
	end
end
