# encoding: utf-8

module Yast
  class IplbClient < Client
    def main
      # testedfiles: Iplb.ycp

      #include "testsuite.ycp";
      #TESTSUITE_INIT([], nil);

      Yast.import "Iplb" 

      #DUMP("Iplb::Modified");
      #TEST(``(Iplb::Modified()), [], nil);

      nil
    end
  end
end

Yast::IplbClient.new.main
