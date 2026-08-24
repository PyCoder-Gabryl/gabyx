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
with Gabyx.Commands;
with Gabyx.State_Machine;
with Gabyx.UI.Types;
with Gabyx.UI.Layout;
with Gabyx.UI.Grid;
with Gabyx.UI.Menu;
with Gabyx.Config.HUD;
with Gabyx.Config.Audio;
with Gabyx.Config.Game;
with Gabyx.Config.Camera;
with Gabyx.Drivers.Raylib.Window_Mgr;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Renderer;
with Gabyx.Drivers.Raylib.Input;
with Gabyx.Drivers.Raylib.Splash;
with Gabyx.Drivers.Raylib.Audio;
with Gabyx.Drivers.Raylib.Menu;
with Raylib;

package body Gabyx.Drivers.Raylib is

   use Gabyx.Types;
   use Gabyx.Commands;
   use Gabyx.State_Machine;
   use Gabyx.UI.Types;
   use Gabyx.UI.Menu;

   procedure Run
     (Config   : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration)
   is
      procedure Refresh_Layout;

      Game_Cfg   : constant Gabyx.Config.Game.Game_Configuration   := Gabyx.Config.Game.Load_Configuration;
      HUD_Cfg    : constant Gabyx.Config.HUD.HUD_Configuration     := Gabyx.Config.HUD.Load_Configuration;
      Audio_Cfg  : constant Gabyx.Config.Audio.Audio_Configuration := Gabyx.Config.Audio.Load_Configuration;
      Camera_Cfg : Gabyx.Config.Camera.Camera_Configuration        := Gabyx.Config.Camera.Load_Configuration;

      Forced_HUD_Tier : HUD_Tier_Type := HUD_Auto;
      Top_View        : HUD_View_Type := View_A;
      Bottom_View     : HUD_View_Type := View_A;
      Layout          : Layout_Cache;
      Grid_Info       : Gabyx.UI.Grid.Grid_Metrics;

      Zoom_Sizes : constant array (1 .. 6) of Positive := [24, 32, 48, 64, 80, 96];
      Cur_Zoom   : Positive := 4;

      Menu_Data : Gabyx.UI.Menu.Menu_State;

      procedure Refresh_Layout is
      begin
         Layout := Gabyx.UI.Layout.Calculate_Layout
           (Width       => Width_Type (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Width),
            Height      => Height_Type (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Height),
            Forced_Tier => Forced_HUD_Tier);

         Grid_Info := Gabyx.UI.Grid.Calculate_Grid
           (Viewport_Width  => Layout.Viewport_Rect.Width,
            Viewport_Height => Layout.Viewport_Rect.Height,
            Tile_Size       => Zoom_Sizes (Cur_Zoom));
      end Refresh_Layout;

   begin
      --  1. Inicjalizacja podsystemów
      Gabyx.Drivers.Raylib.Window_Mgr.Initialize (Config);
      Gabyx.Drivers.Raylib.Fonts.Load_All (Font_Cfg);
      Gabyx.Drivers.Raylib.Audio.Initialize (Audio_Cfg);
      Gabyx.Drivers.Raylib.Splash.Initialize (Game_Cfg);
      Refresh_Layout;

      Gabyx.State_Machine.Set_State
        (if Gabyx.Drivers.Raylib.Splash.Is_Finished then State_Main_Menu else State_Splash);

      --  2. Główna pętla wykonawcza z maszyną stanów
      while not Boolean (Standard.Raylib.WindowShouldClose)
         and then not Gabyx.State_Machine.Is_In_State (State_Quit)
      loop
         case Gabyx.State_Machine.Get_State is
            --  STAN A: Ekran startowy Splash
            when State_Splash =>
               Gabyx.Drivers.Raylib.Splash.Update;
               Gabyx.Drivers.Raylib.Splash.Render (Font_Cfg);

               if Gabyx.Drivers.Raylib.Splash.Is_Finished then
                  Gabyx.State_Machine.Set_State (State_Main_Menu);
               end if;

            --  STAN B: Menu Główne
            when State_Main_Menu =>
               declare
                  Action_Triggered : Boolean := False;
               begin
                  --  Obsługa klawiatury w menu
                  if Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_DOWN))
                     or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_S))
                  then
                     Gabyx.UI.Menu.Select_Next (Menu_Data);
                     Gabyx.Drivers.Raylib.Audio.Play_Menu_Move;
                  elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_UP))
                     or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_W))
                  then
                     Gabyx.UI.Menu.Select_Prev (Menu_Data);
                     Gabyx.Drivers.Raylib.Audio.Play_Menu_Move;
                  elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ENTER))
                     or Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_SPACE))
                  then
                     Action_Triggered := True;
                  elsif Boolean (Standard.Raylib.IsKeyPressed (Standard.Raylib.KEY_ESCAPE)) then
                     Gabyx.State_Machine.Set_State (State_Quit);
                  end if;

                  --  Renderowanie i obsługa kliknięć myszy
                  Gabyx.Drivers.Raylib.Menu.Render (Menu_Data, Font_Cfg, Action_Triggered);

                  if Action_Triggered then
                     Gabyx.Drivers.Raylib.Audio.Play_Menu_Select;
                     case Menu_Data.Selected_Item is
                        when Item_New_Game =>
                           Menu_Data.Has_Active_Game := True;
                           Gabyx.State_Machine.Set_State (State_In_Game);
                        when Item_Settings =>
                           Gabyx.State_Machine.Set_State (State_Settings);
                        when Item_Quit =>
                           Gabyx.State_Machine.Set_State (State_Quit);
                        when others =>
                           null;
                     end case;
                  end if;
               end;

            --  STAN C: Główna gra (Loch, Viewport, Siatka)
            when State_In_Game | State_Settings =>
               declare
                  Cmd : constant Game_Command := Gabyx.Drivers.Raylib.Input.Poll_Command;
               begin
                  case Cmd is
                     when Cmd_Quit =>
                        --  Klawisz ESC powraca do Menu Głównego z aktywną sesją (Zapisz staje się aktywne!)
                        Gabyx.State_Machine.Set_State (State_Main_Menu);

                     when Cmd_Select_Preset_1 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (1); Refresh_Layout;
                     when Cmd_Select_Preset_2 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (2); Refresh_Layout;
                     when Cmd_Select_Preset_3 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (3); Refresh_Layout;
                     when Cmd_Select_Preset_4 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (4); Refresh_Layout;
                     when Cmd_Select_Preset_5 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (5); Refresh_Layout;
                     when Cmd_Select_Preset_6 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (6); Refresh_Layout;
                     when Cmd_Select_Preset_7 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (7); Refresh_Layout;
                     when Cmd_Select_Preset_8 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (8); Refresh_Layout;
                     when Cmd_Select_Preset_9 => Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (9); Refresh_Layout;
                     when Cmd_Toggle_Borderless => Gabyx.Drivers.Raylib.Window_Mgr.Toggle_Borderless;

                     when Cmd_HUD_Tier_Auto     => Forced_HUD_Tier := HUD_Auto;     Refresh_Layout;
                     when Cmd_HUD_Tier_Compact  => Forced_HUD_Tier := HUD_Compact;  Refresh_Layout;
                     when Cmd_HUD_Tier_Standard => Forced_HUD_Tier := HUD_Standard; Refresh_Layout;
                     when Cmd_HUD_Tier_HiDPI    => Forced_HUD_Tier := HUD_HiDPI;    Refresh_Layout;

                     when Cmd_Toggle_Top_View   => Top_View := (if Top_View = View_A then View_B else View_A);
                     when Cmd_Toggle_Bottom_View=> Bottom_View := (if Bottom_View = View_A then View_B else View_A);
                     when Cmd_Toggle_Font_Family=> Gabyx.Drivers.Raylib.Fonts.Toggle_Font;

                     when Cmd_Toggle_Grid =>
                        Camera_Cfg.Grid_Visible := not Camera_Cfg.Grid_Visible;

                     when Cmd_Cycle_Grid_Color =>
                        Camera_Cfg.Active_Color_Index :=
                          (if Camera_Cfg.Active_Color_Index >= Camera_Cfg.Color_Count then 1
                           else Camera_Cfg.Active_Color_Index + 1);

                     when Cmd_Tile_Zoom_1 => Cur_Zoom := 1; Refresh_Layout;
                     when Cmd_Tile_Zoom_2 => Cur_Zoom := 2; Refresh_Layout;
                     when Cmd_Tile_Zoom_3 => Cur_Zoom := 3; Refresh_Layout;
                     when Cmd_Tile_Zoom_4 => Cur_Zoom := 4; Refresh_Layout;
                     when Cmd_Tile_Zoom_5 => Cur_Zoom := 5; Refresh_Layout;
                     when Cmd_Tile_Zoom_6 => Cur_Zoom := 6; Refresh_Layout;

                     when Cmd_None =>
                        null;
                  end case;
               end;

               --  Renderowanie klatki gry
               Gabyx.Drivers.Raylib.Renderer.Render_Frame
                 (Layout       => Layout,
                  Grid_Info    => Grid_Info,
                  Grid_Visible => Camera_Cfg.Grid_Visible,
                  Grid_Color   => Camera_Cfg.Palette (Camera_Cfg.Active_Color_Index),
                  Top_View     => Top_View,
                  Bottom_View  => Bottom_View,
                  HUD_Cfg      => HUD_Cfg,
                  Win_Cfg      => Config,
                  Font_Cfg     => Font_Cfg);

            when State_Quit =>
               exit;
         end case;
      end loop;

      --  3. Bezpieczne zwolnienie zasobów
      Gabyx.Drivers.Raylib.Audio.Close;
      Gabyx.Drivers.Raylib.Fonts.Unload_All;
      Gabyx.Drivers.Raylib.Window_Mgr.Close;
   end Run;

end Gabyx.Drivers.Raylib;
