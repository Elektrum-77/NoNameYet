io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest")
  
  
  color =
  {
    white = {255/255,255/255,255/255},
    black = {0/255,0/255,0/255},
    red = {255/255,0/255,0/255},
    green = {0/255,255/255,0/255},
    blue = {0/255,0/255,255/255},
    yellow = {255/255,255/255,0/255},
    purple = {255/255,0/255,255/255},
    orange = {255/255,128/255,0/255},
    grey = {64/255,64/255,64/255},
    greyLite = {128/255,128/255,128/255},
    greyDark = {32/255,32/255,32/255},
  }
  
  love.graphics.setBackgroundColor(color.greyDark)
  
  
  setColor = love.graphics.setColor
  sW, sH = love.graphics.getDimensions()
  
  
  mainFont = love.graphics.newFont(20)
  inventoryFont = love.graphics.newFont(10)
  love.graphics.setFont(mainFont)
  
  
  menu = 
  {
    main = 
    {
      color = color.white,
      cololSelection = color.orange,
    },
    play = 
    {
      color = color.white,
      cololSelection = color.orange,
    },
    option = 
    {
      color = color.white,
      cololSelection = color.orange,
    },
    inGame = 
    {
      color = color.white,
      cololSelection = color.orange,
    },
    
  }
  
currentMenu = menu.main
showMenu = true
  
update = {}
settingsChange = {}
draw = {}
draw.order = {}
toLoad = {}
---------------------------------------
loaded = {map = false, player = false}
checkOnLoaded = function()
  for __,v in ipairs(loaded) do
    if v ~= true then return false end
  end
end
---------------------------------------
mousePressed = {}
mouseReleased = {}
mouseWheel = {}
kP = {}
kR = {}
  
  
function AddButton(pMenu, pButtonType, pText, pColor, pWhenTriggered, pos)
  if pButtonType == "textOnly" then
    local button = 
    {
      buttonType = pButtonType,
      text = pText,
      color = pColor,
      whenTriggered = pWhenTriggered,
    }
    table.insert(menu[pMenu], pos, button)
    print("button created")
  end
end

