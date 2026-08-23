--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Specyfikacja modułu zarządzania konfiguracją gry.
--                   Definiuje rekord konfiguracji okna, pełny zestaw
--                   wartości domyślnych (fallback) oraz publiczny interfejs
--                   do bezpiecznego ładowania parametrów z pliku TOML.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config.ads
--  CREATED:         2026-08-22
--  ============================================================================


with Ada.Strings.Unbounded;
with Gabyx.Types;

package Gabyx.Config is

   use Ada.Strings.Unbounded;
   use Gabyx.Types;

   --  ============================================================================
   --  DOMYŚLNE ŚCIEŻKI I WARTOŚCI AWARYJNE (FALLBACK)
   --  ============================================================================

   Default_Config_Path        : constant String := "data/config/window.toml";
   Default_Fonts_Config_Path  : constant String := "data/config/fonts.toml";

   Default_Window_Title       : constant String := "Gabyx - Roguelike RPG / City-Builder";
   Default_Font_Family        : constant String := "Intel One Mono Nerd Font";
   Default_Regular_Path       : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-Regular.ttf";
   Default_Bold_Path          : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-Bold.ttf";
   Default_Italic_Path        : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-Italic.ttf";
   Default_Bold_Italic_Path   : constant String := "assets/fonts/intel_one_mono/IntoneMonoNerdFont-BoldItalic.ttf";

   --  ============================================================================
   --  REKORD KONFIGURACJI OKNA I GRAFIKI
   --  ============================================================================

   type Window_Configuration is record
      Title                 : Unbounded_String   := To_Unbounded_String (Default_Window_Title);
      Display_Mode          : Display_Mode_Type  := Windowed;
      Active_Preset         : Preset_ID          := Auto_Default;
      Width                 : Width_Type         := 1280;
      Height                : Height_Type        := 720;
      Center_On_Screen      : Boolean            := True;
      Monitor_Index         : Natural            := 0;
      Resizable             : Boolean            := False;
      Always_On_Top         : Boolean            := False;
      High_DPI              : Boolean            := True;
      VSync                 : Boolean            := True;
      Target_FPS            : Target_FPS_Type    := 0;
      Maintain_Aspect_Ratio : Boolean            := True;
      Clear_Color           : RGBA_Color         := Default_Background_Color;
      Border_Bars_Color     : RGBA_Color         := Default_Border_Bars_Color;
   end record;

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

   --  ============================================================================
   --  PUBLICZNY INTERFEJS ŁADOWANIA KONFIGURACJI
   --  ============================================================================

   --  Ładuje konfigurację z podanej ścieżki pliku TOML.
   --  W przypadku braku pliku lub błędów, funkcja zwraca bezpieczne wartości domyślne.
   function Load_Window_Configuration
     (File_Path : String := Default_Config_Path) return Window_Configuration;

   --  Zwraca predefiniowaną, czystą konfigurację domyślną
   function Get_Default_Configuration return Window_Configuration;

   function Load_Font_Configuration
     (File_Path : String := Default_Fonts_Config_Path) return Font_Configuration;

   function Get_Default_Font_Configuration return Font_Configuration;

end Gabyx.Config;
