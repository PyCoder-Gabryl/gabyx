--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Główny punkt wejściowy (Starter) gry Gabyx.
--                    Odpowiada za zainicjowanie podstawowych informacji,
--                    wczytanie i sparsowanie pliku konfiguracyjnego TOML,
--                    wyświetlenie parametrów rozdzielczości oraz terminalowego
--                    menu wyboru aktywnego silnika graficznego.
--  ----------------------------------------------------------------------------
--  PATH:            src/main.adb
--  CREATED:         2026-08-04
--  ============================================================================


with Gabyx.Launcher;

procedure Main is
begin
   Gabyx.Launcher.Run;
end Main;
