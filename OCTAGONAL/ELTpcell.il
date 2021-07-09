 /* ELTpcell.il

Author          Guilherme Trindade
Group           INESC-ID - Analog and Mixed-Signal Circuits (CAM)
language        SKILL
Revision No.    1.0
Date Created    Fev 25, 2020
Modified         
By:

************************
lIBRARY = "UMC130"
CEll    = "ELTpcell"
************************

*/

load("./SKILL/OCTAGONAL/pcellUtils.il")


/*
 Sum numbers in a vector.
 
 This sum is the arithmetic sum, not some other kind of sum that only
 mathematicians have heard of.
 
 @param values Container whose values are summed.
 @return sum of `values`, or 0.0 if `values` is empty.
 */

procedure(getTechInfo(cvId)
  let( (pcTechFile)
    pcTechFile = techGetTechFile(cvId)
    
    ;PO1_minWidth = techGetSpacingRule(pcTechFile "minWidth" "PO1")
    ME1_minSpacing = techGetSpacingRule(pcTechFile "minSpacing" "ME1")
    ME2_minSpacing = techGetSpacingRule(pcTechFile "minSpacing" "ME2")
    CT_minSpacing = techGetSpacingRule(pcTechFile "minSpacing" "CONT")
    CT_Size = techGetSpacingRule(pcTechFile "minWidth" "CONT")
    VI1_minSpacing = techGetSpacingRule(pcTechFile "minSpacing" "VI1")
    PO1CT_minSpacing = techGetSpacingRule(pcTechFile "minSpacing" list("CONT" "drawing") list("PO1" "drawing"))
    VI1_Size = techGetSpacingRule(pcTechFile "minWidth" "VI1")
    grid = techGetMfgGridResolution(pcTechFile)

    CTDIFF_minSpacing = 0.06         ;; 24F - Mininum N+ DIFFUSION enclosure of N+ DIFFUSION CONTACT
    PO1CT_enclosure = 0.06           ;; 24E - Minimum POLY1 enclosure of CONTACT
    DIFFNPLUS_minSpacing = 0.16      ;; 21C - Minimum N+ implant overlap DIFFUSION to form N+ region - 0.18
    DIFFPPLUS_Spacing = 0.16
    PO1DIFF_minSpacing = 0.18        ;; 19E - Minimum POLY1 overhang of DIFFUSION (end cap) 
    VI1_minSpacing_3x3 = 0.28        ;; 2B - Minimum MVIA1 to MVIA1 spacing - 0.20, in MVIA1 array with size >= 3x3 - 0.28
    VI1ME1_minSpacing = 0.06         ;; 2C - Minimum METAL1 line end enclosure of MVIA1 when METAL1 width < 0.24 um
    NWELL_PPLUS_Spacing = 0.1
    NPLUSPPLUS_Spacing = PO1DIFF_minSpacing-DIFFNPLUS_minSpacing+VI1_Size+2*VI1ME1_minSpacing

    CT_diagonal = round(sqrt(2*0.16*0.16)*1000000.0)/1000000.0 ;0.226274
    VI1_diagonal = round(sqrt(2*0.20*0.20)*1000000.0)/1000000.0 ;0.282843

    VI1_minDiagonal = 0.205061
    CT_minDiagonal = 0.205061
  )
)

/*
 Sum numbers in a vector.
 
 This sum is the arithmetic sum, not some other kind of sum that only
 mathematicians have heard of.
 
 @param values Container whose values are summed.
 @return sum of `values`, or 0.0 if `values` is empty.
 */

