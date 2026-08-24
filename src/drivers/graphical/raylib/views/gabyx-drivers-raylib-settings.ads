--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł renderowania i interakcji dwupanelowego okna Ustawień (1000x600 px).
--                   Rysuje przyciemnione tło, podwójną ramkę kontenera, listę 7 kategorii
--                   po lewej stronie oraz nagłówek i obszar szczegółów po prawej stronie.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/gabyx-drivers-raylib-settings.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.UI.Settings;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings is

   --  Renderuje dwupanelowe okno Ustawień, sprawdza mysz oraz flagę zamknięcia
   procedure Render
     (State          : in out Gabyx.UI.Settings.Settings_State;
      Font_Cfg       : Gabyx.Config.Fonts.Font_Configuration;
      Close_Clicked  : out Boolean;
      Option_Changed : out Boolean);

end Gabyx.Drivers.Raylib.Settings;
