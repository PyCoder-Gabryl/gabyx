--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Specyfikacja modułu konfiguracji audio i głośności.
--                   Definiuje rekord Audio_Configuration oraz publiczny
--                   interfejs defensywnego ładowania pliku data/config/audio.toml.
--  ----------------------------------------------------------------------------
--  PATH:            src/config/gabyx-config-audio.ads
--  CREATED:         2026-08-24
--  ============================================================================


with Gabyx.Types;

package Gabyx.Config.Audio is

   use Gabyx.Types;

   Default_Config_Path : constant String := "data/config/audio.toml";

   type Audio_Configuration is record
      Master_Volume     : Volume_Level := 80;
      Music_Volume      : Volume_Level := 70;
      SFX_Volume        : Volume_Level := 90;
      Ambient_Volume    : Volume_Level := 60;
      Is_Muted          : Boolean      := False;
      UI_Clicks_Enabled : Boolean      := True;
   end record;

   function Load_Configuration
     (File_Path : String := Default_Config_Path) return Audio_Configuration;

   function Get_Default_Configuration return Audio_Configuration;

end Gabyx.Config.Audio;