procedure(createPolygon(cv pin layer type dint cl sw l d)
  let((x y pinFig square_sides xPO1DIFF_Spacing)
    x = 0 
    y = 0

    if( layer == "DIFF" then
      xPO1DIFF_Spacing = 0.24
      dbCreatePolygon(cv list(layer type) list((x-d-xPO1DIFF_Spacing:y+l+sw) (x+dint+d+xPO1DIFF_Spacing:y+l+sw) (x+dint+l+cl+sw:y-cl+d+xPO1DIFF_Spacing) (x+dint+l+cl+sw:y-dint-cl-d-xPO1DIFF_Spacing) (x+dint+d+xPO1DIFF_Spacing:y-dint-2*cl-l-sw) (x-d-xPO1DIFF_Spacing:y-dint-2*cl-l-sw) (x-cl-l-sw:y-dint-cl-d-xPO1DIFF_Spacing) (x-cl-l-sw:y-cl+d+xPO1DIFF_Spacing)))
    )
    if( pin == "D" then
      pinFig = dbCreatePolygon(cv list(layer type) list((x+dint-0.15:y-sw) (x+dint+cl-sw:y-cl-0.15) (x+dint+cl-sw:y-cl-dint+0.15) (x+dint-0.15:y-dint-2*cl+sw) (x+0.15:y-dint-2*cl+sw) (x-cl+sw:y-dint-cl+0.15) (x-cl+sw:y-cl-0.15) 
      (x+0.15:y-sw) (x+dint-0.15:y-sw) (x+dint-0.15:y) (x:y) (x-cl:y-cl) (x-cl:y-cl-dint) (x:y-2*cl-dint) (x+dint:y-2*cl-dint) (x+dint:y-2*cl-dint) (x+dint+cl:y-dint-cl) (x+dint+cl:y-cl) (x+dint:y) (x+dint-0.15:y)))
    )
    if( layer == "PO1" || layer == "SDSYM" then
      dbCreatePolygon(cv list(layer type) list((x-d:y+l) (x:y+l) (x:y) (x-cl:y-cl) (x-cl:y-dint-cl) (x:y-dint-2*cl) (x+dint:y-dint-2*cl) (x+dint+cl:y-dint-cl) (x+dint+cl:y-cl) 
      (x+dint:y) (x:y) (x:y+l) (x+dint+d:y+l) (x+dint+cl+l:y-cl+d) (x+dint+cl+l:y-dint-cl-d) (x+dint+d:y-dint-2*cl-l) (x-d:y-dint-2*cl-l) (x-cl-l:y-dint-cl-d) (x-cl-l:y-cl+d))) 
    )
    if( pin == "GC" then
      square_sides = 0.1
      dbCreatePolygon(cv list("PO1" "PO_LVS") list((x-d+0.005:y+l+sw) (x-d+0.16:y+l+sw) (x-d+0.16:y+l+square_sides) (x-d+0.16+square_sides:y+l) (x-d+0.005:y+l)))
      dbCreatePolygon(cv list(layer type) list((x-d:y+l+sw+PO1DIFF_minSpacing) (x-d+0.16:y+l+sw+PO1DIFF_minSpacing) (x+0.16-d:y+l+square_sides) (x-d+0.16+square_sides:y+l) (x-d:y+l))) 
      ;gatePinWidth = snapGrid((2*VI1ME1_minSpacing+VI1_minSpacing_3x3+2*VI1_Size) grid)  

      ;(-0.235 1.49) (0.4 1.49) (0.4 1.05) (0.5 0.95) (-0.235 0.95) 

      ;if( l > 0.64 then
      ;  dbCreatePolygon(cv list("PO1" "PO_LVS") list((x:y) ))
      ;)
    )
    if( pin == "S" then
      xPO1DIFF_Spacing = 0.24
      dbCreatePolygon(cv list(layer type) list((x+dint+d:y+l) (x+dint+cl+l:y-cl+d) (x+dint+cl+l:y-dint-cl-d) (x+dint+d:y-dint-2*cl-l) (x-d:y-dint-2*cl-l) (x-cl-l:y-dint-cl-d) (x-cl-l:y-dint-cl-d) 
      (x-cl-l:y-cl+d) (x-d:y+l) (x-d:y+l+sw) (x-d-xPO1DIFF_Spacing:y+l+sw) (x-cl-l-sw:y-cl+d+xPO1DIFF_Spacing) (x-cl-l-sw:y-dint-cl-d-xPO1DIFF_Spacing) (x-d-xPO1DIFF_Spacing:y-dint-l-2*cl-sw) (x+dint+d+xPO1DIFF_Spacing:y-dint-l-2*cl-sw) (x+dint+l+cl+sw:y-dint-cl-d-xPO1DIFF_Spacing) 
      (x+dint+l+cl+sw:y-cl+d+xPO1DIFF_Spacing) (x+dint+d+xPO1DIFF_Spacing:y+l+sw) (x-d:y+l+sw) (x-d:y+l)))

      pinFig = dbCreatePolygon(cv list(layer type) list((x+dint+d:y+l) (x+dint+cl+l:y-cl+d) (x+dint+cl+l:y-dint-cl-d) (x+dint+d:y-dint-2*cl-l) (x-d:y-dint-2*cl-l) (x-cl-l:y-dint-cl-d) (x-cl-l:y-dint-cl-d) 
      (x-cl-l:y-cl+d) (x-d:y+l) (x-d:y+l+sw) (x-d-xPO1DIFF_Spacing:y+l+sw) (x-cl-l-sw:y-cl+d+xPO1DIFF_Spacing) (x-cl-l-sw:y-dint-cl-d-xPO1DIFF_Spacing) (x-d-xPO1DIFF_Spacing:y-dint-l-2*cl-sw) (x+dint+d+xPO1DIFF_Spacing:y-dint-l-2*cl-sw) (x+dint+l+cl+sw:y-dint-cl-d-xPO1DIFF_Spacing) 
      (x+dint+l+cl+sw:y-cl+d+xPO1DIFF_Spacing) (x+dint+d+xPO1DIFF_Spacing:y+l+sw) (x-d:y+l+sw) (x-d:y+l)))
    )
    if( layer == "SYMBOL" then
      xPO1DIFF_Spacing = 0.24
      pinFig = dbCreatePolygon(cv list(layer type) list((x-d-xPO1DIFF_Spacing:y+l+sw) (x+dint+d+xPO1DIFF_Spacing:y+l+sw) (x+dint+l+cl+sw:y-cl+d+xPO1DIFF_Spacing) (x+dint+l+cl+sw:y-dint-cl-d-xPO1DIFF_Spacing) (x+dint+d+xPO1DIFF_Spacing:y-dint-2*cl-l-sw) (x-d-xPO1DIFF_Spacing:y-dint-2*cl-l-sw) (x-cl-l-sw:y-dint-cl-d-xPO1DIFF_Spacing) (x-cl-l-sw:y-cl+d+xPO1DIFF_Spacing)))
    )
    list(pinFig)
  )
)

