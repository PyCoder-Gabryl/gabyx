--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja menedżera krojów pisma Raylib. Odpowiada za
--                   bezpieczne ładowanie i zwalnianie tekstur czcionek TTF.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/core/gabyx-drivers-raylib-fonts.adb
--  CREATED:         2026-08-23
--  ============================================================================


with Ada.Strings.Unbounded;

package body Gabyx.Drivers.Raylib.Fonts is

   Font_Intel     : Standard.Raylib.Font;
   Font_JetBrains : Standard.Raylib.Font;
   Active_Font_ID : Integer := 1;

   procedure Load_All (Font_Cfg : Gabyx.Config.Fonts.Font_Configuration) is
      Intel_Path : constant String := Ada.Strings.Unbounded.To_String (Font_Cfg.Regular_Path);
      JB_Path    : constant String := "assets/fonts/jetbrains_mono/JetBrainsMonoNerdFont-Regular.ttf";
   begin
      Font_Intel := Standard.Raylib.LoadFont (Intel_Path);
      Standard.Raylib.SetTextureFilter (Font_Intel.texture_f, Standard.Raylib.TEXTURE_FILTER_BILINEAR);

      Font_JetBrains := Standard.Raylib.LoadFont (JB_Path);
      Standard.Raylib.SetTextureFilter (Font_JetBrains.texture_f, Standard.Raylib.TEXTURE_FILTER_BILINEAR);
   end Load_All;

   procedure Toggle_Font is
   begin
      Active_Font_ID := (if Active_Font_ID = 1 then 2 else 1);
   end Toggle_Font;

   function Get_Active_Font return Standard.Raylib.Font is
     (if Active_Font_ID = 1 then Font_Intel else Font_JetBrains);

   function Get_Active_Font_Name return String is
     (if Active_Font_ID = 1 then "Intel One Mono" else "JetBrains Mono");

   procedure Unload_All is
   begin
      Standard.Raylib.UnloadFont (Font_Intel);
      Standard.Raylib.UnloadFont (Font_JetBrains);
   end Unload_All;

end Gabyx.Drivers.Raylib.Fonts;
