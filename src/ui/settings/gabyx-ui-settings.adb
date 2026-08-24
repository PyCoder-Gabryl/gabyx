--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:     Implementacja modelu nawigacji i etykiet opisowych okna Ustawień w SPARK.
--  ----------------------------------------------------------------------------
--  PATH:            src/ui/settings/gabyx-ui-settings.adb
--  CREATED:         2026-08-24
--  ============================================================================


package body Gabyx.UI.Settings with
   SPARK_Mode => On
is

   procedure Select_Next (State : in out Settings_State) is
   begin
      State.Selected_Category :=
        (if State.Selected_Category = Settings_Category_ID'Last then Settings_Category_ID'First
         else Settings_Category_ID'Succ (State.Selected_Category));
   end Select_Next;

   procedure Select_Prev (State : in out Settings_State) is
   begin
      State.Selected_Category :=
        (if State.Selected_Category = Settings_Category_ID'First then Settings_Category_ID'Last
         else Settings_Category_ID'Pred (State.Selected_Category));
   end Select_Prev;

   function Get_Category_Name (Cat : Settings_Category_ID) return String is
     (case Cat is
         when Cat_Window      => "1. EKRAN & OKNO",
         when Cat_Graphics    => "2. GRAFIKA & FPS",
         when Cat_Fonts       => "3. TYPOGRAFIA",
         when Cat_HUD         => "4. INTERFEJS HUD",
         when Cat_Camera_Grid => "5. SIATKA & KAMERA",
         when Cat_Audio       => "6. DZWIEK & AUDIO",
         when Cat_Input       => "7. STEROWANIE");

   function Get_Category_Description (Cat : Settings_Category_ID) return String is
     (case Cat is
         when Cat_Window      => "Zarzadzanie rozdzielczoscia, trybami okna i monitorami (window.toml)",
         when Cat_Graphics    => "Limit klatkarza (30..165 FPS), V-Sync i pasy centrujace",
         when Cat_Fonts       => "Kwartety czcionek Nerd Fonts, rozmiary tekstu i wygladzanie (fonts.toml)",
         when Cat_HUD         => "Profile skali (Compact/Standard/HiDPI) i widoki paneli (hud.toml)",
         when Cat_Camera_Grid => "6 poziomow zoomu (24..96 px), kolory siatki i martwa strefa (camera.toml)",
         when Cat_Audio       => "Glosnosc glowna, muzyka, efekty SFX i otoczenie (audio.toml)",
         when Cat_Input       => "Mapowanie klawiatury i skrotow systemowych (input.toml)");

end Gabyx.UI.Settings;
