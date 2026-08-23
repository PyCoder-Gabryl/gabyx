--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Implementacja kalkulatora geometrii kontenerów UI w SPARK.
--                    Gwarantuje matematyczny brak nakładania się paneli oraz
--                    zachowanie minimalnej dopuszczalnej wysokości Viewportu.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/gabyx-ui-layout.adb
--  CREATED:         2026-08-23
--  ============================================================================


package body Gabyx.UI.Layout with
   SPARK_Mode => On
is

   function Resolve_Tier
     (Width       : Width_Type;
      Forced_Tier : HUD_Tier_Type) return HUD_Tier_Type
   is
   begin
      if Forced_Tier /= HUD_Auto then
         return Forced_Tier;
      end if;

      if Width < 1600 then
         return HUD_Compact;
      elsif Width <= 2560 then
         return HUD_Standard;
      else
         return HUD_HiDPI;
      end if;
   end Resolve_Tier;

   function Calculate_Layout
     (Width       : Width_Type;
      Height      : Height_Type;
      Forced_Tier : HUD_Tier_Type;
      HUD_Cfg     : Gabyx.Config.HUD_Configuration) return Layout_Cache
   is
      Cache        : Layout_Cache;
      Tier         : constant HUD_Tier_Type := Resolve_Tier (Width, Forced_Tier);
      Top_H        : Natural := 32;
      Bottom_H     : Natural := 96;
      Viewport_H   : Natural;
      Is_UW        : constant Boolean := (Float (Width) / Float (Height) >= 2.2);
   begin
      case Tier is
         when HUD_Compact =>
            Top_H    := HUD_Cfg.Compact_Tier.Top_Height;
            Bottom_H := HUD_Cfg.Compact_Tier.Bottom_Height;
         when HUD_Standard =>
            Top_H    := HUD_Cfg.Standard_Tier.Top_Height;
            Bottom_H := HUD_Cfg.Standard_Tier.Bottom_Height;
         when HUD_HiDPI =>
            Top_H    := HUD_Cfg.HiDPI_Tier.Top_Height;
            Bottom_H := HUD_Cfg.HiDPI_Tier.Bottom_Height;
         when HUD_Auto =>
            Top_H    := HUD_Cfg.Standard_Tier.Top_Height;
            Bottom_H := HUD_Cfg.Standard_Tier.Bottom_Height;
      end case;

      if Height > (Top_H + Bottom_H + 100) then
         Viewport_H := Height - Top_H - Bottom_H;
      else
         --  Awaryjna ochrona minimalnej wysokości Viewportu
         Top_H      := 24;
         Bottom_H   := 64;
         Viewport_H := Height - Top_H - Bottom_H;
      end if;

      Cache.Screen_Width    := Width;
      Cache.Screen_Height   := Height;
      Cache.Active_Tier     := Tier;
      Cache.Is_Ultra_Wide   := Is_UW;

      Cache.Top_Bar_Rect    := (X => 0, Y => 0, Width => Width, Height => Top_H);
      Cache.Viewport_Rect   := (X => 0, Y => Top_H, Width => Width, Height => Viewport_H);
      Cache.Bottom_Bar_Rect := (X => 0, Y => Top_H + Viewport_H, Width => Width, Height => Bottom_H);

      return Cache;
   end Calculate_Layout;

end Gabyx.UI.Layout;
