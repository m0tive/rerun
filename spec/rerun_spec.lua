-- Get the args from the first param
local args = ...

require("busted")

describe("sandpit suite", function()
  describe("first test", function()
    it("is ok?", function()
      assert.truthy("Yup.")
    end)

    it("what is the args string?", function()
      local s = tostring(args)
      if type(args) == "table" then
        for k, v in pairs(args) do
          s = ("%s[%s]=%s, "):format(s, tostring(k), tostring(v))
        end
      end
      assert.falsy(s)
    end)
  end)
end)
