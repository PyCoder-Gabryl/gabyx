--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Specyfikacja uniwersalnych poleceń wejściowych silnika.
--                   Definiuje abstrakcyjny typ wyliczeniowy Game_Command,
--                   który izoluje sterowniki wejścia (Raylib, TUI) od
--                   właściwej logiki zarządzania oknem, siatką i interfejsem.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-commands.ads
--  CREATED:         2026-08-23
--  ============================================================================


package Gabyx.Commands with
   SPARK_Mode => On,
   Pure
is

   type Game_Command is
     (Cmd_None,
      --  Zarządzanie oknem (Presety 1..9)
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
      --  Skalowanie HUD-u i czcionek
      Cmd_HUD_Tier_Auto,
      Cmd_HUD_Tier_Compact,
      Cmd_HUD_Tier_Standard,
      Cmd_HUD_Tier_HiDPI,
      Cmd_Toggle_Top_View,
      Cmd_Toggle_Bottom_View,
      Cmd_Toggle_Font_Family,
      --  Zarządzanie siatką i 6 poziomami zoomu kafelków
      Cmd_Cycle_Grid_Color,
      Cmd_Toggle_Grid,
      Cmd_Tile_Zoom_1,
      Cmd_Tile_Zoom_2,
      Cmd_Tile_Zoom_3,
      Cmd_Tile_Zoom_4,
      Cmd_Tile_Zoom_5,
      Cmd_Tile_Zoom_6,
      Cmd_Quit);

end Gabyx.Commands;
