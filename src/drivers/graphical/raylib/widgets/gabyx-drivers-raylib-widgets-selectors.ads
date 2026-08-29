--  ============================================================================
--  PROJECT:         Gabyx: Ada Roguleike
--  AUTHOR:          PyCoder Gabryl
--  GITHUB:          https://github.com/PyCoder-Gabryl
--  EMAIL:           pycoder.gabryl@gmail.com
--  LICENSE:         Apache 2.0
--  ----------------------------------------------------------------------------
--  DESCRIPTION:      Specyfikacja atomowych kontrolek wyboru dla Raylib.
--                    Zarządza polami zaznaczenia (Checkbox), karuzelami cyklicznymi
--                    oraz generyczną i zunifikowaną grupą przycisków radiowych.
--  ----------------------------------------------------------------------------
--  PATH:            src/drivers/graphical/raylib/widgets/gabyx-drivers-raylib-widgets-selectors.ads
--  CREATED:         2026-08-29
--  ============================================================================


with Raylib;

package Gabyx.Drivers.Raylib.Widgets.Selectors is

   --  ============================================================================
   --  TYPY POMOCNICZE
   --  ============================================================================

   type String_Array is array (Positive range <>) of access constant String;

   --  ============================================================================
   --  PUBLICZNY INTERFEJS KONTROLEK WYBORU
   --  ============================================================================

   --  Rysuje pole wyboru Checkbox [X]
   procedure Draw_Checkbox
     (X, Y       : Integer;
      Label      : String;
      Checked    : in out Boolean;
      Font       : Standard.Raylib.Font;
      Font_Size  : Float;
      Changed    : out Boolean);

   --  Rysuje selektor cykliczny [ ◀ ] Wartość [ ▶ ]
   procedure Draw_Cycle_Selector
     (X, Y, W       : Integer;
      Label         : String;
      Value_Text    : String;
      Font          : Standard.Raylib.Font;
      Font_Size     : Float;
      Prev_Clicked  : out Boolean;
      Next_Clicked  : out Boolean);

   --  Zunifikowany, generyczny renderer dowolnej grupy przycisków radiowych
   procedure Draw_Radio_Group
     (X, Y, W      : Integer;
      Labels       : String_Array;
      Selected     : in out Positive;
      Font         : Standard.Raylib.Font;
      Font_Size    : Float;
      Changed      : out Boolean);

   --  Wygodne wrappery zachowujące kompatybilność wsteczną
   procedure Draw_Radio_3
     (X, Y, W          : Integer;
      Opt1, Opt2, Opt3 : String;
      Selected         : in out Positive;
      Font             : Standard.Raylib.Font;
      Font_Size        : Float;
      Changed          : out Boolean);

   procedure Draw_Radio_4
     (X, Y, W                : Integer;
      Opt1, Opt2, Opt3, Opt4 : String;
      Selected               : in out Positive;
      Font                   : Standard.Raylib.Font;
      Font_Size              : Float;
      Changed                : out Boolean);

end Gabyx.Drivers.Raylib.Widgets.Selectors;
