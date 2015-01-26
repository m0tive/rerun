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
          ["testdata.nested_subsub"] = { ["testdata.nested_sub1"] = true, },
        }, rerun.dependency)
      assert.are.same({}, rerun.stack)

      rerun.clear()
      assert.truthy(rerun.require("testdata.complex"))

      assert.are.same({
          ["testdata.complex"] = {},
          ["testdata.basic"] = { ["testdata.complex"] = true, },
          ["testdata.nested"] = { ["testdata.complex"] = true, },
          ["testdata.nested_sub1"] = { ["testdata.nested"] = true, },
          ["testdata.nested_subsub"] = {
            ["testdata.nested_sub1"] = true,
            ["testdata.complex"] = true,
          },
        }, rerun.dependency)
      assert.are.same({}, rerun.stack)
    end)

    it("can list the files dependent on a package", function()
      rerun.clear()
      rerun.require("testdata.complex")

      assert.are.same({}, rerun.get_dependent("testdata.complex"))
      assert.are.same({
          "testdata.complex",
        }, rerun.get_dependent("testdata.nested"))
      assert.are.same({
          "testdata.nested",
          "testdata.complex",
        }, rerun.get_dependent("testdata.nested_sub1"))
      assert.are.same({
          "testdata.nested_sub1",
          "testdata.nested",
          "testdata.complex",
        }, rerun.get_dependent("testdata.nested_subsub"))

      -- items unknown to rerun should safely return no dependants
      assert.are.same({}, rerun.get_dependent("testdata.missing"))
    end)
  end)
end)
