--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł zarządzania oknem, monitorami i rozdzielczością w Raylib.
--                   Odpowiada za konfigurację flag okna, wykrywanie parametrów
--                   monitora głównego, centrowanie oraz aplikowanie presetów (1..9).
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib-window_mgr.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Types;
with Gabyx.Config.Window;

package Gabyx.Drivers.Raylib.Window_Mgr is

   use Gabyx.Types;

   --  Inicjalizuje okno, flagi HighDPI/V-Sync oraz dopasowuje pozycję do monitora
   procedure Initialize (Win_Cfg : Gabyx.Config.Window.Window_Configuration);

   --  Aplikuje wybrany preset rozdzielczości (1..9) z bezpiecznikiem monitora
   procedure Apply_Preset (Index : Positive);

   --  Przełącza tryb obramowania (Windowed <-> Borderless)
   procedure Toggle_Borderless;

   --  Centruje okno na monitorze głównym
   procedure Center_Window (Target_W, Target_H : Integer);

   --  Gettery bieżącego stanu okna
   function Get_Virtual_Width return Integer;
   function Get_Virtual_Height return Integer;
   function Get_Display_Mode return Display_Mode_Type;

   --  Zamyka okno i czyści kontekst graficzny
   procedure Close;

end Gabyx.Drivers.Raylib.Window_Mgr;
