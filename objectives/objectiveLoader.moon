--+---------------+--
--| No dependency |--
--+---------------+--
require "objectives.attackGoal"
require "objectives.defendGoal"
require "objectives.findGoal"
require "objectives.captureGoal"
require "objectives.tesseractGoal"
require "objectives.fakeFindGoal"
require "objectives.mode"
require "objectives.wave"

--+-----------------+--
--| Depends on mode |--
--+-----------------+--
require "objectives.eliminationMode"
require "objectives.attackMode"
require "objectives.defendMode"
require "objectives.darkMode"
require "objectives.captureMode"
require "objectives.testMode"
require "objectives.bossMode"

--+-----------------+--
--| Depends on wave |--
--+-----------------+--
require "objectives.eliminationWave"
require "objectives.attackWave"
require "objectives.defendWave"
require "objectives.darkWave"
require "objectives.captureWave"
require "objectives.testWave"
require "objectives.bossWave"

--+------------------------------+--
--| Dependent on everything else |--
--+------------------------------+--
require "objectives.objectives"
