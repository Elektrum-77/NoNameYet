local Ore = 
{
  IronOre =
  {
    Item = "IronOre",
    Name = "iron ore",
    Texture = love.graphics.newImage("Textures/iron-ore.png"),
    MinCount = 150,
    MaxCount = 450,
  },
  CopperOre =
  {
    Item = "CopperOre",
    Name = "copper ore",
    Texture = love.graphics.newImage("Textures/copper-ore.png"),
    MinCount = 150,
    MaxCount = 450,
  },
  StoneOre =
  {
    Item = "StoneOre",
    Name = "stone",
    Texture = love.graphics.newImage("Textures/stone-ore.png"),
    MinCount = 125,
    MaxCount = 250,
  },
  GoldOre =
  {
    Item = "GoldOre",
    Name = "gold ore",
    Texture = love.graphics.newImage("Textures/gold-ore.png"),
    MinCount = 125,
    MaxCount = 250,
  },
  CoalOre =
  {
    Item = "CoalOre",
    Name = "coal ore",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Gibbsite =
  {
    Item = "Gibbsite",
    Name = "gibbsite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Diaspore =
  {
    Item = "Diaspore",
    Name = "diaspore",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Chromite =
  {
    Item = "Chromite",
    Name = "chromite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Stannite =
  {
    Item = "Stannite",
    Name = "stannite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Magnetite =
  {
    Item = "Magnetite",
    Name = "magnetite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Hematite =
  {
    Item = "Hematite",
    Name = "hematite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Gallium =
  {
    Item = "Gallium",
    Name = "gallium",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Pyrolusite =
  {
    Item = "Pyrolusite",
    Name = "pyrolusite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Romanechite =
  {
    Item = "Romanechite",
    Name = "romanechite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Rhodocrosite =
  {
    Item = "Rhodocrosite",
    Name = "rhodocrosite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Braunite =
  {
    Item = "Braunite",
    Name = "braunite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Quartz =
  {
    Item = "Quartz",
    Name = "quartz",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Microlite =
  {
    Item = "Microlite",
    Name = "microlite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Cassiterite =
  {
    Item = "Cassiterite",
    Name = "cassiterite",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Rutile =
  {
    Item = "Rutile",
    Name = "rutile",
    Texture = love.graphics.newImage("Textures/coal-ore.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Ilmenite =
  {
    Item = "Ilmenite",
    Name = "ilmenite",
    Texture = love.graphics.newImage("Textures/Ilmenite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Wolframite =
  {
    Item = "Wolframite",
    Name = "wolframite",
    Texture = love.graphics.newImage("Textures/Wolframite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Uranothorianite =
  {
    Item = "Uranothorianite",
    Name = "uranothorianite",
    Texture = love.graphics.newImage("Textures/Uranothorianite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Uranothorite =
  {
    Item = "Uranothorite",
    Name = "uranothorite",
    Texture = love.graphics.newImage("Textures/Uranothorite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Uraninite =
  {
    Item = "Uraninite",
    Name = "uraninite",
    Texture = love.graphics.newImage("Textures/Uraninite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Coffinite =
  {
    Item = "Coffinite",
    Name = "coffinite",
    Texture = love.graphics.newImage("Textures/Coffinite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Brannerite =
  {
    Item = "Brannerite",
    Name = "brannerite",
    Texture = love.graphics.newImage("Textures/Brannerite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
  Carnotite =
  {
    Item = "Carnotite",
    Name = "carnotite",
    Texture = love.graphics.newImage("Textures/Carnotite.png"),
    MinCount = 250,
    MaxCount = 650,
  },
}

for k,v in pairs(Ore) do
  Game.Prototypes.Ore[k] = v
end