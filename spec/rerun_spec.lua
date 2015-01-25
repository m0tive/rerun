package.path = "./lib/?.lua;./spec/?.lua;" .. package.path

local rerun = require 'rerun'

require 'busted'

describe("core suite", function()
  describe("basics", function()
    it("exists", function()
      assert.truthy(rerun)
    end)

    it("can require a simple file", function()
      assert.are.same({}, rerun.stack)
      assert.are.same({}, rerun.dependency)

      -- Dot syntax works
      assert.truthy(rerun.require("testdata.basic"))

      assert.are.same({
          ["testdata.basic"] = {},
        }, rerun.dependency)

      assert.are.same({}, rerun.stack)

      -- Paths are not allowed
      assert.error(function() return rerun.require("testdata/basic.lua") end)
    end)

    it("can reset internals", function()
      assert.are.same({
          ["testdata.basic"] = {},
        }, rerun.dependency)
      assert.are.same({}, rerun.stack)

      rerun.reset()

      assert.are.same({}, rerun.stack)
      assert.are.same({}, rerun.dependency)
    end)

    it("can require a file with inner requires", function()
      rerun.reset()
      assert.truthy(rerun.require("testdata.nested"))

      assert.are.same({
          ["testdata.nested"] = {},
          ["testdata.nested_sub1"] = { ["testdata.nested"] = true, },
        }, rerun.dependency)
      assert.are.same({}, rerun.stack)
    end)
  end)
end)
