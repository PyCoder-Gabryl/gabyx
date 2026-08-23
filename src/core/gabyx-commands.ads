--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja uniwersalnych poleceń wejściowych silnika.
--                    Definiuje abstrakcyjny typ wyliczeniowy Game_Command,
--                    który izoluje sterowniki wejścia (Raylib, TUI) od
--                    właściwej logiki zarządzania oknem i interfejsem.
--  ----------------------------------------------------------------------------
--  PATH:            src/core/gabyx-commands.ads
--  CREATED:         2026-08-23
--  ============================================================================


package Gabyx.Commands with
   SPARK_Mode => On,
   Pure
is

   --  Abstrakcyjne polecenia domenowe emitowane przez sterowniki wejścia
   type Game_Command is
     (Cmd_None,
      Cmd_Select_Preset_1,
      Cmd_Select_Preset_2,
      Cmd_Select_Preset_3,
      Cmd_Select_Preset_4,
      Cmd_Select_Preset_5,
      Cmd_Select_Preset_6,
      Cmd_Select_Preset_7,
      Cmd_Select_Preset_8,
      Cmd_Select_Preset_9,
      Cmd_Toggle_Borderless,
      Cmd_HUD_Tier_Auto,
      Cmd_HUD_Tier_Compact,
      Cmd_HUD_Tier_Standard,
      Cmd_HUD_Tier_HiDPI,
      Cmd_Toggle_Top_View,
      Cmd_Toggle_Bottom_View,
      Cmd_Toggle_Font_Family,
      Cmd_Quit);

end Gabyx.Commands;
