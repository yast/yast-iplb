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
  module IplbCommonInclude
    def initialize_iplb_common(include_target)
      textdomain "iplb"

      Yast.import "Label"
      Yast.import "Wizard"
      Yast.import "Iplb"
      Yast.import "Popup"
      Yast.import "CWM"

      @DIALOG = ["global_conf", "vserver_conf"]

      @NAME = {
        "global_conf"  => _("Global Configuration"),
        "vserver_conf" => _("Virtual Servers Configuration")
      }
    end

    def my_SetContents(conf, contents)
      contents = deep_copy(contents)
      Wizard.SetContents(
        Ops.add("IPLB - ", Ops.get_string(@NAME, conf, "")),
        contents,
        Ops.get_string(@HELPS, conf, ""),
        true,
        true
      )

      UI.SetFocus(Id(:wizardTree)) if UI.WidgetExists(Id(:wizardTree))

      true
    end

    def myHelp(help)
      UI.OpenDialog(
        Opt(:decorated),
        HBox(
          VSpacing(16),
          VBox(
            HSpacing(60),
            VSpacing(0.5),
            RichText(Ops.get_string(@HELPS, help, "")),
            VSpacing(1.5),
            PushButton(Id(:ok), Opt(:default, :key_F10), Label.OKButton)
          )
        )
      )

      UI.SetFocus(Id(:ok))
      UI.UserInput
      UI.CloseDialog

      nil
    end
  end
end
