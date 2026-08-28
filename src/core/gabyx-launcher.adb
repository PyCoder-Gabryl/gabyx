--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja modułu startowego (Launcher).
--                    Wczytuje parametry okna za pomocą modułu Gabyx.Config,
--                    prezentuje terminalowe menu wyboru silnika (Omni-Engine)
--                    oraz przekazuje sterowanie do wybranego sterownika.
--  ----------------------------------------------------------------------------
--  PATH:            src/core/gabyx-launcher.adb
--  CREATED:         2026-08-22
--  ============================================================================


with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;
with Gabyx.Logging;
with Gabyx.Config.Window;
with Gabyx.Config.Fonts;
with Gabyx.Drivers.Raylib;

package body Gabyx.Launcher is

   use Gabyx.Logging;

   procedure Run is
      Direct_Launch_Raylib : constant Boolean := True;

      App_Config : constant Gabyx.Config.Window.Window_Configuration :=
         Gabyx.Config.Window.Load_Configuration;

      Font_Config : constant Gabyx.Config.Fonts.Font_Configuration :=
         Gabyx.Config.Fonts.Load_Configuration;

      Choice         : Integer := 0;
      Exit_Requested : Boolean := False;
   begin
      --  Rejestracja parametrów w loggerze
      Gabyx.Logging.Log_Info
        (Domain_Config,
         "Konfiguracja okna: " & App_Config.Width'Image & "x" & App_Config.Height'Image &
         " px | Preset: " & App_Config.Active_Preset'Image &
         " | Tryb: " & App_Config.Display_Mode'Image);

      Gabyx.Logging.Log_Info
        (Domain_Config,
         "Typografia: " & Ada.Strings.Unbounded.To_String (Font_Config.Family) &
         " | Rozmiar UI: " & Font_Config.Size_Regular'Image & " px");

      if Direct_Launch_Raylib then
         Gabyx.Logging.Log_Info
           (Domain_Engine,
            "Szybki start aktywny: Uruchamianie glownego sterownika Raylib");
         Gabyx.Drivers.Raylib.Run (App_Config, Font_Config);
         return;
      end if;

      --  Terminalowe menu wyboru (gdy Direct_Launch_Raylib = False)
      while not Exit_Requested loop
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line ("--------------------------------------------------");
         Ada.Text_IO.Put_Line ("Wybierz sterownik prezentacji (Omni-Engine):");
         Ada.Text_IO.Put_Line ("   1. ANSI Escape Codes (Czysty SPARK)");
         Ada.Text_IO.Put_Line ("   2. Ncurses TUI (Wydajnosc okienkowa)");
         Ada.Text_IO.Put_Line ("   3. Trendy_Terminal TUI (Deklaratywne)");
         Ada.Text_IO.Put_Line ("   4. Raylib 2D Engine (Glowny)");
         Ada.Text_IO.Put_Line ("   8. Wyjscie");
         Ada.Text_IO.Put_Line ("--------------------------------------------------");
         Ada.Text_IO.Put ("Wybor: ");

         begin
            Ada.Integer_Text_IO.Get (Choice);
            Ada.Text_IO.Skip_Line;

            case Choice is
               when 4 =>
                  Gabyx.Logging.Log_Info (Domain_Engine, "Wybrano sterownik Raylib 2D");
                  Gabyx.Drivers.Raylib.Run (App_Config, Font_Config);
               when 8 =>
                  Exit_Requested := True;
               when others =>
                  Ada.Text_IO.Put_Line ("[BLAD] Wybierz poprawna opcje.");
            end case;
         exception
            when others =>
               Ada.Text_IO.Skip_Line;
         end;
      end loop;
   end Run;

end Gabyx.Launcher;
