package.path = "./lib/?.lua;./spec/?.lua;" .. package.path

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

    it("can require a file with inner requires", function()
      assert.truthy(rerun.require("testdata.nested"))

      assert.are.equal({
          ["testdata.nested"] = {},
          ["testdata.nested_sub1"] = { ["testdata.nested"] = true, },
        }, rerun.dependency)
    end)
  end)
end)
