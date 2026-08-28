--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja pętli głównej sterownika Raylib. Integruje moduły
--                   Window_Mgr, Fonts, Renderer, Input oraz kalkulator Layout w SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/gabyx-drivers-raylib.adb
--  CREATED:         2026-08-22
--  ============================================================================


with Gabyx.Types;
with Gabyx.State_Machine;
with Gabyx.Logging;
with Gabyx.Config.HUD;
with Gabyx.Config.Game;
with Gabyx.Config.Camera;
with Gabyx.Config.Audio;
with Gabyx.Drivers.Raylib.Window_Mgr;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Audio;
with Gabyx.Drivers.Raylib.Splash;
with Gabyx.Drivers.Raylib.Menu;
with Gabyx.Drivers.Raylib.Settings;
with Gabyx.Drivers.Raylib.Renderer;
with Raylib;

package body Gabyx.Drivers.Raylib is

   use Gabyx.Types;
   use Gabyx.Logging;

   procedure Run
     (Config   : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration)
   is
      Current_Font_Cfg : Gabyx.Config.Fonts.Font_Configuration := Font_Cfg;

      Game_Cfg   : constant Gabyx.Config.Game.Game_Configuration   :=
        Gabyx.Config.Game.Load_Configuration;
      HUD_Cfg    : constant Gabyx.Config.HUD.HUD_Configuration     :=
        Gabyx.Config.HUD.Load_Configuration;
      Audio_Cfg  : constant Gabyx.Config.Audio.Audio_Configuration :=
        Gabyx.Config.Audio.Load_Configuration;
      Camera_Cfg : constant Gabyx.Config.Camera.Camera_Configuration :=
        Gabyx.Config.Camera.Load_Configuration;
   begin
      --  1. Inicjalizacja podsystemów
      Gabyx.Logging.Log_Info (Domain_Window, "Inicjalizacja okna Raylib...");
      Gabyx.Drivers.Raylib.Window_Mgr.Initialize (Config);

      Gabyx.Logging.Log_Info (Domain_Render, "Ladowanie czcionek i filtrowanie...");
      Gabyx.Drivers.Raylib.Fonts.Load_All (Current_Font_Cfg);

      Gabyx.Logging.Log_Info (Domain_Audio, "Inicjalizacja audio i synteza fal PCM...");
      Gabyx.Drivers.Raylib.Audio.Initialize (Audio_Cfg);

      Gabyx.Drivers.Raylib.Splash.Initialize (Game_Cfg);
      Gabyx.Drivers.Raylib.Menu.Initialize;
      Gabyx.Drivers.Raylib.Renderer.Initialize (HUD_Cfg, Camera_Cfg);

      Gabyx.State_Machine.Set_State (State_Splash);
      Gabyx.Logging.Log_Info (Domain_Engine, "Rozpoczeto glowna petle wykonawcza Raylib");

      --  2. Główna pętla orkiestracji
      while not Boolean (Standard.Raylib.WindowShouldClose)
         and then not Gabyx.State_Machine.Is_In_State (State_Quit)
      loop
         case Gabyx.State_Machine.Get_State is
            when State_Splash =>
               Gabyx.Drivers.Raylib.Splash.Process_Frame (Current_Font_Cfg);
            when State_Main_Menu =>
               Gabyx.Drivers.Raylib.Menu.Process_Frame (Current_Font_Cfg);
            when State_Settings =>
               Gabyx.Drivers.Raylib.Settings.Process_Frame (Current_Font_Cfg);
            when State_In_Game =>
               Gabyx.Drivers.Raylib.Renderer.Process_Game_Frame (Config, Current_Font_Cfg);
            when State_Quit =>
               exit;
         end case;
      end loop;

      --  3. Bezpieczne zwolnienie zasobów
      Gabyx.Logging.Log_Info (Domain_Engine, "Zamykanie sterownika Raylib i zwalnianie zasobow GPU/Audio...");
      Gabyx.Drivers.Raylib.Audio.Close;
      Gabyx.Drivers.Raylib.Fonts.Unload_All;
      Gabyx.Drivers.Raylib.Window_Mgr.Close;
   end Run;

end Gabyx.Drivers.Raylib;
