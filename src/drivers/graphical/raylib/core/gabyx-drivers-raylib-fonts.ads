--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł zarządzania zasobami czcionek GPU dla sterownika Raylib.
--                   Wczytuje kwartety krojów Nerd Fonts, nakłada filtry dwuliniowe,
--                   zarządza przełączaniem krojów w locie i zwalnia pamięć GPU.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/core/gabyx-drivers-raylib-fonts.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Config.Fonts;
with Raylib;

package Gabyx.Drivers.Raylib.Fonts is

   --  Ładuje czcionki do pamięci GPU i nakłada filtr dwuliniowy
   procedure Load_All (Font_Cfg : Gabyx.Config.Fonts.Font_Configuration);

   --  Przełącza aktywną czcionkę (Intel One Mono <-> JetBrains Mono)
   procedure Toggle_Font;

   --  Zwraca uchwyt do aktywnej czcionki Raylib
   function Get_Active_Font return Standard.Raylib.Font;

   --  Zwraca nazwę aktywnego kroju pisma
   function Get_Active_Font_Name return String;

   --  Zwalnia zasoby czcionek z pamięci karty graficznej
   procedure Unload_All;

end Gabyx.Drivers.Raylib.Fonts;
