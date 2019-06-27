queue = {}

--+------------+--
--| Load utils |--
--+------------+--
table.insert queue, "utils.utilsLoader"
table.insert queue, "logic.timer"

--+---------+--
--| Load ui |--
--+---------+--
table.insert queue, "ui.uiLoader"

--+------------------+--
--| Depends on utils |--
--+------------------+--
table.insert queue, "logic.cameraHandler"
table.insert queue, "logic.gameObject"
table.insert queue, "logic.player"
table.insert queue, "logic.collision"

--+--------------+--
--| Load Enemies |--
--+--------------+--
table.insert queue, "enemies.enemyLoader"

--+-------------------------+--
--| Load background objects |--
--+-------------------------+--
table.insert queue, "backgrounds.backgroundLoader"

--+------------------+--
--| Load Projectiles |--
--+------------------+--
table.insert queue, "projectiles.projectileLoader"

--+-------------+--
--| Load Bosses |--
--+-------------+--
table.insert queue, "bosses.bossLoader"

--+----------------+--
--| Load particles |--
--+----------------+--
table.insert queue, "particles.particleLoader"

--+------------+--
--| Load items |--
--+------------+--
table.insert queue, "items.itemLoader"

--+--------------+--
--| Load weapons |--
--+--------------+--
table.insert queue, "weapons.weaponLoader"

--+-------------+--
--| Load levels |--
--+-------------+--
table.insert queue, "levels.levelLoader"

--+--------------+--
--| Load screens |--
--+--------------+--
table.insert queue, "screens.screenLoader"

--+---------------+--
--| Load debugger |--
--+---------------+--
table.insert queue, "logic.autoComplete"
table.insert queue, "logic.debugger"
table.insert queue, "logic.score"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
table.insert queue, "logic.driver"

return queue
