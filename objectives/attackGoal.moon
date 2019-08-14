export class AttackGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/portal.tga", 56, 56, 1, 1.1
    color = {127, 0, 100, 255}
    sprite\setColor color
    sprite\setRotationSpeed math.pi * -0.75
    super x, y, sprite
    @goal_type = GoalTypes.attack
    @health = math.min 690, 50 + (107 * Objectives\getScaling!)
    @max_health = @health
    @item_drop_chance = 0.2
    @score_value = 100
    @exp_given = @score_value + (@score_value * 0.25 * Objectives\getLevel!)
    @colliders = {EntityTypes.player, EntityTypes.enemy}
