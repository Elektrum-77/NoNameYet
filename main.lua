io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest")

function love.load()
  
  Color = dofile "color_lib.lua"
  
  love.window.setMode(1024,640)
  ScreenWidth, ScreenHeight = love.graphics.getDimensions()
  
  Fonts = {Lenght = 25}
  for k = 1, Fonts.Lenght do
    table.insert(Fonts, love.graphics.newFont(k))
  end
  love.graphics.setFont(Fonts[20])
  
  NoTexture = love.graphics.newImage("Textures/NoTexture.png")
  
  function AddItem(Inventory, Item)
    local id
    for k,v in ipairs(Inventory) do
      --print(#Inventory, v.Name, v.Count, Item.Name, Item.Count, getmetatable(Item))
      if v.Stackable and v.Name == Item.Name and v.Count < v.Stackable then
        if v.Count + Item.Count < v.Stackable then
          id = k
        else
          Item.Count = Item.Count + v.Count - v.Stackable
          v.Count = v.Stackable
        end
      end
    end
    if id ~= nil then
      Inventory[id].Count = Inventory[id].Count + Item.Count
      --print(Inventory[id].Count)
    else
      table.insert(Inventory, Item)
      setmetatable(Inventory[#Inventory], getmetatable(Item))
    end
  end
  
  
  
  KeyDown = love.keyboard.isDown
  Game = 
  {
    Mouse = 
    {
      old_x = 0, old_y = 0, x = 0, y = 0, X = 0, Y = 0, MapX = 0, MapY = 0, RegionX = 0, RegionY = 0,
      Pressed = {},
      
      Update = function(self, dt)
        self.x, self.y = love.mouse.getPosition()
        
        self.X = (self.x - ScreenWidth/2)/32 + Game.Player.X
        self.Y = (self.y - ScreenHeight/2)/32 + Game.Player.Y
        self.MapX = math.floor(((self.X+20)%41)-20)
        self.MapY = math.floor(((self.Y+20)%41)-20)
        self.RegionX = math.floor((self.X+20)/41)
        self.RegionY = math.floor((self.Y+20)/41)
        
        for k=1,2 do self.Pressed[k] = love.mouse.isDown(k) end
        
        self.old_x, self.old_y = self.x, self.y
      end,
    },
    Player = 
    {
      X = 0, Y = 0, MapX = 0, MapY = 0, RX = 0, RY = 0,
      
      IsInventoryOpen = false,
      Inventory = {OffsetY = 0}, MouseItem = nil,
      BlueprintRotation = {MaxX = 1, MaxY = 1, MinX = 0, MinY = 0},
      Speed = 8, MiningSpeed = 25,
      ToolbarCount = 1,
      
      Textures = 
      {
        Toolbar = love.graphics.newImage("Textures/UI/toolbar.png"),
        InventoryCase = love.graphics.newImage("Textures/UI/inventory_case.png"),
        InventoryCaseOverlay = love.graphics.newImage("Textures/UI/inventory_case_Overlay.png"),
      },
      --Angle = {0, math.pi/2, math.pi/4,math.pi, nil, 3*math.pi/4, math.pi/2, 3*math.pi/2, 7*math.pi/4, nil, 0, 5*math.pi/4, 3*math.pi/2, math.pi, nil},
      
      Init = function(self)
        
        self.NextX = self.X
        self.NextY = self.Y
        
        local Item = {Content = "O2", ContentCount = 100}
        setmetatable(Item, {__index = Game.Prototypes.Item.Bottle})
        AddItem(self.Inventory, Item)
        
        for __ = 1,5 do
          local Item = {Content = "Empty"}
          setmetatable(Item, {__index = Game.Prototypes.Item.Bottle})
          AddItem(self.Inventory, Item)
        end
        
        Item = {Count = 1}
        setmetatable(Item, {__index = Game.Prototypes.Item.Furnace})
        AddItem(self.Inventory, Item)
        
        Item = {Count = 1}
        setmetatable(Item, {__index = Game.Prototypes.Item.OreCrackingStation})
        AddItem(self.Inventory, Item)
        
      end,
      
      Draw = function(self)
        Color.Set(Color.Green)
        love.graphics.rectangle("fill", ScreenWidth/2 - 8, ScreenHeight/2 -28, 16, 32)
        
        Color.Set(Color.White)
        for y = 1,self.ToolbarCount do
          love.graphics.draw(self.Textures.Toolbar, ScreenWidth/2 -160, ScreenHeight - y*32)
        end
        
        love.graphics.setFont(Fonts[10])
        
        if Game.Mouse.RegionX >= Game.Maps.MinX and Game.Mouse.RegionX <= Game.Maps.MaxX and Game.Mouse.RegionY >= Game.Maps.MinY and Game.Mouse.RegionY <= Game.Maps.MaxY then
          
          local Case = Game.Maps.Region[Game.Mouse.RegionY][Game.Mouse.RegionX].Grid[Game.Mouse.MapY][Game.Mouse.MapX]
          love.graphics.print("X = "..Game.Mouse.X..", "..Game.Mouse.MapX..", "..Game.Mouse.RegionX..", ", 10, ScreenHeight-20)
          love.graphics.print("Y = "..Game.Mouse.Y..", "..Game.Mouse.MapY..", "..Game.Mouse.RegionY..", ", 10, ScreenHeight-35)
          love.graphics.print("Soil = "..Case.SoilType..",", 10, ScreenHeight-50)
          if Case.Ore then
            local OreList = ""
            for __,ore in ipairs(Case.Ore) do OreList = OreList..ore.Name.." ".. ore.Count..", " end
            love.graphics.print("Ore = "..OreList, 10, ScreenHeight-65)
            if Case.Ore.Durability and Game.Mouse.Pressed[2] then
              Color.Set(Color.Grey)
              love.graphics.rectangle("fill", Game.Mouse.x-16, Game.Mouse.y+20, 32, 5)
              Color.Set(Color.Yellow)
              love.graphics.rectangle("fill", Game.Mouse.x-16, Game.Mouse.y+20, 32*Case.Ore.Durability/100, 5)
            end
          end
        end
        
        if self.IsInventoryOpen then
          for k,v in ipairs(self.Inventory) do
            local x = 10 + ((k - 1) % 10) * 36
            local y = 10 + math.floor((k - 1) / 10) * 36
            Color.Set(Color.White)
            love.graphics.draw(self.Textures.InventoryCase, x, y)
            love.graphics.draw(v.Texture, x, y)
            
            if v.Count then
              Color.Set(Color.Orange)
              love.graphics.setFont(Fonts[10])
              love.graphics.print(v.Count, x, y + 26)
            end
            if v.Content then
              if v.Content == "Empty" then Color.Set(Color.Red) else Color.Set(Color.Orange) end
              love.graphics.setFont(Fonts[10])
              love.graphics.print(v.Content, x, y + 26)
            end
            if v.ContentCount then
              love.graphics.setFont(Fonts[10])
              Color.Set(Color.BlueLite)
              love.graphics.print(v.ContentCount, x+16, y + 26)
            end
          end
        end
        
        Color.Set(Color.White)
        if self.MouseItem then
          love.mouse.setVisible(false)
          love.graphics.draw(self.MouseItem.Texture, Game.Mouse.x, Game.Mouse.y, 0, 0.5, 0.5)
        else
          love.mouse.setVisible(true)
        end
        
      end,
      
      MousePressed = function(self, X, Y, Button)
        if self.IsInventoryOpen and X>10 and X<370 and Y>10 and Y<370 then
          
          local x = math.floor((X - 10) / 36)+1
          local y = math.floor((Y- 10) / 36 + self.Inventory.OffsetY) 
          local k = y * 10 + x
          --print(k)
          
          if self.MouseItem then
            if self.Inventory[k] then
              local Item = self.MouseItem
              --print("test1")
              setmetatable(Item, getmetatable(self.MouseItem))
              
              self.MouseItem = self.Inventory[k]
              setmetatable(self.MouseItem, getmetatable(self.Inventory[k]))
              table.remove(self.Inventory, k)
              AddItem(self.Inventory, Item)
              --setmetatable(self.Inventory[k], getmetatable(Item))
            else
              --print("test2")
              AddItem(self.Inventory, self.MouseItem)
              --setmetatable(self.Inventory[#self.Inventory], getmetatable(self.MouseItem))
              
              self.MouseItem = nil
            end
          else
            if self.Inventory[k] then
              --print("test3")
              self.MouseItem = self.Inventory[k]
              setmetatable(self.MouseItem, getmetatable(self.Inventory[k]))
              table.remove(self.Inventory, k)
            end
          end
        end
      
      end,
      
      KeyPressed = function(self, Key)
        if Key == "e" then
          self.IsInventoryOpen = not self.IsInventoryOpen
          --print(self.IsInventoryOpen)
        end
        if Key == "r" then
          local BR = self.BlueprintRotation -- this is did in that way to be "read friendly" / understable and readable
          if BR.MaxX == 1 and BR.MaxY == 1 then
            BR.MinX = -1
            BR.MaxX = 0
          elseif BR.MaxY == 1 then
            BR.MinY = -1
            BR.MaxY = 0
          elseif BR.Max == 0 then
            BR.MinX = 0
            BR.MaxX = 1
          else
            BR.MinY = 0
            BR.MaxY = 1
          end
          self.BlueprintRotation = BR
        end
        if Key == "a" then
          AddItem(self.Inventory, self.MouseItem)
          self.MouseItem = nil
        end
      end,
      
      Update = function(self, dt)
        
        self.NextX = self.X
        self.NextY = self.Y
        
        if KeyDown("d") then
          self.NextX = self.NextX + self.Speed * dt
        end
        if KeyDown("z") then
          self.NextY = self.NextY - self.Speed * dt
        end
        if KeyDown("q") then
          self.NextX = self.NextX - self.Speed * dt
        end
        if KeyDown("s") then
          self.NextY = self.NextY + self.Speed * dt
        end
        
        local c, l = math.floor(((self.NextX+20)%41)-20), math.floor(((self.NextY+20)%41)-20)
        self.MapX, self.MapY = math.floor(((self.X+20)%41)-20), math.floor(((self.Y+20)%41)-20)
        local Rc, Rl = math.floor((self.NextX+20)/41), math.floor((self.NextY+20)/41)
        self.RX, self.RY = math.floor((self.X+20)/41), math.floor((self.Y+20)/41)
        if not Game.Maps.Region[self.RY][Rc].Grid[self.MapY][c].Entity or not Game.Maps.Region[self.RY][Rc].Grid[self.MapY][c].Entity.Collide then
          self.X = self.NextX
        end
        if not Game.Maps.Region[Rl][self.RX].Grid[l][self.MapX].Entity or not Game.Maps.Region[Rl][self.RX].Grid[l][self.MapX].Entity.Collide then
          self.Y = self.NextY
        end
        --print(self.NextX, self.NextY, c, l, Rc, Rl)
        
        
        if Game.Mouse.Pressed[1] then
          local Case = Game.Maps.Region[Game.Mouse.RegionY][Game.Mouse.RegionX].Grid[Game.Mouse.MapY][Game.Mouse.MapX]
          
          if not self.IsInventoryOpen and self.MouseItem and self.MouseItem.Entity then
            if not Case.Entity then
              
              local Obstacle
              
              for i = 1, 2 do
                for Y = Game.Mouse.MapY + self.BlueprintRotation.MinY, Game.Mouse.MapY + self.BlueprintRotation.MaxY do
                  for X = Game.Mouse.MapX + self.BlueprintRotation.MinX, Game.Mouse.MapX + self.BlueprintRotation.MaxX do
                    
                    local RY, RX = Game.Mouse.RegionY, Game.Mouse.RegionX
                    if Y > 20 then
                      Y = Y - 41
                      RY = RY + 1
                    elseif Y < -20 then
                      Y = Y + 41
                      RY = RY - 1
                    end 
                    if X > 20 then
                      X = X - 41
                      RX = RX + 1
                    elseif X < -20 then
                      X = X + 41
                      RX = RX - 1
                    end
                    print(X, Y, RX, RY)
                    if Game.Maps.Region[RY][RX].Grid[Y][X].Entity then Obstacle = true end
                    
                    if i == 2 and not Obstacle then
                      Game.Maps.Region[RY][RX].Grid[Y][X].Entity = {EntityID = #Game.Entity + 1, Collide = true}
                    end
                    
                  end
                end
              end
              
              if not Obstacle then
                table.insert(Game.Entity, {})
                setmetatable(Game.Entity[#Game.Entity], {__index = Game.Prototypes.Entity[self.MouseItem.Entity]})
                Game.Entity[#Game.Entity]:Init()
              end
              
            end
          end
          
        end
        if Game.Mouse.Pressed[2] then
          local Case = Game.Maps.Region[Game.Mouse.RegionY][Game.Mouse.RegionX].Grid[Game.Mouse.MapY][Game.Mouse.MapX]
          if Case.Ore then
            if not Case.Ore.Durability then Case.Ore.Durability = 100 end
            if self.MouseItem and self.MouseItem.Type == "pickaxe" then
              self.MiningSpeedModifier = self.MiningSpeed * self.MouseItem.Efficiency
            else
              self.MiningSpeedModifier = self.MiningSpeed
            end
            Case.Ore.Durability = Case.Ore.Durability - dt * self.MiningSpeedModifier
            --print(Case.Ore.Durability)
            while Case.Ore and Case.Ore.Durability < 0 do
              
              Case.Ore.Durability = Case.Ore.Durability+100
              
              for k,v in ipairs(Case.Ore) do
                
                v.Count = v.Count-1
                local Item = {Count = 1}
                setmetatable(Item, {__index = Game.Prototypes.Item[v.Item]})
                AddItem(self.Inventory, Item)
                
                if v.Count == 0 then
                  table.remove(Case.Ore, k)
                  if #Case.Ore == 0 then Case.Ore = nil end
                end
                
              end
            end
          end
        end
        
      end,
    },
    
    Entity = 
    {
      Update = function(self, dt)
        
      end,
    },
    
    Maps = 
    {
      MinX = -2,
      MinY = -2,
      MaxX = 2,
      MaxY = 2,
      Region = {},
      
      Init = function(self)
        for l = self.MinY,self.MaxY do
          self.Region[l] = {}
          for c = self.MinX,self.MaxX do
            self.Region[l][c] = {}
            setmetatable(self.Region[l][c], {__index = Game.Prototypes.Region})
            self.Region[l][c]:Init()
            self.Region[l][c]:GenerateOrePatch({Game.Prototypes.Ore.List[math.ceil(math.random()*#Game.Prototypes.Ore.List)], Game.Prototypes.Ore.List[math.ceil(math.random()*#Game.Prototypes.Ore.List)]})
          end
        end
        self.Region[0][0].Grid[-1][-1].Entity = {Collide = true}
      end,
      
      Update = function(self, dt)
        self.MinY, self.MinX, self.MaxY, self.MaxX = Game.Player.RY, Game.Player.RX, Game.Player.RY, Game.Player.RX
        if Game.Player.MapY <= -10 then self.MinY = self.MinY - 1 elseif Game.Player.MapY >= 10 then self.MaxY = self.MaxY + 1 end
        if Game.Player.MapX <= -4 then self.MinX = self.MinX - 1 elseif Game.Player.MapX >= 4 then self.MaxX = self.MaxX + 1 end
      end,
      
      Draw = function(self)
        for l = self.MinY, self.MaxY do
          for c = self.MinX, self.MaxX do
            if not self.Region[l] then
              self.Region[l] = {}
              if l > self.MaxY then self.MaxY = l elseif l < self.MinY then self.MinY = l end
              --print(l, self.MaxY, self.MinY, "test1")
            end
            if not self.Region[l][c] then
              if c > self.MaxX then self.MaxX = c elseif c < self.MinX then self.MinX = c end
              --print(c, self.MaxX, self.MinX, "test2")
              self.Region[l][c] = {}
              setmetatable(self.Region[l][c], {__index = Game.Prototypes.Region})
              self.Region[l][c]:Init()
              self.Region[l][c]:GenerateOrePatch({Game.Prototypes.Ore.List[math.ceil(math.random()*#Game.Prototypes.Ore.List)], Game.Prototypes.Ore.List[math.ceil(math.random()*#Game.Prototypes.Ore.List)]})
            end
            self.Region[l][c]:Draw(Game.Player.X*(-32) + ScreenWidth/2 + c*41*32, Game.Player.Y*(-32)+ ScreenHeight/2 + l*41*32)
          end
        end
      end,
    },
    
    Prototypes = 
    {
      Init = function(self)
        require("Prototypes/Ore/Ore")
        require("Prototypes/Item/Item")
        require("Prototypes/Entity/Entity")
        for __,v in pairs(Game.Prototypes) do
          if type(v) == "table" then
            for ID, Object in pairs(v) do
              if type(Object) == "table" and Object.Name then table.insert(v.List, ID) end
            end
          end
        end
      end,
      
      Item = 
      {
        List = {},
      },
      
      Entity = 
      {
        List = {},
      },
      
      Ore = 
      {
        List = {},
      },
      
      Craft =
      {
        manufacturing = 
        {
          {
            Products = 
            {
              Bottle = {Content = ""},
            },
            Ingredients = 
            {
              IronPlate = {Count = 5},
            },
            EnergyConsuption = 100,
          },
        },
        Smelting =
        {
          {
            Name = "iron plate",
            Product = 
            {
              IronPlate = {Count = 1},
            },
            Ingredients = 
            {
              IronOre = {Count = 1},
            },
            EnergyConsuption = 100,
          },
        },
        OreCracking =
        {
          {
            Products = 
            {
              Bottle = {Content = "O2", ContentCount = 100},
              Uranium = {Count = 1},
            },
            Ingredients = 
            {
              Bottle = {Content = "Empty"},
              Uraninite = {Count = 1},
            },
            EnergyConsuption = 100,
          },
        },
      },
      
      
      
      Region = 
      {
        Width = 20,
        Height = 20,
        
        Textures = 
        {
          dirt = love.graphics.newImage("Textures/Map/dirt.png"), 
        },
        
        Draw = function(self, x, y)
          for l = -self.Height, self.Height do
            for c = -self.Width, self.Width do
              local SoilType = self.Grid[l][c].SoilType
              local Ore = self.Grid[l][c].Ore
              
              if self.Grid[l][c].Entity and self.Grid[l][c].Entity.Collide then
                Color.Set(Color.BlueLite)
              else
                Color.Set(Color.White)
              end
              
              love.graphics.draw(self.Textures[SoilType], c*32 + x, l*32 + y)
              if Ore then
                for k, v in ipairs(Ore) do
                  love.graphics.draw(v.Texture, c*32+x+16, l*32+y+16,v.Angle,1,1,16,16)
                end
              end
            end
          end
          Color.Set(Color.Yellow)
          love.graphics.rectangle("fill", x-20*32-1, y-20*32-1, 3, 3)
        end,
        
        Init = function(self)
          self.Grid = {}
          for l = -self.Height, self.Height do -- -20 to 20 there is 41 number because of the 0 
            self.Grid[l] = {}
            for c = -self.Width, self.Width do -- -20 to 20 there is 41 number because of the 0 
              self.Grid[l][c] = 
              {
                SoilType = "dirt",
              }
            end
          end
        end,
        
        GenerateOrePatch = function(self, oreList)
          math.randomseed(math.random())
          for k, oreID in ipairs(oreList) do
            local Ore = Game.Prototypes.Ore[oreID]
            local x1 = math.floor(math.random() * (self.Width * 2 - 14) + 7)-20
            local y1 = math.floor(math.random() * (self.Height * 2 - 14) + 7)-20
            local x2 = math.floor(math.random() * (self.Width * 2 - 14) + 7)-20
            local y2 = math.floor(math.random() * (self.Height * 2 - 14) + 7)-20
            local r1 = math.floor(math.random() * (7-3) + 3)
            local r2 = math.floor(math.random() * (7-3) + 3)
            
            --print(x1, y1, x2, y2)
            
            for l = -self.Height, self.Height do
              for c = -self.Width, self.Width do
                if (c - x1)^2 + (l - y1)^2 < r1^2 or (c - x2)^2 + (l - y2)^2 < r2^2 then
                  if not self.Grid[l][c].Ore then self.Grid[l][c].Ore = {} end
                  table.insert(
                    self.Grid[l][c].Ore,
                    {
                      Count = math.floor(math.random() * (Ore.MaxCount-Ore.MinCount)+Ore.MinCount),
                      Angle = math.random() * 2 * math.pi,
                    }
                  )
                  setmetatable(self.Grid[l][c].Ore[#self.Grid[l][c].Ore], {__index = Game.Prototypes.Ore[oreID]})
                end
              end
            end
          end
        end,
        
      },
    },
    
  }
  
  Game.Prototypes:Init()
  for k,v in pairs(Game) do
    if v.Init ~= nil then v:Init() end
  end
  Game.Maps:Init()
  
end

function love.keypressed(Key)
  
  for __,v in pairs(Game) do
    if v.KeyPressed ~= nil then v:KeyPressed(Key) end
  end
  
  if Key == "space" then Game.Maps:Init() end
  
end

function love.mousepressed(X, Y, Button)
  
  for __,v in pairs(Game) do
    if v.MousePressed ~= nil then v:MousePressed(X, Y, Button) end
  end
  
  if Key == "space" then Game.Maps:Init() end
  
end

function love.update(dt)
  
  for k,v in pairs(Game) do
    if v.Update ~= nil then v:Update(dt) end
  end
  
end

function love.draw()
  
  for k,v in pairs(Game) do
    if v.Draw ~= nil then v:Draw() end
  end
  
  
  Color.Set(Color.White)
  love.graphics.rectangle("fill", ScreenWidth/2, ScreenHeight/2, 1, 1)
end