/*
 Sum numbers in a vector.
 
 This sum is the arithmetic sum, not some other kind of sum that only
 mathematicians have heard of.
 
 @param values Container whose values are summed.
 @return sum of `values`, or 0.0 if `values` is empty.
 */

procedure(createRect(cv layer type dint cl sw l d)
  let((pinFig gatePinWidth)
    if( layer == "NPLUS" || layer == "PPLUS" then
      dbCreateRect(cv list(layer type) list((x-cl-l-sw-DIFFNPLUS_minSpacing:y+l+sw+PO1DIFF_minSpacing+VI1_Size+2*VI1ME1_minSpacing) 
      (x+dint+cl+l+sw+DIFFNPLUS_minSpacing:y-dint-2*cl-l-sw-DIFFNPLUS_minSpacing))) 
    else
      gatePinWidth = snapGrid((2*VI1ME1_minSpacing+VI1_minSpacing_3x3+2*VI1_Size) grid)  
      pinFig = dbCreateRect(cv list(layer type) list((snapGrid((x-d-((gatePinWidth-0.16)/2)) grid):y+l+sw+PO1DIFF_minSpacing) (snapGrid((x-d+0.16+((gatePinWidth-0.16)/2)) grid):y+l+sw+PO1DIFF_minSpacing+(VI1_Size+2*VI1ME1_minSpacing)))) 
    )
    list(pinFig)
  )
)

/*
 Sum numbers in a vector.
 
 This sum is the arithmetic sum, not some other kind of sum that only
 mathematicians have heard of.
 
 @param values Container whose values are summed.
 @return sum of `values`, or 0.0 if `values` is empty.
 */

procedure(createPin(cv pin direction pinFig)
  let((G D S B)
    if( pin == "G" then
      G = dbCreateNet(cv pin)
      dbCreateTerm(G "" direction)
      dbCreatePin(G pinFig "Gate")
    )
    if( pin == "D" then
      D = dbCreateNet(cv pin)
      dbCreateTerm(D "" direction)
      dbCreatePin(D pinFig "Drain")    
    )
    if( pin == "S" then
      S = dbCreateNet(cv pin)
      dbCreateTerm(S "" direction)
      dbCreatePin(S pinFig "Source")        
    )
    if( pin == "B" then
      B = dbCreateNet(cv pin)
      dbCreateTerm(B "" direction)
      dbCreatePin(B pinFig "Bulk")
    )
  )
)

/*
 Sum numbers in a vector.
 
 This sum is the arithmetic sum, not some other kind of sum that only
 mathematicians have heard of.
 
 @param values Container whose values are summed.
 @return sum of `values`, or 0.0 if `values` is empty.
 */

