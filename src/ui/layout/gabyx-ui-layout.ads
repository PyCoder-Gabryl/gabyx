--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Formalny moduł kalkulacji geometrii kontenerów UI.
--                   Dzieli wirtualną przestrzeń na 3 niezależne pojemniki:
--                   Górny pasek, Viewport świata oraz Dolny dashboard.
--                   Obsługuje buforowanie geometrii (Layout Cache) oraz
--                   automatyczne wykrywanie proporcji Ultra-Wide (21:9).
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/layout/gabyx-ui-layout.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.Types;
with Gabyx.UI.Types;

package Gabyx.UI.Layout with
   SPARK_Mode => On,
   Pure
is

   use Gabyx.Types;
   use Gabyx.UI.Types;

   --  ============================================================================
   --  PUBLICZNY INTERFEJS KALKULATORA GEOMETRII (SPARK)
   --  ============================================================================

   --  Zwraca efektywny profil HUD (rozwiązuje profil Auto na podstawie szerokości)
   function Resolve_Tier
     (Width       : Width_Type;
      Forced_Tier : HUD_Tier_Type) return HUD_Tier_Type;

   --  Wylicza i buforuje geometrię 3 kontenerów na podstawie szerokości, wysokości i profilu
   function Calculate_Layout
     (Width       : Width_Type;
      Height      : Height_Type;
      Forced_Tier : HUD_Tier_Type) return Layout_Cache;

end Gabyx.UI.Layout;
