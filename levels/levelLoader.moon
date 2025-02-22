--+---------------+--
--| No dependency |--
--+---------------+--
require "levels.wall"
require "levels.spawner"

--+-----------------+--
--| Depends on wall |--
--+-----------------+--
require "levels.room"

--+-----------------+--
--| Depends on room |--
--+-----------------+--
require "levels.level"

--+------------------+--
--| Depends on level |--
--+------------------+--
require "levels.levelHandler"
require "levels.worldHandler"
require "levels.worldCreator"
