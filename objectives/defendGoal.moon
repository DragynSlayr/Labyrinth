export class DefendGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/defend.tga", 26, 27, 1, 2
    color = {0, 127, 100, 255}
    --sprite\setColor color
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.defend
    @health = math.min 185, 20 + (27.5 * Objectives\getScaling!)
    @max_health = @health
    @colliders = {EntityTypes.player, EntityTypes.enemy}
