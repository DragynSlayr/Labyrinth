--+---------------+--
--| No dependency |--
--+---------------+--
require "utils.color"
require "utils.renderer"
require "utils.utils"
require "utils.sound"
require "utils.linkedList"

--+------------------+--
--| Depends on sound |--
--+------------------+--
require "utils.musicHandler"

--+------------------------+--
--| Depends on linked list |--
--+------------------------+--
require "utils.stack"
require "utils.trie"

--+--------------------+--
--| Basic math classes |--
--+--------------------+--
require "utils.vector"
require "utils.point"
require "utils.circle"
require "utils.rectangle"

--+-------------------------+--
--| Depends on math classes |--
--+-------------------------+--
require "utils.sprite"

--+-------------------+--
--| Depends on sprite |--
--+-------------------+--
require "utils.actionSprite"
require "utils.resourceCacher"
