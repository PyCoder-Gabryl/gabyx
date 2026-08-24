--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja rysowania pasów HUD Raylib z obsługą widoków A/B.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/renderer/gabyx-drivers-raylib-renderer-hud.adb
--  CREATED:         2026-08-24
--  ============================================================================


with Interfaces.C;
with Ada.Characters.Latin_1;
with Gabyx.UI.Panels;
with Gabyx.Drivers.Raylib.Fonts;
with Raylib;

package body Gabyx.Drivers.Raylib.Renderer.HUD is

   use Interfaces.C;
   use Gabyx.UI.Types;

   procedure Draw
     (Layout    : Gabyx.UI.Types.Layout_Cache;
      Top_View  : Gabyx.UI.Types.HUD_View_Type;
      Bot_View  : Gabyx.UI.Types.HUD_View_Type;
      Grid_Info : Gabyx.UI.Grid.Grid_Metrics;
      HUD_Cfg   : Gabyx.Config.HUD.HUD_Configuration;
      Win_Cfg   : Gabyx.Config.Window.Window_Configuration;
      Font_Cfg  : Gabyx.Config.Fonts.Font_Configuration;
      Vp_X      : Integer;
      Vp_Y      : Integer)
   is
      Cur_Font   : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Name  : constant String := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font_Name;
      Screen_W   : constant int := Standard.Raylib.GetScreenWidth;
      Screen_H   : constant int := Standard.Raylib.GetScreenHeight;
      FPS_Val    : constant Natural := (if Win_Cfg.Target_FPS > 0 then Natural (Win_Cfg.Target_FPS) else 60);

      Top_Col : constant Standard.Raylib.Color :=
        (if Top_View = View_A then
           (r => unsigned_char (HUD_Cfg.Color_Top_View_A.R),
            g => unsigned_char (HUD_Cfg.Color_Top_View_A.G),
            b => unsigned_char (HUD_Cfg.Color_Top_View_A.B),
            a => unsigned_char (HUD_Cfg.Color_Top_View_A.A))
         else
           (r => unsigned_char (HUD_Cfg.Color_Top_View_B.R),
            g => unsigned_char (HUD_Cfg.Color_Top_View_B.G),
            b => unsigned_char (HUD_Cfg.Color_Top_View_B.B),
            a => unsigned_char (HUD_Cfg.Color_Top_View_B.A)));

      Bot_Col : constant Standard.Raylib.Color :=
        (if Bot_View = View_A then
           (r => unsigned_char (HUD_Cfg.Color_Bottom_View_A.R),
            g => unsigned_char (HUD_Cfg.Color_Bottom_View_A.G),
            b => unsigned_char (HUD_Cfg.Color_Bottom_View_A.B),
            a => unsigned_char (HUD_Cfg.Color_Bottom_View_A.A))
         else
           (r => unsigned_char (HUD_Cfg.Color_Bottom_View_B.R),
            g => unsigned_char (HUD_Cfg.Color_Bottom_View_B.G),
            b => unsigned_char (HUD_Cfg.Color_Bottom_View_B.B),
            a => unsigned_char (HUD_Cfg.Color_Bottom_View_A.A)));

      Text_White : constant Standard.Raylib.Color := (r => 245, g => 245, b => 245, a => 255);
      Text_Gold  : constant Standard.Raylib.Color := (r => 255, g => 203, b => 0,   a => 255);
      Text_Cyan  : constant Standard.Raylib.Color := (r => 80,  g => 220, b => 240, a => 255);
   begin
      --  1. Górny pasek
      Standard.Raylib.DrawRectangle
        (int (Vp_X) + int (Layout.Top_Bar_Rect.X),
         int (Vp_Y) + int (Layout.Top_Bar_Rect.Y),
         int (Layout.Top_Bar_Rect.Width),
         int (Layout.Top_Bar_Rect.Height),
         Top_Col);

      if Top_View = View_A then
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            Gabyx.UI.Panels.Get_Top_Bar_Text
              (View          => Top_View,
               Virtual_W     => Positive (Layout.Screen_Width),
               Virtual_H     => Positive (Layout.Screen_Height),
               Screen_W      => Positive (Screen_W),
               Screen_H      => Positive (Screen_H),
               Is_Ultra_Wide => Layout.Is_Ultra_Wide,
               Active_Tier   => Layout.Active_Tier,
               Font_Family   => Font_Name,
               FPS           => FPS_Val),
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + 8)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_White);
      else
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            "SIATKA: " & Grid_Info.Columns'Image & "x" & Grid_Info.Rows'Image & " (" &
            Grid_Info.Total_Tiles'Image & " pol) | KAFELEK: " & Grid_Info.Tile_Size'Image &
            "px | MARGINESY: X=" & Grid_Info.Margin_X'Image & "px, Y=" & Grid_Info.Margin_Y'Image & "px",
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + 8)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_Cyan);
      end if;

      --  2. Dolny pasek
      Standard.Raylib.DrawRectangle
        (int (Vp_X) + int (Layout.Bottom_Bar_Rect.X),
         int (Vp_Y) + int (Layout.Bottom_Bar_Rect.Y),
         int (Layout.Bottom_Bar_Rect.Width),
         int (Layout.Bottom_Bar_Rect.Height),
         Bot_Col);

      if Bot_View = View_A then
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            Gabyx.UI.Panels.Get_Bottom_Bar_Text (View => Bot_View, Is_Ultra_Wide => Layout.Is_Ultra_Wide),
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + Layout.Bottom_Bar_Rect.Y + 12)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_Gold);
      else
         Standard.Raylib.DrawTextEx
           (Cur_Font,
            "SKROTY SIATKI: [S] Zmien kolor siatki  [Option+S] Wlacz/Wylacz siatke" & Ada.Characters.Latin_1.LF &
            "[Option+4..9] Rozmiar kafelka: 24, 32, 48, 64, 80, 96 px",
            (x => C_float (Vp_X + 20), y => C_float (Vp_Y + Layout.Bottom_Bar_Rect.Y + 12)),
            C_float (Font_Cfg.Size_Small),
            1.0,
            Text_White);
      end if;
   end Draw;

end Gabyx.Drivers.Raylib.Renderer.HUD;
