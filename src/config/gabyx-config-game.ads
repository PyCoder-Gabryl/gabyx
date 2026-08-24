--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Specyfikacja modułu konfiguracji aplikacji, rozgrywki i profili.
--                   Zarządza czasem trwania Splash Screenu, aktywnym profilem gracza
--                   w katalogu data/saves/<profil>/ oraz językiem lokalizacji i18n.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-game.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Ada.Strings.Unbounded;

package Gabyx.Config.Game is

   use Ada.Strings.Unbounded;

   Default_Config_Path : constant String := "data/config/game.toml";

   type Game_Configuration is record
      Splash_Duration_Sec : Float            := 1.0;
      Language            : Unbounded_String := To_Unbounded_String ("pl");
      Dev_Mode            : Boolean          := True;
      Active_Profile      : Unbounded_String := To_Unbounded_String ("default");
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Game_Configuration;

   function Get_Default_Configuration return Game_Configuration;

   --  Zwraca ścieżkę do katalogu zapisu aktywnego profilu (np. "data/saves/default/")
   function Get_Active_Save_Directory
     (Config : Game_Configuration) return String;

end Gabyx.Config.Game;
