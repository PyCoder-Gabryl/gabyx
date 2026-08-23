--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja konfiguracji okna, wyswietlania i grafiki.
--                    Definiuje rekord Window_Configuration, zestaw wartosci
--                    domyslnych oraz interfejs ladowania pliku data/config/window.toml.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-window.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Strings.Unbounded;
with Gabyx.Types;

package Gabyx.Config.Window is

   use Ada.Strings.Unbounded;
   use Gabyx.Types;

   Default_Config_Path  : constant String := "data/config/window.toml";
   Default_Window_Title : constant String := "Gabyx - Roguelike RPG / City-Builder";

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

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Window_Configuration;

   function Get_Default_Configuration return Window_Configuration;

end Gabyx.Config.Window;
