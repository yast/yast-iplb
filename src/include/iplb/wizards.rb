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

# File:	include/iplb/wizards.ycp
# Package:	Configuration of iplb
# Summary:	Wizards definitions
# Authors:	Cong Meng <cmeng@novell.com>
#
# $Id: wizards.ycp 27914 2006-02-13 14:32:08Z locilka $
module Yast
  module IplbWizardsInclude
    def initialize_iplb_wizards(include_target)
      Yast.import "UI"

      textdomain "iplb"

      Yast.import "Sequencer"
      Yast.import "Wizard"

      Yast.include include_target, "iplb/complex.rb"
      Yast.include include_target, "iplb/dialogs.rb"
      Yast.include include_target, "iplb/global_conf.rb"
      Yast.include include_target, "iplb/vserver_conf.rb"
    end

    # Add a configuration of iplb
    # @return sequence result
    def AddSequence
      # FIXME: adapt to your needs
      aliases = { "config1" => lambda { Configure1Dialog() }, "config2" => lambda(
      ) do
        Configure2Dialog()
      end }

      # FIXME: adapt to your needs
      sequence = {
        "ws_start" => "config1",
        "config1"  => { :abort => :abort, :next => "config2" },
        "config2"  => { :abort => :abort, :next => :next }
      }

      Sequencer.Run(aliases, sequence)
    end

    # Main workflow of the iplb configuration
    # @return sequence result
    def MainSequence
      # +- global_conf
      # +- vserver_list_conf
      # 	+- vserver_add_conf
      # 	+- vserver_edit_conf
      _Aliases = {
        "global_conf"       => lambda { global_dialog },
        "vserver_list_conf" => lambda { vserver_list_dialog },
        "vserver_add_conf"  => lambda { vserver_add_dialog },
        "vserver_edit_conf" => lambda { vserver_edit_dialog }
      }

      sequence = {
        "ws_start"          => "global_conf",
        "global_conf"       => {
          :ok          => :next,
          :cancel      => :abort,
          :global_tab  => "global_conf",
          :vserver_tab => "vserver_list_conf"
        },
        "vserver_list_conf" => {
          :ok           => :next,
          :cancel       => :abort,
          :global_tab   => "global_conf",
          :vserver_add  => "vserver_add_conf",
          :vserver_edit => "vserver_edit_conf"
        },
        "vserver_add_conf"  => {
          :ok     => "vserver_list_conf",
          :cancel => "vserver_list_conf"
        },
        "vserver_edit_conf" => {
          :ok     => "vserver_list_conf",
          :cancel => "vserver_list_conf"
        }
      }

      # Buttons redefinition
      Wizard.SetNextButton(:ok, "OK")
      Wizard.SetAbortButton(:cancel, "Cancel")
      Wizard.HideBackButton

      ret = Sequencer.Run(_Aliases, sequence)
      deep_copy(ret)
    end

    # Whole configuration of iplb
    # @return sequence result
    def IplbSequence
      aliases = {
        "read"  => [lambda { ReadDialog() }, true],
        "main"  => lambda { MainSequence() },
        "write" => [lambda { WriteDialog() }, true]
      }

      sequence = {
        "ws_start" => "read",
        "read"     => { :abort => :abort, :next => "main" },
        "main"     => { :abort => :abort, :next => "write" },
        "write"    => { :abort => :abort, :next => :next }
      }

      Wizard.CreateDialog

      ret = Sequencer.Run(aliases, sequence)

      UI.CloseDialog
      deep_copy(ret)
    end

    # Whole configuration of iplb but without reading and writing.
    # For use with autoinstallation.
    # @return sequence result
    def IplbAutoSequence
      # Initialization dialog caption
      caption = _("IPLB Configuration")
      # Initialization dialog contents
      contents = Label(_("Initializing..."))

      Wizard.CreateDialog
      Wizard.SetContentsButtons(
        caption,
        contents,
        "",
        Label.BackButton,
        Label.NextButton
      )

      ret = MainSequence()

      UI.CloseDialog
      deep_copy(ret)
    end
  end
end
