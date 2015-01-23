local args = { n = select('#', ...), ... }
print(...)

require("busted")

describe("sandpit suite", function()
  describe("first test", function()
    it("is ok?", function()
      assert.truthy("Yup.")
    end)

    it("what is the args string?", function()
      local s = ""
      for i=1, args.n do
        s = s .. ("%q"):format(tostring(args[i])) .. " "
      end
      assert.falsy(s)
    end)
  end)
end)