procedure(createLayout(cv model l dint d sw)
  let((x y mosType alfa pinFigG pinFigD pinFigS pinFigB)
    x = 0
    y = 0

    if(model == "n_12_hsl130e" then
      mosType = "n"
    )
    if(model == "p_12_hsl130e" then
      mosType = "p"
    )

    ;; Convert string to float and multiply for a 
    ;; factor of mega(1e6) to get the value in meters
    l = cdfParseFloatString(l)*1e6
    dint = cdfParseFloatString(dint)*1e6
    d = cdfParseFloatString(d)*1e6
    sw = cdfParseFloatString(sw)*1e6

    cl = snapGrid(sqrt((dint*dint)/2) grid)

    ;alfa = (22.5/180)*3.14
    ;d = tan(alfa)*l
    ;d = snapGrid((round(d*1000.0)/1000.0) grid)

    createPolygon(cv "DIFF" "DIFF" "drawing" dint cl sw l d)

    createPolygon(cv "D" "ME1" "drawing" dint cl sw l d)
    createPolygon(cv "D" "ME2" "drawing" dint cl sw l d)
    pinFigD = car(createPolygon(cv "D" "ME3" "drawing" dint cl sw l d))

    createPin(cv "D" "input" pinFigD)

    ;; Creation of enclosed gate in PO1.
    createPolygon(cv "GC" "PO1" "drawing" dint cl sw l d)
    ;createPolygon(cv "GC" "SDSYM" "drawing" dint cl sw l d)

    dbCreatePolygon(cv list("SDSYM" "drawing") list((x-d:y+l) (x:y+l) (x:y) (x-cl:y-cl) (x-cl:y-dint-cl) (x:y-dint-2*cl) (x+dint:y-dint-2*cl) (x+dint+cl:y-dint-cl) (x+dint+cl:y-cl) 
    (x+dint:y) (x:y) (x:y+l) (x+dint+d:y+l) (x+dint+cl+l:y-cl+d) (x+dint+cl+l:y-dint-cl-d) (x+dint+d:y-dint-2*cl-l) (x-d:y-dint-2*cl-l) (x-cl-l:y-dint-cl-d) (x-cl-l:y-cl+d))) 

    pinFigG = car(createRect(cv "ME1" "drawing" dint cl sw l d))

    createPin(cv "G" "input" pinFigG)

    ;; Creation of gate contact M1 to POLY
    designGateContacts(cv x y l sw "M1_POLY")

    ;; Creation of gate contact M2 to M1
    designGateContacts(cv x y l sw "M2_M1")
    
    createPolygon(cv "S" "ME1" "drawing" dint cl sw l d)
    pinFigS = car(createPolygon(cv "S" "ME2" "drawing" dint cl sw l d))

    createPin(cv "S" "inputOutput" pinFigS)

    if(mosType == "n" then
      ;; Creation of NPLUS
      createRect(cv "NPLUS" "drawing" dint cl sw l d)

      ;; Design Bulk
      pinFigB = car(createPolygon(cv "" "SYMBOL" "WELLBODY" dint cl sw l d))

      createPin(cv "B" "input" pinFigB)
    else
      ;; Creation of PPLUS 
      createRect(cv "PPLUS" "drawing" dint cl sw l d)
    )

    ;; Design drain contacts
    designDrainContacts(cv x y dint cl "CONT")

    ;; Design diagonal drain contacts
    designDrainContactsDiagonal(cv x y dint cl "CONT")

    ;; Design drain M2_M1 Vias
    if( l <= 0.485 then
      designDrainVias(cv dint cl x y "VI1") 
    )

    ;; Design diagonal drain M2_M1 Vias
    designDrainViasDiagonal(cv dint cl x y "VI1")

    ;; Design drain M3_M2 Vias
    designDrainVias(cv dint cl x y "VI2") 

    ;; Design diagonal drain M2_M1 Vias
    designDrainViasDiagonal(cv dint cl x y "VI2")

    ;; Design source contacts
    designSourceContacts(cv l dint d cl x y "CONT")

    ;; Design diagonal source contacts
    designSourceContactsDiagonal(cv l dint d cl x y "CONT")
    
    ;; Design source M2_M1 Vias
    designSourceVias(cv l dint d sw x y "VI1")
    
    ;; Design diagonal source M2_M1 Vias
    designSourceViasDiagonal(cv l cl dint d x y "VI1")

    ;; Creation of labels
    ;designLabels(x y cv "TEXT" l dint cl sw) 

    ;; Creation of Guard Ring    
    NPLUS_Length = dint+2*cl+2*l+2*sw+2*DIFFNPLUS_minSpacing 
    NPLUS_Height = dint+2*cl+2*l+2*sw+DIFFNPLUS_minSpacing+PO1DIFF_minSpacing+VI1_Size+2*VI1ME1_minSpacing

    x = x-cl-l-sw-DIFFNPLUS_minSpacing
    y = y+l+sw+PO1DIFF_minSpacing+VI1_Size+2*VI1ME1_minSpacing

    CreateGR(cv x y NPLUS_Length NPLUS_Height mosType)

    /*xPO1DIFF_Spacing = 0.24
    dbCreatePolygon(cv list("NPLUS" "drawing") list((x-d-xPO1DIFF_Spacing-DIFFNPLUS_minSpacing:y+l+sw+DIFFNPLUS_minSpacing) (x+dint+d+xPO1DIFF_Spacing+DIFFNPLUS_minSpacing:y+l+sw+DIFFNPLUS_minSpacing) 
    (x+dint+cl+l+sw+DIFFNPLUS_minSpacing:y-cl+d+xPO1DIFF_Spacing+DIFFNPLUS_minSpacing) (x+dint+cl+l+sw+DIFFNPLUS_minSpacing:y-cl-dint-d-xPO1DIFF_Spacing-DIFFNPLUS_minSpacing) 
    (x+dint+d+xPO1DIFF_Spacing+DIFFNPLUS_minSpacing:y-2*cl-dint-l-sw-DIFFNPLUS_minSpacing) (x-d-xPO1DIFF_Spacing-DIFFNPLUS_minSpacing:y-2*cl-dint-l-sw-DIFFNPLUS_minSpacing) 
    (x-cl-l-sw-DIFFNPLUS_minSpacing:y-cl-dint-d-xPO1DIFF_Spacing-DIFFNPLUS_minSpacing) (x-cl-l-sw-DIFFNPLUS_minSpacing:y-cl+d+xPO1DIFF_Spacing+DIFFNPLUS_minSpacing)))


    PPLUS_Length = dint+2*d+2*xPO1DIFF_Spacing+2*DIFFNPLUS_minSpacing+2*NPLUSPPLUS_Spacing
    DIFF_Length = dint+2*d+2*xPO1DIFF_Spacing+2*DIFFNPLUS_minSpacing+2*NPLUSPPLUS_Spacing+2*DIFFPPLUS_Spacing
    GR_Diagonal_sides = (x+dint+cl+l+sw)-(x+dint+d+xPO1DIFF_Spacing)
    diagonalSize = sqrt(2*(GR_Diagonal_sides*GR_Diagonal_sides))

    x = x-d-xPO1DIFF_Spacing-DIFFNPLUS_minSpacing-NPLUSPPLUS_Spacing
    y = y+l+sw+DIFFNPLUS_minSpacing+NPLUSPPLUS_Spacing

    CreateGR_V2(cv x y PPLUS_Length DIFF_Length mosType GR_Diagonal_sides)
    designGRContacts_V2(cv x y DIFF_Length)
    designGRContactsDiagonal_V2(cv x y diagonalSize dint cl sw d xPO1DIFF_Spacing DIFFNPLUS_minSpacing DIFFPPLUS_Spacing NPLUSPPLUS_Spacing)*/
  )
)

