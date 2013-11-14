function love.load()
   initMenu()
   ball = love.graphics.newImage("arrow2.png")
   love.mouse.setVisible(false)
   love.graphics.setBackgroundColor(150,230,255)

   rect = {
      x = 100,
      y = 100,
      width = 100,
      height = 100,
      dragging = { active = false, diffX = 0, diffY = 0 }
   }
end

function love.draw()
   love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
   if menu.visible then
      menu:draw()
   end
   love.graphics.draw(ball, love.mouse.getX(), love.mouse.getY())
   love.graphics.print("Menu: ".. tostring(menu.visible) .. ", Stat: " .. menu.stat , 10, 20)
   local x,y = love.mouse.getX(), love.mouse.getY()
   love.graphics.print("Report: " .. tostring(x > menu.x) .. " " .. tostring(x < menu.x + menu.width) .. " ", 10,40)
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
     menu:toggle(x,y)
  end
end

function love.update(dt)
   menu.stat = ""
   for j,k in pairs(menu) do 
      if type(k) == "number" then
	 menu.stat = menu.stat .. tostring(j) .. " = " .. tostring(k) .. " "
      end
   end

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
   menu.toggle = function (self,x,y)
		    self.visible = not self.visible
		    menu.x, menu.y = x,y
		 end
   menu.draw = function (self)
		  love.graphics.setColor(255,100,200)
		  love.graphics.rectangle("fill",menu.x, menu.y, menu.width, menu.height)
		  local x,y = love.mouse.getX() , love.mouse.getY()
		  love.graphics.setColor(255,255,255)
  		  for i = 1, #menu.items do
		     if (x > menu.x and x < menu.x + menu.width and y > menu.y + (i - 1)*14 
		      and y < menu.y + i*14) then
			love.graphics.setColor(255,50,100)
			love.graphics.rectangle("fill", menu.x + 1, menu.y + (i - 1)*14 +1,
						menu.width - 2, 16)
			love.graphics.setColor(255,255,255)
		     end
--		     love.graphics.print(menu.items[i][1], menu.x + 2, menu.y + (i -1)*14 + 2)
		     love.graphics.rectangle("fill", menu.x + 2, menu.y + (i-1)*(14+2), menu.width - 4, 12)
		  end
	       end
   menu.items = {
      {"do nothing"};
      {"close", menu.toggle};
   }
   
   menu.stat = ""
   local width = 0
   for i in ipairs(menu.items) do
      width = math.max(width,string.len(menu.items[i][1]))
   end
   menu.width = width*7 + 4
   menu.height = #menu.items * 14 + 4
end

