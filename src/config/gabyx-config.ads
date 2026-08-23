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

--  ============================================================================
--  KONTEKST ZMIANY W: src/config/gabyx-config.ads
--  ============================================================================

   Default_HUD_Config_Path : constant String := "data/config/hud.toml";

   type HUD_Tier_Dimensions is record
      Top_Height    : Positive       := 32;
      Bottom_Height : Positive       := 96;
      Font_Size     : Font_Size_Type := 14;
   end record;

   type HUD_Configuration is record
      Active_Tier        : HUD_Tier_Type       := HUD_Auto;
      Compact_Tier       : HUD_Tier_Dimensions := (Top_Height => 32, Bottom_Height => 96,  Font_Size => 14);
      Standard_Tier      : HUD_Tier_Dimensions := (Top_Height => 40, Bottom_Height => 120, Font_Size => 18);
      HiDPI_Tier         : HUD_Tier_Dimensions := (Top_Height => 80, Bottom_Height => 240, Font_Size => 24);
      Color_Top_View_A   : RGBA_Color          := (R => 26, G => 34, B => 45, A => 255);
      Color_Top_View_B   : RGBA_Color          := (R => 30, G => 28, B => 43, A => 255);
      Color_Bottom_View_A: RGBA_Color          := (R => 22, G => 27, B => 34, A => 255);
      Color_Bottom_View_B: RGBA_Color          := (R => 20, G => 32, B => 35, A => 255);
      Color_Viewport     : RGBA_Color          := (R => 0,  G => 0,  B => 0,  A => 255);
   end record;

   function Load_HUD_Configuration
     (File_Path : String := Default_HUD_Config_Path) return HUD_Configuration;

   function Get_Default_HUD_Configuration return HUD_Configuration;

end Gabyx.Config;
