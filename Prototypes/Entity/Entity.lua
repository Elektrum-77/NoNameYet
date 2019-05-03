local Entity = 
{
  Furnace =
  {
    RecipeType = "Smelting",
    Energy = {Type = "Burner", ConsuptionMultiplier = 2.5},
    Width = 2,
    Height = 2,
    Input = {Max = 1},
    Output = {Max = 1},
    Texture = love.graphics.newImage("Textures/Furnace.png"),
    
    Init = function(self)
      self.Input.Inventory = {}
      self.Output.Inventory = {}
      self.Energy.Inventory = {}
    end,
  },
  OreCrackingStation =
  {
    RecipeType = "OreCracking",
    Energy = {Type = "Burner", ConsuptionMultiplier = 2.5},
    Width = 2,
    Height = 2,
    Input = {Max = 2},
    Output = {Max = 4},
    Texture = love.graphics.newImage("Textures/Furnace.png"),
    
    Init = function(self)
      self.Input.Inventory = {}
      self.Output.Inventory = {}
      self.Energy.Inventory = {}
    end,
  },
}

for k,v in pairs(Entity) do
  Game.Prototypes.Entity[k] = v
end