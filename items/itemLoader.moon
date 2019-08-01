--+---------------+--
--| No dependency |--
--+---------------+--
require "items.item"

--+-----------------+--
--| Depends on item |--
--+-----------------+--
require "items.itemBox"
require "items.nullItem"
require "items.passiveItem"
require "items.activeItem"

--+------------------------+--
--| Depends on active item |--
--+------------------------+--
require "items.empActive"
require "items.bombActive"
require "items.dashActive"
require "items.charmActive"
require "items.cloneActive"
require "items.trailActive"
require "items.freezeActive"
require "items.poisonActive"
require "items.jacketActive"
require "items.deadeyeActive"
require "items.healingActive"
require "items.missileActive"
require "items.stealthActive"
require "items.wholeHogActive"
require "items.blackHoleActive"
require "items.soulCollectActive"
require "items.dragonStrikeActive"
require "items.earthShatterActive"

--+-------------------------+--
--| Depends on passive item |--
--+-------------------------+--
require "items.bombPassive"
require "items.trailPassive"
require "items.missilePassive"
require "items.extraLifePassive"
require "items.healthBoostPassive"
require "items.damageAbsorbPassive"
require "items.damageReflectPassive"

--+------------------+--
--| Depends on items |--
--+------------------+--
require "items.itemPool"
