# encoding: utf-8

# ------------------------------------------------------------------------------
# Copyright (c) 2006 Novell, Inc. All Rights Reserved.
#
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, contact Novell, Inc.
#
# To contact Novell about this file by physical or electronic mail, you may find
# current contact information at www.novell.com.
# ------------------------------------------------------------------------------

# File:	clients/iplb.ycp
# Package:	Configuration of iplb
# Summary:	Main file
# Authors:	Cong Meng <cmeng@novell.com>
#
# $Id: iplb.ycp 27914 2006-02-13 14:32:08Z locilka $
#
# Main file for iplb configuration. Uses all other files.
module Yast
  module IplbGlobalConfInclude
    def initialize_iplb_global_conf(include_target)
      textdomain "iplb"
      Yast.import "Label"
      Yast.import "Wizard"
      Yast.import "Iplb"

      Yast.include include_target, "iplb/helps.rb"
      Yast.include include_target, "iplb/common.rb"


      # ids of widget of global dialog
      @global_entries = [
        :checkinterval,
        :checktimeout,
        :failurecount,
        :negotiatetimeout,
        :fallback,
        :logfile,
        :emailalert,
        :emailalertfreq,
        :emailalertstatus,
        :callback,
        :execute,
        :autoreload,
        :quiescent,
        :fork,
        :supervised
      ]

      @yesno = ["", "yes", "no"]
    end

    def global_layout
      VBox(
        DumbTab(
          [
            Item(Id(:global_tab), "&Global Configuration", true),
            Item(Id(:vserver_tab), "&Virtual Server Configuration")
          ],
          VBox(
            VSpacing(0.7),
            HBox(
              HSpacing(0.7),
              TextEntry(Id(:checkinterval), _("Check Interval"), ""),
              TextEntry(Id(:checktimeout), _("Check Timeout"), ""),
              TextEntry(Id(:failurecount), _("Failure Count"), ""),
              TextEntry(Id(:negotiatetimeout), _("Negotiate Timeout"), "")
            ),
            VSpacing(1),
            HBox(
              HSpacing(0.7),
              VBox(
                TextEntry(Id(:fallback), _("Fallback"), ""),
                TextEntry(Id(:callback), _("Callback"), ""),
                TextEntry(Id(:execute), _("Execute"), "")
              ),
              HSpacing(3),
              VBox(
                TextEntry(Id(:emailalert), _("Email Alert"), ""),
                TextEntry(Id(:emailalertfreq), _("Email Alert Freq"), ""),
                TextEntry(Id(:emailalertstatus), _("Email Alert Status"), "")
              )
            ),
            VSpacing(2),
            HBox(
              HSpacing(0.7),
              HBox(
                ComboBox(Id(:autoreload), _("Auto Reload"), @yesno),
                ComboBox(Id(:quiescent), _("Quiescent"), @yesno),
                ComboBox(Id(:fork), _("Fork"), @yesno),
                ComboBox(Id(:supervised), _("Supervised"), @yesno)
              ),
              HSpacing(3),
              VBox(TextEntry(Id(:logfile), _("Log File"), ""))
            ),
            VStretch()
          )
        )
      )
    end


    # fill the widgets accord to the Iplb::global_conf
    def fill_global_entries
      l_global_conf = deep_copy(Iplb.global_conf)

      Builtins.foreach(@global_entries) do |key|
        name = Builtins.substring(Builtins.tostring(key), 1) # remove '`' char
        val = Ops.get_string(l_global_conf, name, "")
        if Ops.greater_than(Builtins.size(val), 0)
          UI.ChangeWidget(key, :Value, val)
        end
      end

      nil
    end


    # retrieve the value from widgets, save to Iplb::global_conf
    def retrieve_global_entries
      l_global_conf = deep_copy(Iplb.global_conf)

      Builtins.foreach(@global_entries) do |key|
        name = Builtins.substring(Builtins.tostring(key), 1) # remove '`' char
        val_old = Ops.get_string(l_global_conf, name, "")
        val_new = Convert.to_string(UI.QueryWidget(key, :Value))
        if Ops.greater_than(Builtins.size(val_new), 0)
          Ops.set(l_global_conf, name, val_new)
        elsif Ops.greater_than(Builtins.size(val_old), 0)
          # assigning nil to remove it from conf file
          Ops.set(l_global_conf, name, nil)
        end
      end

      Iplb.global_conf = Convert.convert(
        l_global_conf,
        :from => "map",
        :to   => "map <string, string>"
      )

      nil
    end


    # the entry to golbal configure stuff
    # return `ok, `cancel or `vserver_tab
    def global_dialog
      ret = nil

      my_SetContents("global_conf", global_layout)
      fill_global_entries

      while true
        ret = UI.UserInput

        myHelp("global_conf") if ret == :help

        break if ret == :cancel && ReallyAbort()

        break if ret == :ok || ret == :vserver_tab
      end

      retrieve_global_entries
      deep_copy(ret)
    end
  end
end
