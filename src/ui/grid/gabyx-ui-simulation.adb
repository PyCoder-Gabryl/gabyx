--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja formaterów nazw dla modułu symulacji rozdzielczości.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/grid/gabyx-ui-simulation.adb
--  CREATED:         2026-08-23
--  ============================================================================


package body Gabyx.UI.Simulation with
   SPARK_Mode => On
is

   function Get_Simulation_Name (Preset : Simulation_Preset) return String is
     (case Preset is
         when Sim_Native         => "Natywny Viewport",
         when Sim_Full_HD        => "Symulacja 16:9 Full HD (1920x1080)",
         when Sim_QHD            => "Symulacja 16:9 QHD 2K (2560x1440)",
         when Sim_4K_UHD         => "Symulacja 16:9 4K UHD (3840x2160)",
         when Sim_Ultra_Wide_HD  => "Symulacja 21:9 Ultra-Wide (2560x1080)",
         when Sim_Ultra_Wide_QHD => "Symulacja 21:9 UW-QHD (3440x1440)");

end Gabyx.UI.Simulation;
