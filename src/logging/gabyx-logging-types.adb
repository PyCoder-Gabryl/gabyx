--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja funkcji konwersji typów logowania na napisy w SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/logging/gabyx-logging-types.adb
--  CREATED:         2026-08-28
--  ============================================================================


package body Gabyx.Logging.Types with
   SPARK_Mode => On
is

   function Level_To_String (Level : Log_Level) return String is
     (case Level is
         when Level_Trace    => "TRACE",
         when Level_Debug    => "DEBUG",
         when Level_Info     => "INFO",
         when Level_Warning  => "WARN",
         when Level_Error    => "ERROR",
         when Level_Critical => "CRITICAL");

   function Domain_To_String (Domain : Log_Domain) return String is
     (case Domain is
         when Domain_Engine => "ENGINE",
         when Domain_Config => "CONFIG",
         when Domain_Window => "WINDOW",
         when Domain_Render => "RENDER",
         when Domain_Audio  => "AUDIO",
         when Domain_Input  => "INPUT",
         when Domain_UI     => "UI",
         when Domain_Game   => "GAME",
         when Domain_Save   => "SAVE");

   function String_To_Level (Str : String; Default : Log_Level) return Log_Level is
   begin
      if Str = "TRACE" then return Level_Trace;
      elsif Str = "DEBUG" then return Level_Debug;
      elsif Str = "INFO" then return Level_Info;
      elsif Str = "WARN" or Str = "WARNING" then return Level_Warning;
      elsif Str = "ERROR" then return Level_Error;
      elsif Str = "CRITICAL" or Str = "FATAL" then return Level_Critical;
      else return Default;
      end if;
   end String_To_Level;

end Gabyx.Logging.Types;
