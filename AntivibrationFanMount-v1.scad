// Antivibration Fan Mount
//   TPU Flexible mount
//   Vibration transfer greatly reduced between fan and base/frame
//   Mount with screws to base
//   Mount fan into sleeve with friction/tension
//   No direct hard contact between fan and base
//   This does not address sound transmission directly via air
//     Possibly in a later muffler design

// Print Notes:
//   TPU
//   0.4mm Nozzle, 0.2mm Height, First Layer Width 0.5mm
//   Infill 25% Cubic
//   Lines: 1 Perimeter
//   Full Layers: 2 Bottom, 5 Top

// Prerequisite:
//   BOSL2 https://github.com/BelfrySCAD
include <BOSL2/std.scad>


/* [Fan Dimensions] */
// Base Diameter is the end that is attached to the printer.  Default settings are for 4010 axial fan.
FanWidth           = 40; // [0:0.1:50]
// For 4010 fan, 11 to add a bit of tolerance required when tested
FanDepth           = 11; // [0:0.1:50]
FanRadiusTrim      = 1; // [0:0.1:10]
SideThickness      = 1; // [0:0.1:10]
BaseThickness      = 10; // [0:1:30]
OuterChamfer       = 0.5; // [0:0.1:10]
// Clip is a protruding edge that holds the fan in the mount.  This avoid screws touching the fan and the base directly, which avoid vibration transfers.  2mm is alot to insert, but TPU can be stretched.  If too tight, reduce to 1mm.
ClipProtrude       = 2; // [1:0.1:10]

/* [Screws] */
// M3 is exactly 3mm, make larger to be looser.  Default settings are for 4010 axial fan.
ScrewDiameter      = 3.2; // [1:0.1:10]
ScrewHeadDiameter  = 6.2; // [1:0.1:10]
ScrewBaseThickness = 2; // [1:1:10]
ScrewSpacing       = 32; // [1:1:50]

/* [Finalization] */
Smooth = true;
FragmentsSmooth = 100; // 5:1:1000
FragmentsRegular = 10; // 5:1:1000
fnCalc = Smooth ? FragmentsSmooth : FragmentsRegular;
$fn = fnCalc;

// Prep Calculations
SideThicknessDouble = SideThickness * 2;
FanWidthHalf = FanWidth / 2;
ClipProtrudeHalf = ClipProtrude / 2;

BodyWidth = FanWidth + SideThicknessDouble;
// Fan cutout depth half of clip protrude to have it wedge and protrude.
FanCutoutDepth = FanDepth + ClipProtrudeHalf;
BodyDepth = FanCutoutDepth + BaseThickness;
ScrewCutoutDepth = BaseThickness;
FanCutoutRadius = FanWidthHalf - FanRadiusTrim;

module Body(){
  cuboid(
    [BodyWidth, BodyWidth, BodyDepth],
    chamfer=OuterChamfer,
    edges="Z",
    anchor=BOT
  );
}
//Body();

module FanBoxCutout(){
  up(BaseThickness){
    cuboid(
      [FanWidth, FanWidth, FanCutoutDepth],
      chamfer=ClipProtrude,
      edges=TOP,
      anchor=BOT
    );
  }
}
//FanBoxCutout();

module FanHoleCutout(){
  cyl(
    r=FanCutoutRadius,
    l=BaseThickness,
    anchor=BOT
  );
}
//FanHoleCutout();

module ScrewCutout(){
  // Screw Cutout
  cyl(
    d=ScrewDiameter,
    l=ScrewCutoutDepth,
    anchor=BOT
  );
  // Head Cutout
  up(ScrewBaseThickness){
    cyl(
      d=ScrewHeadDiameter,
      l=ScrewCutoutDepth,
      anchor=BOT
    );
  }
}

module ScrewCutouts(){
  ycopies(
    n=2,
    spacing=ScrewSpacing
  ){
    xcopies(
      n=2,
      spacing=ScrewSpacing
    ){
      ScrewCutout();
    }
  }
}

module Mount(){
  difference(){
    Body();
    ScrewCutouts();
    FanBoxCutout();
    FanHoleCutout();
  }
}

Mount();

