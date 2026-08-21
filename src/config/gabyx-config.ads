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

   Default_Config_Path : constant String := "data/config/window.toml";

   Default_Window_Title : constant String := "Gabyx - Roguelike RPG / City-Builder";

   --  ============================================================================
   --  REKORD KONFIGURACJI OKNA I GRAFIKI
   --  ============================================================================

   type Window_Configuration is record
      Title                 : Unbounded_String := To_Unbounded_String (Default_Window_Title);
      Active_Preset         : Preset_ID        := Auto_Default;
      Width                 : Width_Type       := 1280;
      Height                : Height_Type      := 720;
      Fullscreen            : Boolean          := False;
      Resizable             : Boolean          := False;
      Borderless            : Boolean          := False;
      High_DPI              : Boolean          := True;
      Always_On_Top         : Boolean          := False;
      VSync                 : Boolean          := True;
      Target_FPS            : Target_FPS_Type  := 0;
      Maintain_Aspect_Ratio : Boolean          := True;
      Clear_Color           : RGBA_Color       := Default_Background_Color;
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

end Gabyx.Config;
