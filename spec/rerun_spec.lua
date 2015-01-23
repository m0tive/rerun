require("busted")

describe("test suite", function()
  describe("test", function()
    it("is ok?", function()
      assert.truthy("Yup.")
    end)

    it("do a bad thing", function()
      assert.truthy(nil)
    end)
  end)
end)
