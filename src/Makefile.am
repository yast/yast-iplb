# Sources for iplb

module_DATA = \
  modules/Iplb.rb

client_DATA = \
  clients/iplb_auto.rb \
  clients/iplb.rb \
  clients/iplb_proposal.rb

yncludedir = @yncludedir@/iplb
ynclude_DATA = \
  include/iplb/dialogs.rb \
  include/iplb/common.rb \
  include/iplb/complex.rb \
  include/iplb/vserver_conf.rb \
  include/iplb/helps.rb \
  include/iplb/global_conf.rb \
  include/iplb/wizards.rb

scrconf_DATA = \
  scrconf/iplb.scr

desktop_DATA = \
  desktop/iplb.desktop

EXTRA_DIST = $(module_DATA) $(client_DATA) $(ynclude_DATA) $(scrconf_DATA) $(desktop_DATA)

include $(top_srcdir)/Makefile.am.common