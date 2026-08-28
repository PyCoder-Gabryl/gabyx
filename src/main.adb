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


with Gabyx.Config.Logger;
with Gabyx.Logging;
with Gabyx.Launcher;

procedure Main is
   Logger_Cfg : constant Gabyx.Config.Logger.Logger_Configuration :=
     Gabyx.Config.Logger.Load_Configuration;
begin
   --  1. Start podsystemu logowania jako pierwsza operacja silnika
   Gabyx.Logging.Initialize (Logger_Cfg);
   Gabyx.Logging.Log_Info
     (Gabyx.Logging.Types.Domain_Engine,
      "Uruchomiono glowny punkt wejsciowy Main (Gabyx Omni-Engine)");

   --  2. Przekazanie sterowania do Launchera
   Gabyx.Launcher.Run;

   --  3. Bezpieczne zamknięcie loggera i zrzut buforów pliku
   Gabyx.Logging.Log_Info
     (Gabyx.Logging.Types.Domain_Engine,
      "Zakonczono dzialanie aplikacji - zamykanie logera");
   Gabyx.Logging.Shutdown;
end Main;
