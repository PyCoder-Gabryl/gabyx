--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja konfiguracji mapowania klawiatury i skrotow.
--                    Definiuje rekord Input_Configuration oraz interfejs ladowania
--                    plikow mapowania klawiatury data/config/input.toml.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/controls/gabyx-config-input.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Strings.Unbounded;

package Gabyx.Config.Input is

   use Ada.Strings.Unbounded;

   Default_Config_Path : constant String := "data/config/input.toml";

   type Input_Configuration is record
      Quit               : Unbounded_String := To_Unbounded_String ("ESCAPE");
      Toggle_Borderless  : Unbounded_String := To_Unbounded_String ("B");
      Toggle_Top_View    : Unbounded_String := To_Unbounded_String ("G");
      Toggle_Bottom_View : Unbounded_String := To_Unbounded_String ("D");
      Toggle_Font_Family : Unbounded_String := To_Unbounded_String ("F");
      Tier_Auto          : Unbounded_String := To_Unbounded_String ("ALT+0");
      Tier_Compact       : Unbounded_String := To_Unbounded_String ("ALT+1");
      Tier_Standard      : Unbounded_String := To_Unbounded_String ("ALT+2");
      Tier_HiDPI         : Unbounded_String := To_Unbounded_String ("ALT+3");
      Preset_1           : Unbounded_String := To_Unbounded_String ("1");
      Preset_2           : Unbounded_String := To_Unbounded_String ("2");
      Preset_3           : Unbounded_String := To_Unbounded_String ("3");
      Preset_4           : Unbounded_String := To_Unbounded_String ("4");
      Preset_5           : Unbounded_String := To_Unbounded_String ("5");
      Preset_6           : Unbounded_String := To_Unbounded_String ("6");
      Preset_7           : Unbounded_String := To_Unbounded_String ("7");
      Preset_8           : Unbounded_String := To_Unbounded_String ("8");
      Preset_9           : Unbounded_String := To_Unbounded_String ("9");
      Move_North         : Unbounded_String := To_Unbounded_String ("W");
      Move_South         : Unbounded_String := To_Unbounded_String ("S");
      Move_West          : Unbounded_String := To_Unbounded_String ("A");
      Move_East          : Unbounded_String := To_Unbounded_String ("E");
      Action_Wait        : Unbounded_String := To_Unbounded_String ("SPACE");
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Input_Configuration;

   function Get_Default_Configuration return Input_Configuration;

end Gabyx.Config.Input;
