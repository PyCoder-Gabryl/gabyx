--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Moduł symulacji wirtualnych ekranów i proporcji wewnątrz Viewportu.
--                   Umożliwia podgląd siatki dla monitorów 4K, Full HD i Ultra-Wide 21:9
--                   w bieżącym oknie bez konieczności fizycznej zmiany rozdzielczości.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/gabyx-ui-simulation.ads
--  CREATED:         2026-08-23
--  ============================================================================


with Gabyx.UI.Types;

package Gabyx.UI.Simulation with
   SPARK_Mode => On,
   Pure
is

   use Gabyx.UI.Types;

   type Simulation_Preset is
     (Sim_Native,
      Sim_Full_HD,
      Sim_QHD,
      Sim_4K_UHD,
      Sim_Ultra_Wide_HD,
      Sim_Ultra_Wide_QHD);

   --  Zwraca czytelną nazwę aktywnego trybu symulacji
   function Get_Simulation_Name (Preset : Simulation_Preset) return String;

end Gabyx.UI.Simulation;
