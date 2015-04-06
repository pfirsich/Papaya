function module(gui)
	local theme = {}

	theme.colors = { -- inspired by https://love2d.org/forums/viewtopic.php?f=5&t=75614 (Gray)
		background = {70, 70, 70},
		border = {45, 45, 45},
		text = {255, 255, 255},
		object = {100, 100, 100},
		objectHighlight = {180, 180, 180},
		marked = {205, 0, 0},
	}

	--------------------------------------------------------------------
	--------------------------------------------------------------------
	theme.Base = {}

	function theme.Base.draw(self)
		gui.internal.foreach_array(self.children, function(child)
			child:draw()
		end)
	end

	--------------------------------------------------------------------
	--------------------------------------------------------------------
	theme.Window = {}
	theme.Window.titleBarBorder = 0
	theme.Window.titleOffsetX = 5
	theme.Window.titleBarHeight = 25

	function theme.Window.mouseMove(self, x, y, dx, dy)
		if self.dragged then
			self.position = {self.position[1] + dx, self.position[2] + dy}
			if self.onMove then self:onMove(unpack(self.position)) end
			return true
		end
	end

	function theme.Window.mouseReleased(self, x, y, button)
		if button == "l" then self.dragged = false end
	end

	function theme.Window.mousePressed(self, x, y, button)
		if button == "l" then
			local localMouse = gui.internal.toLocal(x, y)

			if gui.internal.inRect(localMouse, {0, 0, self.width, theme.Window.titleBarHeight}) then
				self.dragged = true
				return true
			end
		end
	end

	function theme.Window.draw(self)
		gui.graphics.setColor(theme.colors.background)
		gui.graphics.drawRectangle(0, 0, self.width, self.height)

		gui.internal.foreach_array(self.children, function(child)
			child:draw()
		end)

		gui.graphics.setColor(theme.colors.border)
		gui.graphics.drawRectangle(	theme.Window.titleBarBorder, theme.Window.titleBarBorder,
									self.width - theme.Window.titleBarBorder * 2,
									theme.Window.titleBarHeight - theme.Window.titleBarBorder * 2)

		gui.graphics.setColor(theme.colors.text)
		gui.graphics.text.draw(self.text, theme.Window.titleOffsetX, theme.Window.titleBarHeight/2 - gui.graphics.text.getHeight()/2)

		gui.graphics.setColor(theme.colors.border)
		gui.graphics.drawRectangle(0, 0, self.width, self.height, 2)
	end


	--------------------------------------------------------------------
	--------------------------------------------------------------------
	theme.Label = {}
	function theme.Label.draw(self)
		gui.graphics.setColor(theme.colors.text)
		gui.graphics.text.draw(self.text, 0, 0)
	end

	--------------------------------------------------------------------
	--------------------------------------------------------------------
	theme.Button = {}

	function theme.Button.draw(self)
		local bg = self.clicked and theme.colors.objectHighlight or (self.hovered and theme.colors.object or theme.colors.border)
		local border = self.clicked and theme.colors.border or theme.colors.objectHighlight

		gui.graphics.setColor(bg)
		gui.graphics.drawRectangle(0, 0, self.width, self.height)
		gui.graphics.setColor(border)
		gui.graphics.drawRectangle(0, 0, self.width, self.height, 2)

		gui.graphics.setColor(theme.colors.text)
		gui.graphics.text.draw(self.text, self.width/2 - gui.graphics.text.getWidth(self.text)/2, self.height/2 - gui.graphics.text.getHeight()/2)
	end

	--------------------------------------------------------------------
	--------------------------------------------------------------------

	theme.Checkbox = {}

	theme.Checkbox.checkSizeFactor = 0.6

	function theme.Checkbox.draw(self)
		gui.graphics.setColor(theme.colors.object)
		gui.graphics.drawRectangle(0, 0, self.width, self.height)
		gui.graphics.setColor(theme.colors.border)
		gui.graphics.drawRectangle(0, 0, self.width, self.height, 2)

		local w, h = self.width * theme.Checkbox.checkSizeFactor, self.height * theme.Checkbox.checkSizeFactor
		local x, y = self.width/2 - w/2, self.height/2 - h/2

		if self.hovered then gui.graphics.drawRectangle(x, y, w, h, 2) end

		gui.graphics.setColor(theme.colors.marked)
		if self.checked then gui.graphics.drawRectangle(x, y, w, h) end
	end

	return theme
end

return module