toLoad.button = function()
  AddButton(
    "main",
    "textOnly",
    "play",
    color.white,
    function()
      currentMenu = menu.play
    end,
    1
  )
  AddButton(
    "main",
    "textOnly",
    "option",
    color.white,
    function()
      currentMenu = menu.option
    end,
    2
  )
  AddButton(
    "main",
    "textOnly",
    "quit",
    color.white,
    function() 
      love.event.quit() 
    end,
    3
  )
  AddButton(
    "play",
    "textOnly",
    "play",
    color.white,
    function() 
      showMenu = false 
      print("loading please wait") 
      initMap() 
      initPlayer() 
    end,
    1
  )
  AddButton(
    "play",
    "textOnly",
    "back",
    color.white,
    function() 
      currentMenu = menu.main
    end,
    2
  )
  AddButton(
    "option",
    "textOnly",
    "back",
    color.white,
    function() 
      currentMenu = menu.main 
    end,
    1
  )
  
  draw.menu = function()
    if showMenu == false or showMenu == nil then return end
    for i,button in ipairs(currentMenu) do
      --if button.buttonType == "textOnly" then
        local x = 50
        local y = ( sH / 2 ) + ((i-1) * 30) - ((#currentMenu) * 30)/2
        setColor(button.color)
        love.graphics.print(button.text, x, y)
        setColor(color.white)
      --end
    end
  end
  table.insert(draw.order,1,"menu")
  mousePressed.menu = function(x, y)
    if showMenu == false or showMenu == nil then return end
    for i,button in ipairs(currentMenu) do
      local bx = 45
      local by = ( sH / 2 ) + ((i-1) * 30) - ((#currentMenu) * 30)/2
      if x > bx and x < bx + 200 and y > by and y < by + 20 then
        button.whenTriggered()
      end
    end
  end
  update.menu = function(dt)
    if showMenu == false or showMenu == nil then return end
    for i,button in ipairs(currentMenu) do
      local bx = 45
      local by = ( sH / 2 ) + ((i-1) * 30) - ((#currentMenu) * 30)/2
      local x, y = love.mouse.getPosition()
      if x > bx and x < bx + 200 and y > by and y < by + 20 then
        button.color = currentMenu.cololSelection
      elseif button.color == currentMenu.cololSelection then button.color = currentMenu.color end
    end
  end
end


function initMap()
  map = {}
  allTheMap = {}
  allTheMap[1] = {}
  allTheMap[1][1] = {}
  allTheMap[1][1][1] = {}
  allTheMap[1][1][1][1] = {}
  currentMap = {1, 1, 1, 1}
  map.blockSize = 32
  map.w = 41
  map.h = 21
  for j = 1,map.h do
    map[j] = {}
    for i = 1,map.w do
      map[j][i] = 
      {
        soilType = "dirt",
      }
      -- making example of what should look like the table if it's :
      --an item
      if i == 15 and j == 15 then
        map[j][i] = 
        {
          id = "item",
          item = 
          {
            name = "blue square",
            count = 15,
          },
          soilType = "dirt",
        }
      end
      --an ore patch (1x1) it's an iron-ore patch
      if i == 33 and j == 17 then
        map[j][i] = 
        {
          id = "ore",
          name = "iron-ore",
          count = 32,
          soilType = "dirt",
        }
      end
      --an ore patch (1x1) it's an copper-ore patch
      if i == 15 and j == 19 then
        map[j][i] = 
        {
          id = "ore",
          name = "copper-ore",
          count = 32,
          soilType = "dirt",
        }
      end
      --an infinite ore patch (1x1) it's an infinite coal-ore patch
      if i == 41 and j == 21 then
        map[j][i] = 
        {
          id = "ore",
          name = "coal-ore",
          count = -1,
          soilType = "dirt",
        }
      end
    end
  end
  allTheMap[1][1][1][1] = map
  
  function generatMapChunk(XYAB)
    if allTheMap[XYAB[1]] ~= nil and allTheMap[XYAB[1]][XYAB[2]] ~= nil and allTheMap[XYAB[1]][XYAB[2]][XYAB[3]] ~= nil and allTheMap[XYAB[1]][XYAB[2]][XYAB[3]][XYAB[4]] ~= nil then
      local LMap = {}
      for j = 1,map.h do
        LMap[j] = {}
        for i = 1,map.w do
          LMap[j][i] = 
          {
            soilType = "dirt",
          }
        end
      end
    end
    currentMap = XYAB
    map = allTheMap[XYAB[1]][XYAB[2]][XYAB[3]][XYAB[4]]
  end
  
  
  graphics.map = {}
  graphics.map["dirt"] = love.graphics.newImage("Textures/dirt.png")
  graphics.map["blue square"] = love.graphics.newImage("Textures/blue square.png")
  graphics.map["iron-ore"] = love.graphics.newImage("Textures/iron-ore.png")
  graphics.map["coal-ore"] = love.graphics.newImage("Textures/coal-ore.png")
  graphics.map["stone-ore"] = love.graphics.newImage("Textures/stone-ore.png")
  graphics.map["copper-ore"] = love.graphics.newImage("Textures/copper-ore.png")
  graphics.map["gold-ore"] = love.graphics.newImage("Textures/gold-ore.png")
  
  
  map = allTheMap[1][1][1][1]
  print("the map finish to load")
  loaded.map = true
  
  draw.map = function()
    if loaded.map == true and loaded.player == true then --[[  |    --
     |need to check if we are going to draw something    --    |    --
     |                                                   --   \|/   ]]--
      if allTheMap[currentMap[1]] ~= nil and allTheMap[currentMap[1]][currentMap[2]] ~= nil and allTheMap[currentMap[1]][currentMap[2]][currentMap[3]] ~= nil and allTheMap[currentMap[1]][currentMap[2]][currentMap[3]][currentMap[4]] ~= nil then
        
        for j,__ in ipairs(map) do
          for i,v in ipairs(map[j]) do
            local x = (i - player.x) * map.blockSize + sW/2
            local y = (j - player.y) * map.blockSize + sH/2
            if v.soilType ~= nil then
              love.graphics.draw(graphics.map[v.soilType], x, y)
            end
            if v.id == "item" then
              if graphics.map[v.item.name] ~= nil then
                love.graphics.draw(graphics.map[v.item.name], x, y)
                else
                love.graphics.draw(graphics.item[v.item.name], x, y)
              end
            elseif v.id ~= nil then
              love.graphics.draw(graphics.map[v.name], x, y)
            end
          end
        end
      end
    end
  end
  table.insert(draw.order, 2, "map")
  
end

toLoad.graphics = function()
  graphics = {}
end

initPlayer = function()
  
  player = 
  {
    x = map.w /2,
    y = map.h /2,
    toolbar = {max = 10, name = "player-toolbar"},
    toolbarSelected = 1,
    inventory = {max = 30, name = "player-inventory"},
    craftingSlot = {max = 9, name = "player-craftingSlot"},
    inventoryIsOpen = false,
    mouseItem = {},
    health = 100,
    ranged = 3,
    speed_multiplier = 1,
    mining_speed = 1,
    mining_speed_multiplier = 1,
  }
  pt = player.toolbar[math.floor(player.toolbarSelected)]
  ----GRAPHICS----
  graphics.UI = {}
  graphics.UI.inventory = {}
  graphics.UI.inventory.case = love.graphics.newImage("Textures/UI/inventory_case.png")
  graphics.UI.inventory.case_overlay = love.graphics.newImage("Textures/UI/inventory_case_selected_overlay.png")
  
  graphics.item = {}
  graphics.item["blue square"] = love.graphics.newImage("Textures/blue square 32x.png")
  graphics.item["iron-ore"] = graphics.map["iron-ore"]
  graphics.item["coal-ore"] = graphics.map["coal-ore"]
  graphics.item["stone-ore"] = graphics.map["stone-ore"]
  graphics.item["copper-ore"] = graphics.map["copper-ore"]
  graphics.item["gold-ore"] = graphics.map["gold-ore"]
  ----        ----
  update.player = function(dt)
    if kP["z"] == true then movePlayer("up", dt) end
    if kP["q"] == true then movePlayer("left", dt) end
    if kP["s"] == true then movePlayer("down", dt) end
    if kP["d"] == true then movePlayer("right", dt) end
    if mousePressed[2] == true then playerMine(dt) end
  end
  
  playerMine = function(dt)
    local mx, my = love.mouse.getPosition()
    x = math.floor(((mx - sW/2) / map.blockSize) + player.x)
    y = math.floor(((my - sH/2) / map.blockSize) + player.y)
    if #player.inventory ~= player.inventory.max then
      if map[y] ~= nil and map[y][x] ~= nil and map[y][x].id == "ore" then
        if map[y][x].durability == nil then map[y][x].durability = 10 end
        if pt == nil or pt.id ~= "item" or pt.itemType ~= "pickaxe" then
          map[y][x].durability = map[y][x].durability - player.mining_speed * player.mining_speed_multiplier * dt
          print(map[y][x].durability)
        else
          map[y][x].durability = map[y][x].durability - (player.mining_speed + pt.attribute.mining_speed) * player.mining_speed_multiplier * dt
        end
        while map[y][x].durability < 0 do
          insertItemIn(player.inventory, {item = {name = map[y][x].name, count = 1}})
          map[y][x].durability = map[y][x].durability + 10
          map[y][x].count = map[y][x].count - 1
          if map[y][x].count == 0 then break end
        end
        if map[y][x].count == 0 then
          local soilType = map[y][x].soilType
          map[y][x] = nil
          map[y][x] = {soilType = soilType}
        end
      end
    end
  end
  
  kP.player = function(key)
    if key == "e" and player.inventoryIsOpen == false then
      player.inventoryIsOpen = true
    elseif key == "e" then
      player.inventoryIsOpen = false
      
      
    end
  end
  
  movePlayer = function(dir, dt)
    if dir == "up" then
      player.y = player.y - 2.5 * dt * player.speed_multiplier
    end
    if dir == "left" then
      player.x = player.x - 2.5 * dt * player.speed_multiplier
    end
    if dir == "down" then
      player.y = player.y + 2.5 * dt * player.speed_multiplier
    end
    if dir == "right" then
      player.x = player.x + 2.5 * dt * player.speed_multiplier
    end
    print("x"..player.x)
    print("y"..player.y)
  end
  
  mousePressed.player = function(x, y, button)
    if loaded.player == true then
      print("mouse : x="..x.."  y="..y)
      if not((y < 160 and x < 376) or (y > sH - 124 and x < 124) and player.inventoryIsOpen == true) then playerInteractWith(x, y, button) end
      if player.inventoryIsOpen == true and button == 1 then
        local a, b, k
        local item = {}
        if y > 20 and y < 160 and x > 20 and x < 376 then
          a = math.floor((x+16)/36)
          b = (math.floor((y+16)/36)-1)*10
          k = a + b
          if b >= 1 then
            k = k - 10
            if player.inventory[k] ~= nil and player.inventory[k].item ~= nil then
              if player.mouseItem == nil or player.mouseItem.item == nil then
                if player.inventory[k] ~= nil then
                  player.mouseItem = player.inventory[k]
                  table.remove(player.inventory, k)
                end
              elseif player.mouseItem.item ~= nil and #player.inventory < 30 then
                item = player.mouseItem
                player.mouseItem = player.inventory[k]
                table.remove(player.inventory, k)
                insertItemIn(player.inventory, item)
              end
            elseif player.mouseItem ~= nil and player.mouseItem.item ~= nil then
              insertItemIn(player.inventory, player.mouseItem)
              player.mouseItem = nil
            end
          else
            if player.toolbar[k] ~= nil and player.toolbar[k].item ~= nil then
              if player.mouseItem == nil or player.mouseItem.item == nil then
                player.mouseItem = player.toolbar[k]
                table.remove(player.toolbar, k)
              elseif player.mouseItem.item ~= nil and #player.toolbar < 10 then
                item = player.mouseItem
                player.mouseItem = player.toolbar[k]
                table.remove(player.toolbar, k)
                insertItemIn(player.toolbar, item)
              end
            elseif player.mouseItem ~= nil and player.mouseItem.item ~= nil then
              insertItemIn(player.toolbar, player.mouseItem)
              player.mouseItem = nil
            end
          end
        end
      end
    end
  end
  
  mouseReleased.player = function(x, y, button)
  end
  
  playerInteractWith = function(mx, my, button)
    --if math.pow(sW/2 - x, 2) + math.pow(sH/2 - y, 2) < math.pow(player.ranged * map.blockSize, 2) then
    x = math.floor(((mx - sW/2) / map.blockSize) + player.x)
    y = math.floor(((my - sH/2) / map.blockSize) + player.y)
    
    if y > 0 and y <= map.h and x > 0 and x <= map.w then
      if map[y][x].id == nil then
        print("this is just the ground, so stop cliking it like an idiot")
      elseif map[y][x].id == "item" and button == 1 then
        grabItem(x, y)
      end
    end
    
    
    --end
  end
  
  grabItem = function(x, y)
    local item = {}
    item.item = map[y][x].item
    if insertItemIn(player.inventory, item) == true then
      map[y][x].id = nil
      map[y][x].item = nil
    else print("player inventory is full") end
  end
  
  insertItemIn = function(Container, Item)
    if #Container < Container.max then
      local i = searchItemIn(Container, Item.item.name)
      if i ~= nil then
        Container[i].item.count = Container[i].item.count + Item.item.count
      else
        Container[#Container+1] = Item
      end
      return true
    else 
      print("the container is full, you can't overload it")
      return nil
    end
  end
  
  searchItemIn = function(Container, ItemName)
    for i,v in ipairs(Container) do
      if v.item.name == ItemName then
        return i
      end
    end
    return nil
  end
  
  draw.playerInventory = function()
    if player.inventoryIsOpen == true then
      local a, b, x, y
      -- here it's the inventory sprite
      for b = 1,3 do
        for a = 1,10 do
          x = a * 36 - 16
          y = (b+1) * 36 - 16
          love.graphics.draw(graphics.UI.inventory.case, x, y)
        end
      end
      -- here it's the crafting slot sprite
      for b = 1,3 do
        for a = 1,3 do
          x = a * 36 - 16
          y = b * -36 - 16 + sH
          love.graphics.draw(graphics.UI.inventory.case, x, y)
        end
      end
      local mx, my = love.mouse.getPosition()
      if my > 56 and my < 160 and mx > 20 and mx < 376 then
        x = math.floor((mx+16)/36) * 36 - 18
        y = math.floor((my+16)/36) * 36 - 18
        love.graphics.draw(graphics.UI.inventory.case_overlay, x, y)
      elseif my > sH - 124 and my < sH - 20 and mx > 20 and mx < 124 then
        x = math.floor((mx+16)/36) * 36 - 18
        y = math.ceil((my+16-sH)/-36) * -36 - 18 + sH
        love.graphics.draw(graphics.UI.inventory.case_overlay, x, y)
      end
      for k,v in ipairs(player.inventory) do
        if math.fmod(k, 10) ~= 0 then x = math.fmod(k, 10) * 36 - 16 else x = 10 * 36 - 16 end
        if math.fmod(k, 10) ~= 0 then y = (((k-math.fmod(k, 10))/10)+2) * 36 - 16 else y = ((k/10)+1) * 36 - 16 end
        if v.item ~= nil and v.item.name ~= nil then
          love.graphics.draw(graphics.item[v.item.name], x, y)
          if v.item.count > 1 then
            setColor(color.yellow)
            love.graphics.setFont(inventoryFont)
            love.graphics.print(tostring(v.item.count), x -2, y+22)
            love.graphics.setFont(mainFont)
            setColor(color.white)
          end
        end
      end
      if player.mouseItem ~= nil and player.mouseItem.item ~= nil then
        if player.mouseItem.item.name ~= nil then love.graphics.draw(graphics.item[player.mouseItem.item.name], mx, my) end
      end
    end
  end
  table.insert(draw.order, "playerInventory")
  
  draw.playerToolbar = function()
    if loaded.player == true then
      local a, x, y
      for a = 1,10 do
        x = a * 36 - 16
        y = 20
        love.graphics.draw(graphics.UI.inventory.case, x, y)
      end
      if player.toolbarSelected < 11 then
        x = math.floor(player.toolbarSelected)*36 - 18
        y = 18
        love.graphics.draw(graphics.UI.inventory.case_overlay, x, y)
      end
      for k,v in ipairs(player.toolbar) do
        x = math.fmod(k, 10) * 36 - 16
        y = (((k-math.fmod(k, 10))/10)+1) * 36 - 16
        if v.item ~= nil and v.item.name ~= nil then
          love.graphics.draw(graphics.item[v.item.name], x, y)
          if v.item.count > 1 then
            setColor(color.yellow)
            love.graphics.setFont(inventoryFont)
            love.graphics.print(tostring(v.item.count), x -2, y+22)
            love.graphics.setFont(mainFont)
            setColor(color.white)
          end
        end
      end
    end
  end
  table.insert(draw.order, "playerToolbar")
  
  mouseWheel.player = function(x, y)
    player.toolbarSelected = player.toolbarSelected + y
    if player.toolbarSelected >= 11 then player.toolbarSelected = player.toolbarSelected - 10 end
    if player.toolbarSelected < 1 then player.toolbarSelected = player.toolbarSelected + 10 end
  end
  
  loaded.player = true
  print("player loaded")
end



  
  
function love.keypressed(key)
  for k,v in pairs(kP) do
    if type(v) == "function" then v(key) end
  end
  kP[key] = true
end

function love.keyreleased(key)
  for k,v in pairs(kR) do
    if type(v) == "function" then v(key) end
  end
  kP[key] = false
end

function love.mousepressed(x, y, button)
  for k,v in pairs(mousePressed) do
    if type(v) == "function" then v(x, y, button) end
  end
  mousePressed[button] = true
end

function love.mousereleased(x, y, button)  
  for k,v in pairs(mouseReleased) do
    if type(v) == "function" then v(x, y, button) end
  end
  mousePressed[button] = false
end

function love.wheelmoved(x, y)  
  for k,v in pairs(mouseWheel) do
    if type(v) == "function" then v(x, y) end
  end
end

function love.load()
  for k,v in pairs(toLoad) do
    if type(v) == "function" then v() end
  end
  
  
end

function love.update(dt)
  for __,v in pairs(update) do
    if type(v) == "function" then 
      v(dt) 
    elseif type(v) == "table" then
      for __,j in pairs(v) do
        if type(j) == "function" then 
          j(dt)
        end
      end
    end
  end
  
  
end

function love.draw()
  for k,v in ipairs(draw.order) do
    if type(draw[v]) == "function" then draw[v]() end
  end
  
  love.graphics.rectangle("fill", sW/2, sH/2, 1, 1)
end
