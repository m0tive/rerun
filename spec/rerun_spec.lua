package.path = "./lib/?.lua;" .. package.path

local rerun = require 'rerun'

require 'busted'

describe("core suite", function()
  describe("basics", function()
    it("got rerun?", function()
      assert.truthy(rerun)
    end)
  end)
end)
