--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja modułu startowego (Launcher) gry Gabyx.
--                    Odpowiada za orkiestrację procesu uruchomieniowego,
--                    prezentację nagłówka powitalnego, diagnostykę
--                    konfiguracji oraz interaktywne menu wyboru sterownika.
--  ----------------------------------------------------------------------------
--  PATH:            src/core/gabyx-launcher.ads
--  CREATED:         2026-08-22
--  ============================================================================


package Gabyx.Launcher is

   --  ============================================================================
   --  PUBLICZNY INTERFEJS STARTOWY
   --  ============================================================================

   --  Główna procedura startowa – ładuje konfigurację i uruchamia menu wyboru
   procedure Run;

end Gabyx.Launcher;
