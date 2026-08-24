--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja renderera Raylib. Rysuje wycentrowane prostokąty
--                   oraz pobiera sformatowany tekst z modułu Gabyx.UI.Panels.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Interfaces.C;
with Gabyx.Types;
with Gabyx.Commands;
with Gabyx.State_Machine;
with Gabyx.UI.Types;
with Gabyx.UI.Layout;
with Gabyx.UI.Grid;
with Gabyx.Drivers.Raylib.Window_Mgr;
with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Input;
with Gabyx.Drivers.Raylib.Settings;
with Gabyx.Drivers.Raylib.Renderer.Grid;
with Gabyx.Drivers.Raylib.Renderer.HUD;
with Raylib;

package body Gabyx.Drivers.Raylib.Renderer is

   use Interfaces.C;
   use Gabyx.Types;
   use Gabyx.Commands;
   use Gabyx.UI.Types;

   HUD_Cfg         : Gabyx.Config.HUD.HUD_Configuration;
   Camera_Cfg      : Gabyx.Config.Camera.Camera_Configuration;

   Forced_HUD_Tier : HUD_Tier_Type := HUD_Auto;
   Top_View        : HUD_View_Type := View_A;
   Bottom_View     : HUD_View_Type := View_A;
   Layout          : Layout_Cache;
   Grid_Info       : Gabyx.UI.Grid.Grid_Metrics;

   Zoom_Sizes      : constant array (1 .. 6) of Positive := [24, 32, 48, 64, 80, 96];
   Cur_Zoom        : Positive := 4;

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

   procedure Initialize
     (HUD_Config    : Gabyx.Config.HUD.HUD_Configuration;
      Camera_Config : Gabyx.Config.Camera.Camera_Configuration)
   is
   begin
      HUD_Cfg    := HUD_Config;
      Camera_Cfg := Camera_Config;
      Refresh_Layout;
   end Initialize;

   procedure Process_Game_Frame
     (Win_Cfg  : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration)
   is
      Cmd : constant Game_Command := Gabyx.Drivers.Raylib.Input.Poll_Command;

      Screen_W  : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H  : constant int := Standard.Raylib.GetScreenHeight;
      Virtual_W : constant int := int (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Width);
      Virtual_H : constant int := int (Gabyx.Drivers.Raylib.Window_Mgr.Get_Virtual_Height);

      Vp_X : constant Integer := Integer ((Screen_W - Virtual_W) / 2);
      Vp_Y : constant Integer := Integer ((Screen_H - Virtual_H) / 2);

      Border_Color : constant Standard.Raylib.Color :=
        (r => unsigned_char (Win_Cfg.Border_Bars_Color.R),
         g => unsigned_char (Win_Cfg.Border_Bars_Color.G),
         b => unsigned_char (Win_Cfg.Border_Bars_Color.B),
         a => unsigned_char (Win_Cfg.Border_Bars_Color.A));
   begin
      --  1. Obsługa poleceń gry
      case Cmd is
         when Cmd_Quit =>
            Gabyx.State_Machine.Set_State (State_Main_Menu);
            return;
         when Cmd_Open_Settings =>
            Gabyx.Drivers.Raylib.Settings.Open_From (State_In_Game);
            Gabyx.State_Machine.Set_State (State_Settings);
            return;

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
         when Cmd_Toggle_Bottom_View => Bottom_View := (if Bottom_View = View_A then View_B else View_A);
         when Cmd_Toggle_Font_Family => Gabyx.Drivers.Raylib.Fonts.Toggle_Font;

         when Cmd_Toggle_Grid => Camera_Cfg.Grid_Visible := not Camera_Cfg.Grid_Visible;
         when Cmd_Cycle_Grid_Color =>
            Camera_Cfg.Active_Color_Index :=
              (if Camera_Cfg.Active_Color_Index >= Camera_Cfg.Color_Count then 1 else Camera_Cfg.Active_Color_Index + 1);

         when Cmd_Tile_Zoom_1 => Cur_Zoom := 1; Refresh_Layout;
         when Cmd_Tile_Zoom_2 => Cur_Zoom := 2; Refresh_Layout;
         when Cmd_Tile_Zoom_3 => Cur_Zoom := 3; Refresh_Layout;
         when Cmd_Tile_Zoom_4 => Cur_Zoom := 4; Refresh_Layout;
         when Cmd_Tile_Zoom_5 => Cur_Zoom := 5; Refresh_Layout;
         when Cmd_Tile_Zoom_6 => Cur_Zoom := 6; Refresh_Layout;

         when Cmd_None => null;
      end case;

      --  2. Renderowanie klatki
      Standard.Raylib.BeginDrawing;

      if Gabyx.Drivers.Raylib.Window_Mgr.Get_Display_Mode = Borderless_Fullscreen then
         Standard.Raylib.ClearBackground (Border_Color);
      end if;

      Gabyx.Drivers.Raylib.Renderer.Grid.Draw
        (Layout       => Layout,
         Grid_Info    => Grid_Info,
         Grid_Visible => Camera_Cfg.Grid_Visible,
         Grid_Color   => Camera_Cfg.Palette (Camera_Cfg.Active_Color_Index),
         HUD_Cfg      => HUD_Cfg,
         Vp_X         => Vp_X,
         Vp_Y         => Vp_Y);

      Gabyx.Drivers.Raylib.Renderer.HUD.Draw
        (Layout    => Layout,
         Top_View  => Top_View,
         Bot_View  => Bottom_View,
         Grid_Info => Grid_Info,
         HUD_Cfg   => HUD_Cfg,
         Win_Cfg   => Win_Cfg,
         Font_Cfg  => Font_Cfg,
         Vp_X      => Vp_X,
         Vp_Y      => Vp_Y);

      Standard.Raylib.DrawRectangleLines (int (Vp_X), int (Vp_Y), Virtual_W, Virtual_H, (r => 180, g => 180, b => 180, a => 255));

      Standard.Raylib.EndDrawing;
   end Process_Game_Frame;

end Gabyx.Drivers.Raylib.Renderer;
