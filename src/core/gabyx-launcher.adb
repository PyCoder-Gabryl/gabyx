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
with Gabyx.Config;
with Gabyx.Drivers.Raylib;

package body Gabyx.Launcher is

   --  ============================================================================
   --  IMPLEMENTACJA INTERFEJSU PUBLICZNEGO
   --  ============================================================================

   procedure Run is
      App_Config : constant Gabyx.Config.Window_Configuration :=
         Gabyx.Config.Load_Window_Configuration;

      Font_Config : constant Gabyx.Config.Font_Configuration :=
         Gabyx.Config.Load_Font_Configuration;

      Choice         : Integer := 0;
      Exit_Requested : Boolean := False;
   begin
      --  Rysowanie nagłówka ASCII
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line ("==================================================");
      Ada.Text_IO.Put_Line ("           GABYX OMNI-ENGINE STARTER             ");
      Ada.Text_IO.Put_Line ("==================================================");
      Ada.Text_IO.New_Line;

      --  Wypisanie parametrów okna pobranych z konfiguracji TOML
      Ada.Text_IO.Put_Line
        ("[CONFIG] Tytul okna : " & Ada.Strings.Unbounded.To_String (App_Config.Title));
      Ada.Text_IO.Put_Line
        ("[CONFIG] Szerokosc  : " & App_Config.Width'Image & " px");
      Ada.Text_IO.Put_Line
        ("[CONFIG] Wysokosc   : " & App_Config.Height'Image & " px");
      Ada.Text_IO.Put_Line
        ("[CONFIG] Preset     : " & App_Config.Active_Preset'Image);
      Ada.Text_IO.Put_Line
        ("[CONFIG] Tryb okna  : " & App_Config.Display_Mode'Image);
      Ada.Text_IO.Put_Line
        ("[CONFIG] V-Sync     : " & App_Config.VSync'Image);
      Ada.Text_IO.Put_Line
        ("[CONFIG] Target FPS : " & App_Config.Target_FPS'Image);
      Ada.Text_IO.Put_Line
        ("[CONFIG:FONTS]  Czcionka   : " & Ada.Strings.Unbounded.To_String (Font_Config.Family));
      Ada.Text_IO.Put_Line
        ("[CONFIG:FONTS]  Rozmiar UI : " & Font_Config.Size_Regular'Image & " px");
      Ada.Text_IO.Put_Line
        ("[CONFIG:FONTS]  Monospace  : " & Font_Config.Is_Monospace'Image);

      --  Główna pętla interaktywnego menu wyboru
      while not Exit_Requested loop
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line ("--------------------------------------------------");
         Ada.Text_IO.Put_Line ("Wybierz sterownik prezentacji:");
         Ada.Text_IO.Put_Line ("   Tryby tekstowe (TUI):");
         Ada.Text_IO.Put_Line ("   1. ANSI Escape Codes (Czysty SPARK)");
         Ada.Text_IO.Put_Line ("   2. Ncurses TUI (Wydajnosc okienkowa)");
         Ada.Text_IO.Put_Line ("   3. Trendy_Terminal TUI (Deklaratywne)");
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line ("   Tryby graficzne (GUI):");
         Ada.Text_IO.Put_Line ("   4. Raylib 2D Engine (Glowny)");
         Ada.Text_IO.Put_Line ("   5. SDL2 Engine (Atrapa)");
         Ada.Text_IO.Put_Line ("   6. GtkAda GUI (Atrapa)");
         Ada.Text_IO.Put_Line ("   7. ASFML Engine (SFML - Atrapa)");
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line ("   Zarzadzanie:");
         Ada.Text_IO.Put_Line ("   8. Wyjscie");
         Ada.Text_IO.Put_Line ("--------------------------------------------------");
         Ada.Text_IO.Put ("Wybor: ");

         begin
            Ada.Integer_Text_IO.Get (Choice);
            Ada.Text_IO.Skip_Line; --  Czyszczenie bufora wejściowego

            case Choice is
               when 1 =>
                  Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika ANSI Escape Codes...");
               when 2 =>
                  Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika Ncurses TUI...");
               when 3 =>
                  Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika Trendy_Terminal TUI...");
               when 4 =>
                  Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika Raylib 2D Engine...");
                  Gabyx.Drivers.Raylib.Run (App_Config, Font_Config);
               when 5 =>
                  Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika SDL2 Engine...");
               when 6 =>
                  Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika GtkAda GUI...");
               when 7 =>
                  Ada.Text_IO.Put_Line ("[INFO] Uruchamianie sterownika ASFML Engine (SFML)...");
               when 8 =>
                  Exit_Requested := True;
                  Ada.Text_IO.Put_Line ("[INFO] Zamykanie programu. Do zobaczenia!");
               when others =>
                  Ada.Text_IO.Put_Line ("[BLAD] Niepoprawny wybor! Wprowadz liczbe od 1 do 8.");
            end case;
         exception
            when others =>
               Ada.Text_IO.Put_Line ("[BLAD] Blad wejscia! Wprowadz poprawna liczbe.");
               Ada.Text_IO.Skip_Line; --  Zapobieganie pętli nieskończonej
         end;
      end loop;
   end Run;

end Gabyx.Launcher;
