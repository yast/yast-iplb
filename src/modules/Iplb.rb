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

# File:	modules/Iplb.ycp
# Package:	Configuration of iplb
# Summary:	Iplb settings, input and output functions
# Authors:	Cong Meng <cmeng@novell.com>
#
# $Id: Iplb.ycp 41350 2007-10-10 16:59:00Z dfiser $
#
# Representation of the configuration of iplb.
# Input and output routines.
require "yast"

module Yast
  class IplbClass < Module
    def main
      textdomain "iplb"

      Yast.import "Progress"
      Yast.import "Report"
      Yast.import "Summary"
      Yast.import "Message"
      Yast.import "IP"

      # the global configure
      @global_conf = {}
      # the virtual servers configure
      @vserver_conf = {}

      # Data was modified?
      @modified = false


      @proposal_valid = false

      # Write only, used during autoinstallation.
      # Don't run services and SuSEconfig, it's all done at one place.
      @write_only = false

      # Abort function
      # return boolean return true if abort
      @AbortFunction = fun_ref(method(:Modified), "boolean ()")



      @quote_list = [
        "callback",
        "logfile",
        "emailalert",
        "execute",
        "checkcommand",
        "request",
        "receive",
        "virtualhost",
        "login",
        "passwd",
        "database",
        "secret"
      ]
    end

    # Abort function
    # @return [Boolean] return true if abort
    def Abort
      return @AbortFunction.call == true if @AbortFunction != nil
      false
    end

    # Data was modified?
    # @return true if modified
    def Modified
      Builtins.y2debug("modified=%1", @modified)
      @modified
    end

    # Mark as modified, for Autoyast.
    def SetModified
      @modified = true

      nil
    end

    def ProposalValid
      @proposal_valid
    end

    def SetProposalValid(value)
      @proposal_valid = value

      nil
    end

    # @return true if module is marked as "write only" (don't start services etc...)
    def WriteOnly
      @write_only
    end

    # Set write_only flag (for autoinstalation).
    def SetWriteOnly(value)
      @write_only = value

      nil
    end


    def SetAbortFunction(function)
      function = deep_copy(function)
      @AbortFunction = deep_copy(function)

      nil
    end


    def remove_quote(str)
      str = Builtins.regexpsub(str, "^\"?(.*)", "\\1")
      if Builtins.regexpmatch(str, ".*\"$")
        str = Builtins.regexpsub(str, "^(.*)\"$", "\\1")
      end
      str
    end


    def remove_global_conf_quote
      Builtins.foreach(@global_conf) do |key, val|
        if Builtins.contains(@quote_list, key)
          Ops.set(
            @global_conf,
            key,
            remove_quote(Ops.get(@global_conf, key, ""))
          )
        end
      end

      nil
    end


    def add_global_conf_quote
      remove_global_conf_quote
      Builtins.foreach(@global_conf) do |key, val|
        if Builtins.contains(@quote_list, key)
          Ops.set(
            @global_conf,
            key,
            Ops.add(Ops.add("\"", Ops.get(@global_conf, key, "")), "\"")
          )
        end
      end

      nil
    end


    def remove_vserver_conf_quote
      Builtins.foreach(@vserver_conf) do |key1, val1|
        Builtins.foreach(
          Convert.convert(val1, :from => "map", :to => "map <string, list>")
        ) do |key2, val2|
          if Builtins.contains(@quote_list, key2)
            Ops.set(val2, 0, remove_quote(Ops.get_string(val2, 0, "")))
            Ops.set(@vserver_conf, [key1, key2], val2)
          end
        end
      end

      nil
    end


    def add_vserver_conf_quote
      remove_vserver_conf_quote
      Builtins.foreach(@vserver_conf) do |key1, val1|
        Builtins.foreach(
          Convert.convert(val1, :from => "map", :to => "map <string, list>")
        ) do |key2, val2|
          if Builtins.contains(@quote_list, key2)
            Ops.set(
              val2,
              0,
              Ops.add(Ops.add("\"", Ops.get_string(val2, 0, "")), "\"")
            )
            Ops.set(@vserver_conf, [key1, key2], val2)
          end
        end
      end

      nil
    end


    # Read all iplb settings
    # @return true on success
    def Read
      pair_names = []
      caption = _("Initializing IPLB Configuration")

      # Names of real stages
      Progress.New(
        caption,
        " ",
        3,
        [_("Read the global settings"), _("Read the virtual host settings")],
        [
          _("Reading the global settings..."),
          _("Reading the virtual host settings..."),
          _("Finished")
        ],
        ""
      )

      #///////////////////////////////
      # read global configure
      #///////////////////////////////
      # dir all global configure names
      pair_names = SCR.Dir(path(".iplb.value"))

      # read global configure values
      @global_conf = {}
      Builtins.foreach(pair_names) do |key|
        vals = Convert.convert(
          SCR.Read(Ops.add(path(".iplb.value"), Builtins.topath(key))),
          :from => "any",
          :to   => "list <string>"
        )
        Ops.set(@global_conf, key, Ops.get(vals, 0, ""))
      end

      remove_global_conf_quote

      Builtins.y2debug("___iplbdebug___ read global_conf = %1", @global_conf)
      Progress.NextStage


      #///////////////////////////////
      # read vservers configure
      #///////////////////////////////
      # dir all vserver names
      vserver_names = SCR.Dir(path(".iplb.section"))

      # iterate all vserver names
      Builtins.foreach(vserver_names) do |vs_name|
        Ops.set(@vserver_conf, vs_name, {})
        # vserver name contains ".", so quote it
        vs_name_path = Builtins.topath(Ops.add(Ops.add("\"", vs_name), "\""))
        # dir all pair name of given vserver name
        pair_names = SCR.Dir(Ops.add(path(".iplb.value"), vs_name_path))
        # iterate pair names to read the pair value
        Builtins.foreach(pair_names) do |key|
          Ops.set(
            @vserver_conf,
            [vs_name, key],
            SCR.Read(
              Ops.add(
                Ops.add(path(".iplb.value"), vs_name_path),
                Builtins.topath(key)
              )
            )
          )
        end
        #check for IPv6 address
        is_ipv6 = false
        ipv6_address = Builtins.regexpsub(vs_name, "\\[(.+)\\]", "\\1")
        is_ipv6 = IP.Check6(ipv6_address) if ipv6_address != nil
        if is_ipv6
          if Ops.get_list(@vserver_conf, [vs_name, "real6"], []) != []
            Ops.set(
              @vserver_conf,
              [vs_name, "real"],
              Ops.get_list(@vserver_conf, [vs_name, "real6"], [])
            )
            Ops.set(@vserver_conf, [vs_name, "real6"], [])
          end
          if Ops.get_list(@vserver_conf, [vs_name, "fallback6"], []) != []
            Ops.set(
              @vserver_conf,
              [vs_name, "fallback"],
              Ops.get_list(@vserver_conf, [vs_name, "fallback6"], [])
            )
            Ops.set(@vserver_conf, [vs_name, "fallback6"], [])
          end
        end
      end

      remove_vserver_conf_quote

      Builtins.y2debug("___iplbdebug___ read vserver_conf = %1", @vserver_conf)
      Progress.NextStage

      # Progress finished
      Progress.NextStage

      @modified = false
      true
    end

    # Write all iplb settings
    # @return true on success
    def Write
      ret = false
      caption = _("Saving IPLB Configuration")

      Progress.New(
        caption,
        " ",
        2,
        [_("Write the settings"), _("Run SuSEconfig")],
        [
          _("Writing the settings..."),
          _("Running SuSEconfig..."),
          _("Finished")
        ],
        ""
      )

      # remove all sections, as ini agent will write new global conf
      # entry at the end of the conf file. (global conf after sections
      # will be read as vserver conf, not as global conf. it's a bug)
      Builtins.foreach(@vserver_conf) do |key, val|
        sect_path = Builtins.topath(Ops.add(Ops.add("\"", key), "\""))
        ret = SCR.Write(Ops.add(path(".iplb.section"), sect_path), nil)
      end

      saved_global_conf = deep_copy(@global_conf)
      add_global_conf_quote

      # write global conf
      Builtins.y2debug("___iplbdebug___ write global_conf=%1", @global_conf)
      Builtins.foreach(@global_conf) do |key, val|
        write_val = nil
        write_val = [val] if val != nil
        ret = SCR.Write(
          Ops.add(path(".iplb.value"), Builtins.topath(key)),
          write_val
        )
        Report.Error(_("Cannot write settings.")) if !ret
      end
      Progress.NextStage

      @global_conf = deep_copy(saved_global_conf)


      saved_vserver_conf = deep_copy(@vserver_conf)
      add_vserver_conf_quote

      # write vserver conf
      Builtins.y2debug("___iplbdebug___ write vserver_conf=%1", @vserver_conf)
      Builtins.foreach(@vserver_conf) do |key, val|
        #check for ipv6 address to decide whether to add "6=" or "="
        # string key's format
        # 192.168.6.241:89 or [2001:db8::5]:119
        # only extract the 2001:db8::5 part from the key string
        # to check whether it is an ipv6 address;
        is_ipv6 = false
        sect_path = Builtins.topath("")
        ipv6_address = Builtins.regexpsub(key, "\\[(.+)\\]", "\\1")
        is_ipv6 = IP.Check6(ipv6_address) if ipv6_address != nil
        if is_ipv6
          sect_path = Builtins.topath(Ops.add(Ops.add("\"6 = ", key), "\""))
          if Ops.get_list(val, "fallback", []) != []
            Ops.set(val, "fallback6", Ops.get_list(val, "fallback", []))
            Ops.set(val, "fallback", [])
          end
          if Ops.get_list(val, "real", []) != []
            Ops.set(val, "real6", Ops.get_list(val, "real", []))
            Ops.set(val, "real", [])
          end
        else
          sect_path = Builtins.topath(Ops.add(Ops.add("\" = ", key), "\""))
        end
        if val == nil
          ret = SCR.Write(Ops.add(path(".iplb.section"), sect_path), nil)
          Report.Error(_("Cannot write settings.")) if !ret
          next
        end
        Builtins.foreach(
          Convert.convert(val, :from => "map", :to => "map <string, list>")
        ) do |key1, val1|
          ret = SCR.Write(
            Ops.add(
              Ops.add(path(".iplb.value"), sect_path),
              Builtins.topath(key1)
            ),
            val1
          )
          Report.Error(_("Cannot write settings.")) if !ret
        end
      end
      Progress.NextStage

      @vserver_conf = deep_copy(saved_vserver_conf)

      # Progress finished
      Progress.NextStage

      true
    end

    # Get all iplb settings from the first parameter
    # (For use by autoinstallation.)
    # @param [Hash] settings The YCP structure to be imported.
    # @return [Boolean] True on success
    def Import(settings)
      settings = deep_copy(settings)
      # TODO FIXME: your code here (fill the above mentioned variables)...
      true
    end

    # Dump the iplb settings to a single map
    # (For use by autoinstallation.)
    # @return [Hash] Dumped settings (later acceptable by Import ())
    def Export
      # TODO FIXME: your code here (return the above mentioned variables)...
      {}
    end

    # Create a textual summary and a list of unconfigured cards
    # @return summary of the current configuration
    def Summary
      # TODO FIXME: your code here...
      # Configuration summary text for autoyast
      [_("Configuration summary..."), []]
    end

    # Create an overview table with all configured cards
    # @return table items
    def Overview
      # TODO FIXME: your code here...
      []
    end

    # Return packages needed to be installed and removed during
    # Autoinstallation to insure module has all needed software
    # installed.
    # @return [Hash] with 2 lists.
    def AutoPackages
      # TODO FIXME: your code here...
      { "install" => [], "remove" => [] }
    end

    publish :variable => :global_conf, :type => "map <string, string>"
    publish :variable => :vserver_conf, :type => "map <string, map>"
    publish :function => :Modified, :type => "boolean ()"
    publish :function => :Abort, :type => "boolean ()"
    publish :function => :SetModified, :type => "void ()"
    publish :function => :ProposalValid, :type => "boolean ()"
    publish :function => :SetProposalValid, :type => "void (boolean)"
    publish :function => :WriteOnly, :type => "boolean ()"
    publish :function => :SetWriteOnly, :type => "void (boolean)"
    publish :function => :SetAbortFunction, :type => "void (boolean ())"
    publish :function => :Read, :type => "boolean ()"
    publish :function => :Write, :type => "boolean ()"
    publish :function => :Import, :type => "boolean (map)"
    publish :function => :Export, :type => "map ()"
    publish :function => :Summary, :type => "list ()"
    publish :function => :Overview, :type => "list ()"
    publish :function => :AutoPackages, :type => "map ()"
  end

  Iplb = IplbClass.new
  Iplb.main
end
