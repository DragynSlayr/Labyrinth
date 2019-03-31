export EntityTypes = {}

EntityTypes.player     = "Player"
EntityTypes.enemy      = "Enemy"
EntityTypes.item       = "Item"
EntityTypes.health     = "Health"
EntityTypes.coin       = "Coin"
EntityTypes.bullet     = "Bullet"
EntityTypes.goal       = "Goal"
EntityTypes.background = "Background"
EntityTypes.wall       = "Wall"
EntityTypes.particle   = "Particle"
EntityTypes.boss       = "Boss"

EntityTypes.layers = {}

EntityTypes.layers[EntityTypes.wall]       = 1
EntityTypes.layers[EntityTypes.background] = 2
EntityTypes.layers[EntityTypes.particle]   = 3
EntityTypes.layers[EntityTypes.bullet]     = 4
EntityTypes.layers[EntityTypes.coin]       = 5
EntityTypes.layers[EntityTypes.item]       = 5
EntityTypes.layers[EntityTypes.health]     = 5
EntityTypes.layers[EntityTypes.goal]       = 6
EntityTypes.layers[EntityTypes.boss]       = 7
EntityTypes.layers[EntityTypes.enemy]      = 7
EntityTypes.layers[EntityTypes.player]     = 8

EntityTypes.order = {
  EntityTypes.wall,
  EntityTypes.background,
  EntityTypes.particle,
  EntityTypes.bullet,
  EntityTypes.coin,
  EntityTypes.item,
  EntityTypes.health,
  EntityTypes.goal,
  EntityTypes.boss,
  EntityTypes.enemy,
  EntityTypes.player
}

export ModeTypes = {}

ModeTypes.dark        = "Dark Mode"
ModeTypes.elimination = "Elimination Mode"
ModeTypes.attack      = "Attack Mode"
ModeTypes.defend      = "Defend Mode"
ModeTypes.capture     = "Capture Mode"
ModeTypes.test        = "Test Mode"
ModeTypes.boss        = "Boss Mode"

export GoalTypes = {}

GoalTypes.attack    = "Attack"
GoalTypes.defend    = "Defend"
GoalTypes.find      = "Find"
GoalTypes.fake_find = "Fake Find"
GoalTypes.capture   = "Capture"
GoalTypes.tesseract = "Tesseract"

export EnemyTypes = {}

EnemyTypes.player  = "PlayerEnemy"
EnemyTypes.spawner = "SpawnerEnemy"
EnemyTypes.strong  = "StrongEnemy"
EnemyTypes.basic   = "BasicEnemy"
EnemyTypes.capture = "CaptureEnemy"

export ParticleTypes = {}

ParticleTypes.normal       = "NormalParticle"
ParticleTypes.poison       = "PoisonParticle"
ParticleTypes.enemy_poison = "EnemyPoisonParticle"

export ItemTypes = {}

ItemTypes.passive = "PassiveItem"
ItemTypes.active  = "ActiveItem"

export ItemFrameTypes = {}

ItemFrameTypes.passive  = "PassiveFrame"
ItemFrameTypes.active   = "ActiveFrame"
ItemFrameTypes.transfer = "Transfer"
ItemFrameTypes.default  = "Default"

export BossTypes = {}

BossTypes.vyder   = "Vyder"
BossTypes.test    = "Test Boss"
BossTypes.serpent = "Serpent"

export Scaling = {}

Scaling.health = 5
Scaling.damage = 0.5
Scaling.speed  = 5

export calcScreen = () ->
  export Screen_Size = {}

  Screen_Size.width       = love.graphics.getWidth!
  Screen_Size.height      = love.graphics.getHeight!
  Screen_Size.half_width  = Screen_Size.width / 2
  Screen_Size.half_height = Screen_Size.height / 2
  Screen_Size.bounds      = {0, 0, Screen_Size.width, Screen_Size.height}
  Screen_Size.size        = {Screen_Size.width, Screen_Size.height}

  export Scale = {}

  Scale.width  = Screen_Size.width / 1920
  Scale.height = Screen_Size.height / 1080
  a = (1920 * 1920) + (1080 * 1080)
  b = (Screen_Size.width * Screen_Size.width) + (Screen_Size.height * Screen_Size.height)
  Scale.diag   = (math.sqrt b) / (math.sqrt a)

  Screen_Size.border = {0, 70 * Scale.height, Screen_Size.width, Screen_Size.height - (140 * Scale.height)}

calcScreen!

export Base_Stats = {}

Base_Stats.player = {}

-- "Health", "Range", "Damage", "Speed", "Attack Delay"
Base_Stats.player[1] = 6.25
Base_Stats.player[2] = 75 * Scale.diag
Base_Stats.player[3] = 1.25
Base_Stats.player[4] = 275 * Scale.diag
Base_Stats.player[5] = 1 / 10--1 / 75

export Item_Rarity = {}

Item_Rarity[1] = {0, 0, 0, 255}      -- Black
Item_Rarity[2] = {0, 220, 83, 255}   -- Green
Item_Rarity[3] = {37, 136, 255, 255} -- Blue
Item_Rarity[4] = {180, 0, 180, 255}  -- Purple
Item_Rarity[5] = {255, 182, 24, 255} -- Orange

export Item_Rarity_Text = {}

for k, v in pairs Item_Rarity
  Item_Rarity_Text[k] = {}
  for k2, v2 in pairs v
    table.insert Item_Rarity_Text[k], (math.min v2 + 127, 255) * 0.75

export Screen_State = {}

Screen_State.main_menu  = "Main Menu"
Screen_State.pause_menu = "Pause Menu"
Screen_State.game_over  = "Game Over"
Screen_State.scores     = "Scores"
Screen_State.loading    = "Loading"
Screen_State.none       = "None"
Screen_State.settings   = "Settings"
Screen_State.controls   = "Controls"

export Game_State = {}

Game_State.main_menu = "Main Menu"
Game_State.paused    = "Paused"
Game_State.game_over = "Game Over"
Game_State.playing   = "Playing"
Game_State.none      = "None"
Game_State.settings  = "Settings"
Game_State.controls  = "Controls"
