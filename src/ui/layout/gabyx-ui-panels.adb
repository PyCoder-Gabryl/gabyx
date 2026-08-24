--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja formaterów tekstowych paneli UI. Odpowiada za
--                   generowanie treści diagnostycznych oraz algorytm bezpiecznego
--                   zmniejszania rozmiaru glifów przy przekroczeniu ramki slotu.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/layout/gabyx-ui-panels.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Characters.Latin_1;

package body Gabyx.UI.Panels is

   --  ============================================================================
   --  IMPLEMENTACJA INTERFEJSU PUBLICZNEGO
   --  ============================================================================

   function Get_Top_Bar_Text
     (View          : HUD_View_Type;
      Virtual_W     : Positive;
      Virtual_H     : Positive;
      Screen_W      : Positive;
      Screen_H      : Positive;
      Is_Ultra_Wide : Boolean;
      Active_Tier   : HUD_Tier_Type;
      Font_Family   : String;
      FPS           : Natural) return String
   is
   begin
      if View = View_A then
         return "GABYX // OKNO: " & Virtual_W'Image & "x" & Virtual_H'Image &
                " px | EKRAN: " & Screen_W'Image & "x" & Screen_H'Image &
                " px | FORMAT: " & (if Is_Ultra_Wide then "21:9 Ultra-Wide" else "Standard 16:x") &
                " | CZCIONKA: " & Font_Family & " [Klawisze: G, D, F]";
      else
         return "TYPOGRAFIA: " & Font_Family & " | PROFIL HUD: " & Active_Tier'Image &
                " | FPS: " & FPS'Image & " (V-Sync: Aktywny) [Klawisz G: Wroc do Widoku Okna]";
      end if;
   end Get_Top_Bar_Text;

   function Get_Bottom_Bar_Text
     (View          : HUD_View_Type;
      Is_Ultra_Wide : Boolean) return String
   is
   begin
      if Is_Ultra_Wide then
         return "DOLNY HUD // UKLAD 21:9 ULTRA-WIDE (3 BLOKI ROZSUNIE W JEDNYM RZEDZIE)" &
                Ada.Characters.Latin_1.LF &
                "[Blok 1: Swiat/Zasoby] <---> [Blok 2: Bohater/Akcje] <---> [Blok 3: Dziennik]" &
                Ada.Characters.Latin_1.LF &
                "[1..9] Presety  [B] Ramka  [F] Zmien Font  [G] Gora  [D] Dol  [Option+1..3] Skala HUD";
      elsif View = View_A then
         return "DOLNY HUD // WIDOK A: ROZDZIELCZOSCI [Nacisnij D -> Widok Funkcyjny]" &
                Ada.Characters.Latin_1.LF &
                "[1] 1280x720  [2] 1440x900   [3] 1600x900   [4] 1920x1080  [5] 1920x1200" &
                Ada.Characters.Latin_1.LF &
                "[6] 2560x1080 [7] 2560x1440  [8] 3440x1440  [9] 3840x2160  [B] Przepnij ramke okna";
      else
         return "DOLNY HUD // WIDOK B: SKROTY SYSTEMOWE [Nacisnij D -> Widok Rozdzielczosci]" &
                Ada.Characters.Latin_1.LF &
                "[F] Przelacz Font (Intel <-> JetBrains)   [G] Przepnij Gorny HUD   [D] Przepnij Dolny HUD" &
                Ada.Characters.Latin_1.LF &
                "[Option+1] Compact (32/96)  [Option+2] Standard (40/120)  [Option+3] HiDPI  [Option+0] Auto";
      end if;
   end Get_Bottom_Bar_Text;

   function Calculate_Auto_Shrink
     (Base_Size    : Font_Size_Type;
      Text_Width   : Float;
      Max_Slot_W   : Float) return Font_Size_Type
   is
   begin
      if Text_Width <= Max_Slot_W then
         return Base_Size;
      elsif Text_Width <= (Max_Slot_W * 1.10) and then Base_Size > 9 then
         return Base_Size - 1;
      elsif Text_Width <= (Max_Slot_W * 1.20) and then Base_Size > 10 then
         return Base_Size - 2;
      elsif Base_Size > 11 then
         return Base_Size - 3;
      else
         return Base_Size;
      end if;
   end Calculate_Auto_Shrink;

end Gabyx.UI.Panels;
