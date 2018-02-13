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
  module IplbVserverConfInclude
    def initialize_iplb_vserver_conf(include_target)
      textdomain "iplb"

      Yast.import "Popup"
      Yast.import "Sequencer"
      Yast.import "Report"
      Yast.import "Label"
      Yast.import "Wizard"
      Yast.import "Service"
      Yast.import "Iplb"
      Yast.import "IP"

      Yast.include include_target, "iplb/helps.rb"
      Yast.include include_target, "iplb/common.rb"

      # ids of widgets of vserver dialog
      # virtual servers & real servers are not inlucded here
      @vserver_entries = [
        :checktype,
        :service,
        :checkcommand,
        :checkport,
        :request,
        :receive,
        :httpmethod,
        :virtualhost,
        :login,
        :passwd,
        :database,
        :secret,
        :scheduler,
        :persistent,
        :netmask,
        :protocol,
        # overwrite global value part
        :checktimeout,
        :negotiatetimeout,
        :failurecount,
        :emailalert,
        :emailalertfreq,
        :emailalertstatus,
        :fallback,
        :quiescent
      ]

      @checktypes = [
        "",
        "negotiate",
        "connect",
        "external",
        "off",
        "on",
        "ping"
      ]

      @services = [
        "",
        "dns",
        "ftp",
        "http",
        "https",
        "imap",
        "imaps",
        "ldap",
        "mysql",
        "nntp",
        "none",
        "oracle",
        "pgsql",
        "pop",
        "pops",
        "radius",
        "sim"
      ]

      @httpmethods = ["", "GET", "HEAD"]

      @schedulers = [
        "",
        "wrr",
        "rr",
        "lc",
        "wlc",
        "lblc",
        "lblcr",
        "dh",
        "sh",
        "sed",
        "nq"
      ]

      @protocols = ["", "tcp", "udp", "fwm"]

      @emailalertstatus = [
        "",
        "all",
        "none",
        "starting",
        "running",
        "stopping",
        "reloading"
      ]


      @check_type_page = HBox(
        VBox(
          Opt(:hvstretch),
          VSpacing(1),
          HBox(
            HWeight(
              12,
              ComboBox(
                Id(:checktype),
                Opt(:editable),
                _("Check Type"),
                @checktypes
              )
            ),
            HWeight(8, TextEntry(Id(:checkport), _("Check Port"), "")),
            HWeight(10, ComboBox(Id(:service), _("Service"), @services)),
            HWeight(70, TextEntry(Id(:checkcommand), _("Check Command"), ""))
          ),
          HBox(
            HWeight(
              12,
              ComboBox(Id(:httpmethod), _("Http Method"), @httpmethods)
            ),
            HSpacing(8),
            HWeight(35, TextEntry(Id(:request), _("Request"), "")),
            HSpacing(10),
            HWeight(35, TextEntry(Id(:receive), _("Receive"), ""))
          ),
          HBox(
            HWeight(20, TextEntry(Id(:virtualhost), _("Virtual Host"), "")),
            HSpacing(20),
            HWeight(20, TextEntry(Id(:fallback), _("Fallback"), ""))
          )
        )
      )


      @auth_alert_type_page = HBox(
        VBox(
          VSpacing(1),
          HBox(
            TextEntry(Id(:login), _("Login"), ""),
            TextEntry(Id(:passwd), _("Password"), "")
          ),
          TextEntry(Id(:database), _("Database Name"), ""),
          TextEntry(Id(:secret), _("Radius Secret"), "")
        ),
        HSpacing(3),
        VBox(
          VSpacing(1),
          TextEntry(Id(:emailalert), _("Email Alert"), ""),
          TextEntry(Id(:emailalertfreq), _("Email Alert Freq"), ""),
          ComboBox(
            Id(:emailalertstatus),
            _("Email Alert Status"),
            @emailalertstatus
          )
        )
      )

      @others_type_page = VBox(
        VSpacing(1),
        HBox(
          HWeight(35, TextEntry(Id(:persistent), _("Persistent"), "")),
          HWeight(35, TextEntry(Id(:netmask), _("Netmask"), "")),
          HSpacing(10),
          HWeight(20, ComboBox(Id(:scheduler), _("Scheduler"), @schedulers))
        ),
        HBox(
          HWeight(35, TextEntry(Id(:checktimeout), _("Check Timeout"), "")),
          HWeight(
            35,
            TextEntry(Id(:negotiatetimeout), _("Negotiate Timeout"), "")
          ),
          HSpacing(10),
          HWeight(20, ComboBox(Id(:protocol), _("Protocol"), @protocols))
        ),
        HBox(
          HWeight(35, TextEntry(Id(:failurecount), _("Failure Count"), "")),
          HSpacing(45),
          HWeight(20, ComboBox(Id(:quiescent), _("Quiescent"), @yesno))
        )
      )
    end

    def vserver_list_layout
      VBox(
        Opt(:hvstretch),
        DumbTab(
          [
            Item(Id(:global_tab), _("&Global Configuration")),
            Item(Id(:vserver_tab), _("&Virtual Server Configuration"), true)
          ],
          VBox(
            Opt(:hvstretch),
            SelectionBox(Id(:vserver_box), _("Virtual Servers")),
            Left(
              HBox(
                PushButton(Id(:vserver_add), _("Add")),
                PushButton(Id(:vserver_edit), _("Edit")),
                PushButton(Id(:vserver_del), _("Delete"))
              )
            )
          )
        )
      )
    end


    def vserver_list_dialog
      ret = nil
      my_SetContents("vserver_conf", vserver_list_layout)

      while true
        # fill the vserver list box
        # FIXME: set the cursor position
        items = []
        Builtins.foreach(Iplb.vserver_conf) do |key, val|
          next if Ops.get(Iplb.vserver_conf, key) == nil
          items = Builtins.add(items, Item(key))
        end
        UI.ChangeWidget(:vserver_box, :Items, items)

        # disable the delete & edit button if vserver box is empty
        n = Builtins.size(items)
        UI.ChangeWidget(:vserver_del, :Enabled, n != 0)
        UI.ChangeWidget(:vserver_edit, :Enabled, n != 0)

        ret = Convert.to_symbol(UI.UserInput)
        Builtins.y2debug("___iplbdebug___ input=%1", ret)

        if ret == :help
          myHelp("vserver_conf")
          next
        end

        if ret == :vserver_del
          vserver_name = Convert.to_string(
            UI.QueryWidget(:vserver_box, :CurrentItem)
          )
          Ops.set(Iplb.vserver_conf, vserver_name, nil)
          next
        end

        if Builtins.contains(
            [:ok, :cancel, :global_tab, :vserver_add, :vserver_edit],
            ret
          )
          break
        end

        Builtins.y2error("unknown input %1", ret)
      end
      ret
    end


    def vserver_layout(l_vserver_conf)
      l_vserver_conf = deep_copy(l_vserver_conf)
      VBox(
        TextEntry(Id(:vserver), _("Virtual Server"), ""),
        HBox(
          SelectionBox(Id(:rserver_box), _("Real Servers")),
          Bottom(
            VBox(
              PushButton(Id(:rserver_add), _("Add")),
              PushButton(Id(:rserver_del), _("Delete")),
              PushButton(Id(:rserver_edit), _("Edit"))
            )
          )
        ),
        VBox(
          DumbTab(
            [
              Item(Id(:check_type), _("Check type"), true),
              Item(Id(:auth_type), _("Auth type")),
              Item(Id(:others_type), _("Others"))
            ],
            Top(
              VBox(
                VSpacing(0.3),
                HBox(
                  HSpacing(1),
                  ReplacePoint(Id(:tabContents), @check_type_page)
                )
              )
            )
          )
        )
      )
    end


    # return `cacel or a string
    def text_input_dialog(title, value)
      ret = nil

      UI.OpenDialog(
        MarginBox(
          1,
          1,
          VBox(
            MinWidth(100, TextEntry(Id(:text), title, value)),
            VSpacing(1),
            Right(
              HBox(
                PushButton(Id(:ok), _("OK")),
                PushButton(Id(:cancel), _("Cancel"))
              )
            )
          )
        )
      )

      ret = UI.UserInput
      ret = UI.QueryWidget(:text, :Value) if ret == :ok
      UI.CloseDialog
      deep_copy(ret)
    end

    # fill the widgets accord to the @l_vserver_conf
    def fill_vserver_entries(l_vserver_conf)
      l_vserver_conf = deep_copy(l_vserver_conf)
      Builtins.foreach(@vserver_entries) do |key|
        name = Builtins.substring(Builtins.tostring(key), 1) # remove '`' char
        val = Ops.get_list(l_vserver_conf, name, [])
        if Ops.greater_than(Builtins.size(val), 0) && UI.WidgetExists(key)
          UI.ChangeWidget(key, :Value, Ops.get_string(val, 0, ""))
        end
      end

      nil
    end


    # retrieve the value from widgets, save to @l_vserver_conf
    def retrieve_vserver_entries(l_vserver_conf)
      l_vserver_conf = deep_copy(l_vserver_conf)
      Builtins.foreach(@vserver_entries) do |key|
        name = Builtins.substring(Builtins.tostring(key), 1) # remove '`' char
        val_old = Ops.get_list(l_vserver_conf, name, [])
        val_new = ""
        if UI.WidgetExists(key)
          val_new = Convert.to_string(UI.QueryWidget(key, :Value))
        else
          next
        end
        if Ops.greater_than(Builtins.size(val_new), 0)
          Ops.set(l_vserver_conf, name, [val_new])
        elsif Ops.greater_than(Builtins.size(val_old), 0)
          # assigning nil to remove it from conf file
          Ops.set(l_vserver_conf, name, nil)
        end
      end
      deep_copy(l_vserver_conf)
    end

    def real_ip_input_dialog(title, value)
      ret = nil
      #split the real server ip value;
      Builtins.y2milestone("%1", value)
      ip = ""
      fwd_method = ""
      weight = 1
      real_ip = Builtins.splitstring(value, " \t")
      ip = Ops.get(real_ip, 0, "")
      fwd_method = Ops.get(real_ip, 1, "")
      if Ops.get(real_ip, 2, "") != ""
        weight = Builtins.tointeger(Ops.get(real_ip, 2, "1"))
      end

      layout = VBox(
        VBox(
          Label(
            _("If using IPv6,the format should like this\n[fe80::5054:ff:fe00:2]")
          ),
          InputField(Id(:ip), Opt(:hstretch), _("Real Server's IP Address"), "")
        ),
        VSpacing(1),
        HBox(
          ComboBox(
            Id(:fwd_method),
            _("Forward Method"),
            ["gate", "ipip", "masq"]
          ),
          IntField(Id(:weight), _("weight"), 0, 65535, 1)
        ),
        VSpacing(1),
        Right(
          HBox(
            PushButton(Id(:ok), _("OK")),
            PushButton(Id(:cancel), _("Cancel"))
          )
        )
      )
      UI.OpenDialog(layout)
      UI.ChangeWidget(:ip, :Value, ip)
      UI.ChangeWidget(:fwd_method, :Value, fwd_method)
      UI.ChangeWidget(:weight, :Value, weight)
      while true
        ret = UI.UserInput
        if ret == :ok
          ip2 = Convert.to_string(UI.QueryWidget(Id(:ip), :Value))
          pos2 = 0
          #get ipv6 and ipv4 address
          #check IP Address for real server;
          if Builtins.find(ip2, "[") == 0
            #find next ]
            pos2 = Builtins.find(ip2, "]")
            if pos2 != nil
              ip2 = Builtins.substring(ip2, 1, Ops.subtract(pos2, 1))
            end
          else
            pos2 = Builtins.find(ip2, ":")
            ip2 = Builtins.substring(ip2, 0, pos2) if pos2 != nil
          end

          Builtins.y2milestone("ip is %1", ip2)
          if IP.Check(ip2) == false
            Popup.Message(_("IP address is not Valid"))
            next
          end
          # if(IP::Check6((string)UI::QueryWidget(`id(`ip),`Value))==true)
          #	 ret="["+(string)UI::QueryWidget(`id(`ip),`Value)+"]";
          # else
          #	 ret=(string)UI::QueryWidget(`id(`ip),`Value);
          ret = Convert.to_string(UI.QueryWidget(Id(:ip), :Value))
          # if((integer)UI::QueryWidget(`port,`Value)!=0)
          #	 ret=":"+(integer)UI::QueryWidget(`port,`Value);
          if UI.QueryWidget(:fwd_method, :Value) != nil
            ret = Ops.add(
              Ops.add(Convert.to_string(ret), " "),
              Convert.to_string(UI.QueryWidget(:fwd_method, :Value))
            )
          end
          if UI.QueryWidget(:weight, :Value) != 1
            ret = Ops.add(
              Ops.add(Convert.to_string(ret), " "),
              Convert.to_integer(UI.QueryWidget(:weight, :Value))
            )
          end
          break
        end
        break if ret == :cancel
      end
      UI.CloseDialog
      deep_copy(ret)
    end


    # return `ok or `cancel
    def vserver_dialog(vserver_name)
      ret = nil
      l_vserver_conf = Ops.get(Iplb.vserver_conf, vserver_name, {})
      Builtins.y2milestone(
        "___iplbdebug___ v=%2, l_v_c=%1",
        l_vserver_conf,
        vserver_name
      )

      my_SetContents("vserver_conf", vserver_layout(l_vserver_conf))
      fill_vserver_entries(l_vserver_conf)
      UI.ChangeWidget(:vserver, :Value, vserver_name)

      while true
        # calculate the cursor position
        n = Builtins.size(Ops.get_list(l_vserver_conf, "real", []))
        cursor = Convert.to_integer(UI.QueryWidget(:rserver_box, :CurrentItem))
        cursor = 0 if cursor == nil
        cursor = Ops.subtract(n, 1) if Ops.greater_or_equal(cursor, n)

        # fill the rserver box, set the cursor position
        # make the index of real list as the id of element of the rserver selectbox
        i = 0
        rs_box = []
        Builtins.foreach(Ops.get_list(l_vserver_conf, "real", [])) do |value|
          rs_box = Builtins.add(rs_box, Item(Id(i), value))
          i = Ops.add(i, 1)
        end
        UI.ChangeWidget(:rserver_box, :Items, rs_box)
        UI.ChangeWidget(:rserver_box, :CurrentItem, cursor)

        # disable the delete & edit button if rservers box is empty
        UI.ChangeWidget(:rserver_del, :Enabled, n != 0)
        UI.ChangeWidget(:rserver_edit, :Enabled, n != 0)

        ret = UI.UserInput

        Builtins.y2error("___iplbdebug___ input=%1", ret)

        #tab switch events start
        if ret == :check_type || ret == :auth_type || ret == :others_type
          l_vserver_conf = retrieve_vserver_entries(l_vserver_conf)
          case Convert.to_symbol(ret)
            when :check_type
              UI.ReplaceWidget(:tabContents, @check_type_page)
            when :auth_type
              UI.ReplaceWidget(:tabContents, @auth_alert_type_page)
            when :others_type
              UI.ReplaceWidget(:tabContents, @others_type_page)
            else

          end
          fill_vserver_entries(l_vserver_conf)
          next
        end
        #tab switch events end


        if ret == :rserver_add
          ret = real_ip_input_dialog(_("Add a new real server:"), "")
          if ret != :cancel
            Builtins.y2milestone("%1", Convert.to_string(ret))
            Ops.set(
              l_vserver_conf,
              "real",
              Builtins.add(Ops.get_list(l_vserver_conf, "real", []), ret)
            )
          end
          next
        end

        if ret == :rserver_edit
          current = Convert.to_integer(
            UI.QueryWidget(:rserver_box, :CurrentItem)
          )
          ret = real_ip_input_dialog(
            _("Edit the real server:"),
            Ops.get_string(l_vserver_conf, ["real", current], "")
          )
          Ops.set(l_vserver_conf, ["real", current], ret) if ret != :cancel
          next
        end

        if ret == :rserver_del
          current = Convert.to_integer(
            UI.QueryWidget(:rserver_box, :CurrentItem)
          )
          Ops.set(
            l_vserver_conf,
            "real",
            Builtins.remove(Ops.get_list(l_vserver_conf, "real", []), current)
          )
          next
        end

        if ret == :ok
          l_vserver_conf = retrieve_vserver_entries(l_vserver_conf)
          Ops.set(Iplb.vserver_conf, vserver_name, nil)
          vserver_name = Convert.to_string(UI.QueryWidget(:vserver, :Value))
          Ops.set(Iplb.vserver_conf, vserver_name, l_vserver_conf)
          break
        end

        break if ret == :cancel

        Builtins.y2debug("___iplbdebug___ unknown input %1", ret)
      end

      deep_copy(ret)
    end


    def vserver_add_dialog
      ret = nil
      ret = vserver_dialog("")
      deep_copy(ret)
    end


    def vserver_edit_dialog
      ret = nil
      vserver_name = Convert.to_string(
        UI.QueryWidget(Id(:vserver_box), :CurrentItem)
      )
      ret = vserver_dialog(vserver_name)

      deep_copy(ret)
    end
  end
end
