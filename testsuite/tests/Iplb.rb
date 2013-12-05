# encoding: utf-8

module Yast
  class IplbClient < Client
    def main
      # testedfiles: Iplb.ycp

      Yast.include self, "testsuite.rb"
      TESTSUITE_INIT([], nil)

      Yast.import "Iplb"

      DUMP("Iplb::Modified")
      TEST(lambda { Iplb.Modified() }, [], nil)

      nil
    end
  end
end

Yast::IplbClient.new.main
