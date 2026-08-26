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


with Gabyx.Types;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Settings is

   use Gabyx.Types;

   --  Otwiera panel ustawień zapamiętując stan wywołujący (Menu lub Gra)
   procedure Open_From (Caller : App_State);

   --  Przetwarza klatkę Ustawień: obsługuje 7 zakładek, mysz, klawiaturę i powrót przez ESC
   procedure Process_Frame (Font_Cfg : in out Gabyx.Config.Fonts.Font_Configuration);

end Gabyx.Drivers.Raylib.Settings;
