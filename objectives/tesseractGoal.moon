export class TesseractGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/tesseract.tga", 32, 32, 1, 56 / 32
    --color = {127, 0, 100, 255}
    --sprite\setColor color
    --sprite\setRotationSpeed math.pi * -0.75
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.tesseract
    @health = 100
    @max_health = @health
    @reduction = 0
    @solid = false
    @item_drop_chance = 0.1
    @score_value = 75
    @exp_given = @score_value + (@score_value * 0.25 * Objectives\getLevel!)

  onCollide: (entity) =>
    start_damage = entity.damage
    entity.damage *= @reduction
    super entity
    entity.damage = start_damage

  update: (dt) =>
    super dt
    health = 0
    max_health = 0
    for k, g in pairs Driver.objects[EntityTypes.goal]
      if g.capture_amount
        health += g.capture_amount
        max_health += g.max_health
    @reduction = health / max_health
