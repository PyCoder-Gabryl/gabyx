--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja panelu Sterowanie z podglądem skrótów i resetem.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/views/settings/gabyx-drivers-raylib-settings-pane_input.adb
--  CREATED:         2026-08-26
--  ============================================================================


with Gabyx.Drivers.Raylib.Fonts;
with Gabyx.Drivers.Raylib.Widgets;
with Raylib;

package body Gabyx.Drivers.Raylib.Settings.Pane_Input is

   procedure Render_Pane
     (Pane_X   : Integer;
      Pane_Y   : Integer;
      Pane_W   : Integer;
      Pane_H   : Integer;
      Input_Cfg: in out Gabyx.Config.Input.Input_Configuration;
      Font_Cfg : Gabyx.Config.Fonts.Font_Configuration;
      Changed  : out Boolean)
   is
      pragma Unreferenced (Pane_H);

      Cur_Font   : constant Standard.Raylib.Font := Gabyx.Drivers.Raylib.Fonts.Get_Active_Font;
      Font_Sz    : constant Float := Float (Font_Cfg.Size_Small);
      F_Size     : constant Float := (if Font_Sz > 14.0 then 14.0 else Font_Sz);

      Reset_Btn  : Boolean := False;
   begin
      Changed := False;

      --  1. Tabela Skrótów
      Gabyx.Drivers.Raylib.Widgets.Draw_Section_Box
        (X => Pane_X, Y => Pane_Y, W => Pane_W, H => 240,
         Title => "PODGLAD PRZYPISAN KLAWIATURY (DATA-DRIVEN)",
         Font => Cur_Font, Font_Size => F_Size);

      Standard.Raylib.DrawTextEx
        (Cur_Font,
         "• Ruch bohatera:      [ W / S / A / E ] (Dyskretny krok o 1 pole)" & Ada.Characters.Latin_1.LF &
         "• Akcja / Czekanie:   [ SPACJA ]" & Ada.Characters.Latin_1.LF &
         "• Paski HUD:          [ G ] Przepnij Gore   [ D ] Przepnij Dol" & Ada.Characters.Latin_1.LF &
         "• Typografia:         [ F ] Przelacz kroje Nerd Fonts" & Ada.Characters.Latin_1.LF &
         "• Siatka swiata:      [ S ] Zmien kolor     [ Option+S ] On/Off" & Ada.Characters.Latin_1.LF &
         "• Skala HUD-u:        [ Option+1..3 ] Skala [ Option+0 ] Auto" & Ada.Characters.Latin_1.LF &
         "• Zoom kafelkow:      [ Option+4..9 ] Rozmiary od 24 do 96 px" & Ada.Characters.Latin_1.LF &
         "• Panel Opcji:        [ O ] Otworz w grze   [ ESC ] Powrot",
         (x => Float (Pane_X + 18), y => Float (Pane_Y + 40)),
         F_Size, 1.0, (r => 220, g => 220, b => 220, a => 255));

      --  2. Przycisk Resetu
      Gabyx.Drivers.Raylib.Widgets.Draw_Button
        (X => Pane_X + Pane_W - 270, Y => Pane_Y + 250, W => 270, H => 40,
         Label => "[ ↺ ] PRZYWROC DOMYSLNE",
         Font => Cur_Font, Font_Size => F_Size,
         Clicked => Reset_Btn);

      if Reset_Btn then
         Input_Cfg := Gabyx.Config.Input.Get_Default_Configuration;
         Changed := True;
      end if;
   end Render_Pane;

end Gabyx.Drivers.Raylib.Settings.Pane_Input;
