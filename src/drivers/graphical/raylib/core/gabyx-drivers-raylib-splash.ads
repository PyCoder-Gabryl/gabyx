--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł renderowania i logiki ekranu startowego Splash.
--                   Obsługuje licznik czasu (domyślnie 1.0 s), animację pulsowania logo,
--                   płynne wygaszanie oraz natychmiastowe pomijanie klawiszami.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/core/gabyx-drivers-raylib-splash.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Config.Game;
with Gabyx.Config.Fonts;

package Gabyx.Drivers.Raylib.Splash is

   --  Inicjalizuje parametry ekranu Splash z pliku game.toml
   procedure Initialize (Game_Cfg : Gabyx.Config.Game.Game_Configuration);

   --  Aktualizuje licznik czasu i sprawdza przejście do Menu Głównego
   procedure Update;

   --  Renderuje grafikę i animację ekranu Splash
   procedure Render (Font_Cfg : Gabyx.Config.Fonts.Font_Configuration);

   --  Zwraca True, gdy prezentacja Splash dobiegła końca
   function Is_Finished return Boolean;

end Gabyx.Drivers.Raylib.Splash;
