--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja konfiguracji typografii i czcionek Nerd Fonts.
--                    Zarzadza kwartetami krojow pisma (Regular, Bold, Italic,
--                    BoldItalic), rozmiarami glifow oraz opcjami renderowania tekstu.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-fonts.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Strings.Unbounded;
with Gabyx.Types;

package Gabyx.Config.Fonts is

   use Ada.Strings.Unbounded;
   use Gabyx.Types;

   Default_Config_Path      : constant String := "data/config/fonts.toml";
   Default_Font_Family      : constant String := "Intel One Mono Nerd Font";
   Default_Regular_Path     : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-Regular.ttf";
   Default_Bold_Path        : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-Bold.ttf";
   Default_Italic_Path      : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-Italic.ttf";
   Default_Bold_Italic_Path : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-BoldItalic.ttf";

   type Font_Configuration is record
      Family            : Unbounded_String := To_Unbounded_String (Default_Font_Family);
      Regular_Path      : Unbounded_String := To_Unbounded_String (Default_Regular_Path);
      Bold_Path         : Unbounded_String := To_Unbounded_String (Default_Bold_Path);
      Italic_Path       : Unbounded_String := To_Unbounded_String (Default_Italic_Path);
      Bold_Italic_Path  : Unbounded_String := To_Unbounded_String (Default_Bold_Italic_Path);
      Is_Monospace      : Boolean          := True;
      Size_Small        : Font_Size_Type   := 14;
      Size_Regular      : Font_Size_Type   := 18;
      Size_Title        : Font_Size_Type   := 24;
      Size_Large        : Font_Size_Type   := 32;
      Spacing           : Float            := 1.0;
      Smooth_Filter     : Boolean          := True;
      Polish_Diacritics : Boolean          := True;
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Font_Configuration;

   function Get_Default_Configuration return Font_Configuration;

end Gabyx.Config.Fonts;