/*
 Sum numbers in a vector.
 
 This sum is the arithmetic sum, not some other kind of sum that only
 mathematicians have heard of.
 
 @param values Container whose values are summed.
 @return sum of `values`, or 0.0 if `values` is empty.
 */

procedure(ELTdefinePC(libName cellName)
  if(cellName == "N_12_HSL130E" then
    pcDefinePCell(
      list(ddGetObj(libName) cellName "layout")
      (
        (model "string" "n_12_hsl130e")
        (w "string" "6u")
        (l "string" "0.30u")
        (dint "string" "0.75u")
        (cl "string" "0.53u")
        (d "string" "0.125u")
        (sw "string" "0.36u")
      )
      let( ((cv pcCellView)) 
        getTechInfo(cv)
        createLayout(cv model l dint d sw)
      )  
    )
  )
  if(cellName == "P_12_HSL130E" then
    pcDefinePCell(
      list(ddGetObj(libName) cellName "layout")
      (
        (model "string" "p_12_hsl130e")
        (w "string" "6u")
        (l "string" "0.30u")
        (dint "string" "0.75u")
        (cl "string" "0.53u")
        (d "string" "0.125u")
        (sw "string" "0.36u")
      )
      let( ((cv pcCellView)) 
        getTechInfo(cv)
        createLayout(cv model l dint d sw)
      )  
    )
  )
)
