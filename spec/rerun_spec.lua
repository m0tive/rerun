package.path = "./lib/?.lua;./?.lua" .. package.path

local rerun = require 'rerun'

require 'busted'

describe("core suite", function()
  describe("basics", function()
    it("got rerun?", function()
      assert.truthy(rerun)
    end)

    it("can require?", function()
      assert.truthy(rerun.require("testdata"))
    end)
  end)
end)
