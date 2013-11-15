function love.load()
   initMenu()
   ball = love.graphics.newImage("arrow2.png")
   love.graphics.setBackgroundColor(150,230,255)
   love.mouse.setVisible(false)
   rect = {
      x = 100,
      y = 100,
      width = 100,
      height = 100,
      dragging = { active = false, diffX = 0, diffY = 0 }
   }
end

function love.draw()
   local x,y = love.mouse.getX(), love.mouse.getY()
   love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
   if menu.visible then
      menu:draw()
   end
   local print = {
      "FPS: " .. love.timer.getFPS()
   }
   for i,a in ipairs(print) do
      love.graphics.print(a,10,i*20)
   end
   love.graphics.draw(ball, x, y)
end

function love.mousepressed(x, y, button)
  if button == "l"
  and x > rect.x and x < rect.x + rect.width
  and y > rect.y and y < rect.y + rect.height
  then
    rect.dragging.active = true
    rect.dragging.diffX = x - rect.x
    rect.dragging.diffY = y - rect.y
  end
  if button == "r" then
     menu.toggle()
  end
end

function love.update(dt)
  if rect.dragging.active then
     rect.x = love.mouse.getX() - rect.dragging.diffX
     rect.y = love.mouse.getY() - rect.dragging.diffY
  end
end

function love.mousereleased(x, y, button)
   if button == "l" then 
      rect.dragging.active = false 
      if menu.visible then
	 if x > menu.x and x < menu.x + menu.width and y > menu.y and y > menu.y + menu.height then
--	    local action = 
	 end
      end
   end
end

function initMenu()
   menu = {}
   menu.width = 0
   menu.height = 0
   menu.x = 0
   menu.y = 0
   menu.visible = false
   menu.toggle = function ()
		    menu.visible = not menu.visible
		    if menu.visible then
		       menu.x, menu.y = math.min(love.mouse.getX(),love.graphics.getWidth()-menu.width),
		       math.min(love.mouse.getY(),love.graphics.getHeight()-menu.height)
		    end
		 end
   menu.draw = function (self)
		  love.graphics.setColor(255,100,200)
		  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		  local x,y = love.mouse.getX() , love.mouse.getY()
		  love.graphics.setColor(255,255,255)
  		  for i = 1, #self.items do
		     if (x >= self.x and x <= self.x + self.width and y > self.y + (i - 1)*15
		      and y <= self.y + i*15) then
			love.graphics.setColor(255,50,100)
			love.graphics.rectangle("fill", self.x + 1, self.y + (i -1)*15 + 1,
						self.width - 2, 15)
			love.graphics.setColor(255,255,255)
			if love.mouse.isDown('l') and self.items[i][2] 
			             and type(self.items[i][2]) == "function" then
				     self.items[i][2]()
			end
		     end
		     love.graphics.print(self.items[i][1], self.x + 2, self.y + (i -1)*15 + 2)
		     --love.graphics.rectangle("fill", self.x + 2, self.y + (i-1)*(15) + 2, self.width - 4, 13)
		  end
	       end
   menu.items = {
      {"do nothing"};
      {"close", menu.toggle};
      {"more"};
      {"menu things"};
      {"such length! most unexpectable!"};
   }
   
   menu.stat = ""
   local width = 0
   for i in ipairs(menu.items) do
      width = math.max(width,string.len(menu.items[i][1]))
   end
   menu.width = width*7 + 4
   menu.height = #menu.items * 15 + 2
end

