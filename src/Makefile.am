# Makefile.am for iplb/src

yncludedir = @yncludedir@/iplb

client_DATA =			\
	iplb.ycp		\
	iplb_auto.ycp	\
	iplb_proposal.ycp

ynclude_DATA =			\
	helps.ycp		\
	wizards.ycp		\
	dialogs.ycp		\
	common.ycp		\
	global_conf.ycp		\
	vserver_conf.ycp		\
	complex.ycp

desktop_DATA =			\
	iplb.desktop

module_DATA =			\
	Iplb.ycp		

# create a symlink for local build, #145327
iplb:
	ln -sf . $@
ycpchook = iplb

EXTRA_DIST = $(client_DATA) $(ynclude_DATA) $(module_DATA) $(desktop_DATA)

include $(top_srcdir)/Makefile.am.common
