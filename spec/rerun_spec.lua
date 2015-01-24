package.path = "./lib/?.lua;./?.lua" .. package.path

local rerun = require 'rerun'

require 'busted'

describe("core suite", function()
  describe("basics", function()
    it("exists", function()
      assert.truthy(rerun)
    end)

    it("can require a simple file", function()
      -- Dot syntax works
      assert.truthy(rerun.require("testdata.basic"))

      -- Paths are not allowed
      assert.error(function() return rerun.require("testdata/basic.lua") end)
    end)
  end)
end)
