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
with Gabyx.UI.Types;
with Gabyx.UI.Layout;
with Gabyx.Config.HUD;
with Gabyx.Drivers.Raylib.Window_Mgr;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Renderer;
with Gabyx.Drivers.Raylib.Input;
with Raylib;

package body Gabyx.Drivers.Raylib is

   use Gabyx.Types;
   use Gabyx.Commands;
   use Gabyx.UI.Types;

   procedure Run
     (Config   : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration)
   is
      --  Wcześniejsza deklaracja procedury lokalnej (wymóg stylu -gnatys)
      procedure Refresh_Layout;

      HUD_Cfg         : constant Gabyx.Config.HUD.HUD_Configuration := Gabyx.Config.HUD.Load_Configuration;
      Forced_HUD_Tier : HUD_Tier_Type := HUD_Auto;
      Top_View        : HUD_View_Type := View_A;
      Bottom_View     : HUD_View_Type := View_A;
      Layout          : Layout_Cache;

      procedure Refresh_Layout is
      begin
         Layout := Gabyx.UI.Layout.Calculate_Layout
           (Width       => Width_Type (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Width),
            Height      => Height_Type (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Height),
            Forced_Tier => Forced_HUD_Tier);
      end Refresh_Layout;

   begin
      --  1. Inicjalizacja podsystemów
      Gabyx.Drivers.Raylib.Window_Mgr.Initialize (Config);
      Gabyx.Drivers.Raylib.Fonts.Load_All (Font_Cfg);
      Refresh_Layout;

      --  2. Główna pętla wykonawcza (Event Dispatcher)
      while not Boolean (Standard.Raylib.WindowShouldClose) loop
         declare
            Cmd : constant Game_Command := Gabyx.Drivers.Raylib.Input.Poll_Command;
         begin
            case Cmd is
               when Cmd_Quit =>
                  exit;
               when Cmd_Select_Preset_1 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (1);
                  Refresh_Layout;
               when Cmd_Select_Preset_2 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (2);
                  Refresh_Layout;
               when Cmd_Select_Preset_3 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (3);
                  Refresh_Layout;
               when Cmd_Select_Preset_4 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (4);
                  Refresh_Layout;
               when Cmd_Select_Preset_5 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (5);
                  Refresh_Layout;
               when Cmd_Select_Preset_6 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (6);
                  Refresh_Layout;
               when Cmd_Select_Preset_7 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (7);
                  Refresh_Layout;
               when Cmd_Select_Preset_8 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (8);
                  Refresh_Layout;
               when Cmd_Select_Preset_9 =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Apply_Preset (9);
                  Refresh_Layout;
               when Cmd_Toggle_Borderless =>
                  Gabyx.Drivers.Raylib.Window_Mgr.Toggle_Borderless;

               when Cmd_HUD_Tier_Auto =>
                  Forced_HUD_Tier := HUD_Auto;
                  Refresh_Layout;
               when Cmd_HUD_Tier_Compact =>
                  Forced_HUD_Tier := HUD_Compact;
                  Refresh_Layout;
               when Cmd_HUD_Tier_Standard =>
                  Forced_HUD_Tier := HUD_Standard;
                  Refresh_Layout;
               when Cmd_HUD_Tier_HiDPI =>
                  Forced_HUD_Tier := HUD_HiDPI;
                  Refresh_Layout;

               when Cmd_Toggle_Top_View =>
                  Top_View := (if Top_View = View_A then View_B else View_A);

               when Cmd_Toggle_Bottom_View =>
                  Bottom_View := (if Bottom_View = View_A then View_B else View_A);

               when Cmd_Toggle_Font_Family =>
                  Gabyx.Drivers.Raylib.Fonts.Toggle_Font;

               when Cmd_None =>
                  null;
            end case;
         end;

         --  3. Delegacja renderowania klatki
         Gabyx.Drivers.Raylib.Renderer.Render_Frame
           (Layout      => Layout,
            Top_View    => Top_View,
            Bottom_View => Bottom_View,
            HUD_Cfg     => HUD_Cfg,
            Win_Cfg     => Config,
            Font_Cfg    => Font_Cfg);
      end loop;

      --  4. Bezpieczne zwolnienie zasobów
      Gabyx.Drivers.Raylib.Fonts.Unload_All;
      Gabyx.Drivers.Raylib.Window_Mgr.Close;
   end Run;

end Gabyx.Drivers.Raylib;
