package.path = "./lib/?.lua;./?.lua" .. package.path

local rerun = require 'rerun'

require 'busted'

describe("core suite", function()
  describe("basics", function()
    it("exists", function()
      assert.truthy(rerun)
    end)

    it("can require a simple file", function()
      assert.truthy(rerun.require("testdata.basic"))
    end)
  end)
end)
