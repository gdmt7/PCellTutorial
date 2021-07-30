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

procedure(getTechInfo(cvId)
  let( (pcTechFile)
    pcTechFile = techGetTechFile(cvId)
    
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

procedure(createPolygon(cv pin layer type d sl l dl)
  let((x y pinFig square_sides xPO1DIFF_Spacing)
    x = 0 
    y = 0
    cl = snapGrid(sqrt(d*d/2) grid)

    if( layer == "DIFF" then
      xPO1DIFF_Spacing = 0.24
      dbCreatePolygon(cv list(layer type) list((x-dl-xPO1DIFF_Spacing:y+l+sl) (x+d+dl+xPO1DIFF_Spacing:y+l+sl) (x+d+l+cl+sl:y-cl+dl+xPO1DIFF_Spacing) (x+d+l+cl+sl:y-d-cl-dl-xPO1DIFF_Spacing) (x+d+dl+xPO1DIFF_Spacing:y-d-2*cl-l-sl) (x-dl-xPO1DIFF_Spacing:y-d-2*cl-l-sl) (x-cl-l-sl:y-d-cl-dl-xPO1DIFF_Spacing) (x-cl-l-sl:y-cl+dl+xPO1DIFF_Spacing)))
    )
    if( pin == "D" then
      pinFig = dbCreatePolygon(cv list(layer type) list((x+d-0.15:y-sl) (x+d+cl-sl:y-cl-0.15) (x+d+cl-sl:y-cl-d+0.15) (x+d-0.15:y-d-2*cl+sl) (x+0.15:y-d-2*cl+sl) (x-cl+sl:y-d-cl+0.15) (x-cl+sl:y-cl-0.15) 
      (x+0.15:y-sl) (x+d-0.15:y-sl) (x+d-0.15:y) (x:y) (x-cl:y-cl) (x-cl:y-cl-d) (x:y-2*cl-d) (x+d:y-2*cl-d) (x+d:y-2*cl-d) (x+d+cl:y-d-cl) (x+d+cl:y-cl) (x+d:y) (x+d-0.15:y)))
    )
    if( layer == "PO1" || layer == "SDSYM" then
      dbCreatePolygon(cv list(layer type) list((x-dl:y+l) (x:y+l) (x:y) (x-cl:y-cl) (x-cl:y-d-cl) (x:y-d-2*cl) (x+d:y-d-2*cl) (x+d+cl:y-d-cl) (x+d+cl:y-cl) 
      (x+d:y) (x:y) (x:y+l) (x+d+dl:y+l) (x+d+cl+l:y-cl+dl) (x+d+cl+l:y-d-cl-dl) (x+d+dl:y-d-2*cl-l) (x-dl:y-d-2*cl-l) (x-cl-l:y-d-cl-dl) (x-cl-l:y-cl+dl))) 
    )
    if( pin == "GC" then
      square_sides = 0.1
      dbCreatePolygon(cv list("PO1" "PO_LVS") list((x-dl+0.005:y+l+sl) (x-dl+0.16:y+l+sl) (x-dl+0.16:y+l+square_sides) (x-dl+0.16+square_sides:y+l) (x-dl+0.005:y+l)))
      dbCreatePolygon(cv list(layer type) list((x-dl:y+l+sl+PO1DIFF_minSpacing) (x-dl+0.16:y+l+sl+PO1DIFF_minSpacing) (x+0.16-dl:y+l+square_sides) (x-dl+0.16+square_sides:y+l) (x-dl:y+l))) 
    )
    if( pin == "S" then
      xPO1DIFF_Spacing = 0.24
      dbCreatePolygon(cv list(layer type) list((x+d+dl:y+l) (x+d+cl+l:y-cl+dl) (x+d+cl+l:y-d-cl-dl) (x+d+dl:y-d-2*cl-l) (x-dl:y-d-2*cl-l) (x-cl-l:y-d-cl-dl) (x-cl-l:y-d-cl-dl) 
      (x-cl-l:y-cl+dl) (x-dl:y+l) (x-dl:y+l+sl) (x-dl-xPO1DIFF_Spacing:y+l+sl) (x-cl-l-sl:y-cl+dl+xPO1DIFF_Spacing) (x-cl-l-sl:y-d-cl-dl-xPO1DIFF_Spacing) (x-dl-xPO1DIFF_Spacing:y-d-l-2*cl-sl) (x+d+dl+xPO1DIFF_Spacing:y-d-l-2*cl-sl) (x+d+l+cl+sl:y-d-cl-dl-xPO1DIFF_Spacing) 
      (x+d+l+cl+sl:y-cl+dl+xPO1DIFF_Spacing) (x+d+dl+xPO1DIFF_Spacing:y+l+sl) (x-dl:y+l+sl) (x-dl:y+l)))

      pinFig = dbCreatePolygon(cv list(layer type) list((x+d+dl:y+l) (x+d+cl+l:y-cl+dl) (x+d+cl+l:y-d-cl-dl) (x+d+dl:y-d-2*cl-l) (x-dl:y-d-2*cl-l) (x-cl-l:y-d-cl-dl) (x-cl-l:y-d-cl-dl) 
      (x-cl-l:y-cl+dl) (x-dl:y+l) (x-dl:y+l+sl) (x-dl-xPO1DIFF_Spacing:y+l+sl) (x-cl-l-sl:y-cl+dl+xPO1DIFF_Spacing) (x-cl-l-sl:y-d-cl-dl-xPO1DIFF_Spacing) (x-dl-xPO1DIFF_Spacing:y-d-l-2*cl-sl) (x+d+dl+xPO1DIFF_Spacing:y-d-l-2*cl-sl) (x+d+l+cl+sl:y-d-cl-dl-xPO1DIFF_Spacing) 
      (x+d+l+cl+sl:y-cl+dl+xPO1DIFF_Spacing) (x+d+dl+xPO1DIFF_Spacing:y+l+sl) (x-dl:y+l+sl) (x-dl:y+l)))
    )
    if( layer == "SYMBOL" then
      xPO1DIFF_Spacing = 0.24
      pinFig = dbCreatePolygon(cv list(layer type) list((x-dl-xPO1DIFF_Spacing:y+l+sl) (x+d+dl+xPO1DIFF_Spacing:y+l+sl) (x+d+l+cl+sl:y-cl+dl+xPO1DIFF_Spacing) (x+d+l+cl+sl:y-d-cl-dl-xPO1DIFF_Spacing) (x+d+dl+xPO1DIFF_Spacing:y-d-2*cl-l-sl) (x-dl-xPO1DIFF_Spacing:y-d-2*cl-l-sl) (x-cl-l-sl:y-d-cl-dl-xPO1DIFF_Spacing) (x-cl-l-sl:y-cl+dl+xPO1DIFF_Spacing)))
    )
    list(pinFig)
  )
)

procedure(createRect(cv layer type d cl sl l dl)
  let((pinFig gatePinWidth)
    if( layer == "NPLUS" || layer == "PPLUS" then
      dbCreateRect(cv list(layer type) list((x-cl-l-sl-DIFFNPLUS_minSpacing:y+l+sl+PO1DIFF_minSpacing+VI1_Size+2*VI1ME1_minSpacing) 
      (x+d+cl+l+sl+DIFFNPLUS_minSpacing:y-d-2*cl-l-sl-DIFFNPLUS_minSpacing))) 
    else
      gatePinWidth = snapGrid((2*VI1ME1_minSpacing+VI1_minSpacing_3x3+2*VI1_Size) grid)  
      pinFig = dbCreateRect(cv list(layer type) list((snapGrid((x-dl-((gatePinWidth-0.16)/2)) grid):y+l+sl+PO1DIFF_minSpacing) (snapGrid((x-dl+0.16+((gatePinWidth-0.16)/2)) grid):y+l+sl+PO1DIFF_minSpacing+(VI1_Size+2*VI1ME1_minSpacing)))) 
    )
    list(pinFig)
  )
)

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

procedure(createLayout(cv model l d dl sl)
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
    d = cdfParseFloatString(d)*1e6
    dl = cdfParseFloatString(dl)*1e6
    sl = cdfParseFloatString(sl)*1e6

    cl = snapGrid(sqrt(d*d/2) grid)

    createPolygon(cv "DIFF" "DIFF" "drawing" d sl l dl)

    createPolygon(cv "D" "ME1" "drawing" d sl l dl)
    createPolygon(cv "D" "ME2" "drawing" d sl l dl)
    pinFigD = car(createPolygon(cv "D" "ME3" "drawing" d sl l dl))

    createPin(cv "D" "input" pinFigD)

    ;; Creation of enclosed gate in PO1.
    createPolygon(cv "GC" "PO1" "drawing" d sl l dl)

    dbCreatePolygon(cv list("SDSYM" "drawing") list((x-dl:y+l) (x:y+l) (x:y) (x-cl:y-cl) (x-cl:y-d-cl) (x:y-d-2*cl) (x+d:y-d-2*cl) (x+d+cl:y-d-cl) (x+d+cl:y-cl) 
    (x+d:y) (x:y) (x:y+l) (x+d+dl:y+l) (x+d+cl+l:y-cl+dl) (x+d+cl+l:y-d-cl-dl) (x+d+dl:y-d-2*cl-l) (x-dl:y-d-2*cl-l) (x-cl-l:y-d-cl-dl) (x-cl-l:y-cl+dl))) 

    pinFigG = car(createRect(cv "ME1" "drawing" d cl sl l dl))

    createPin(cv "G" "input" pinFigG)

    ;; Creation of gate contact M1 to POLY
    designGateContacts(cv x y l sl "M1_POLY")

    ;; Creation of gate contact M2 to M1
    designGateContacts(cv x y l sl "M2_M1")
    
    createPolygon(cv "S" "ME1" "drawing" d sl l dl)
    pinFigS = car(createPolygon(cv "S" "ME2" "drawing" d sl l dl))

    createPin(cv "S" "inputOutput" pinFigS)

    if(mosType == "n" then
      ;; Creation of NPLUS
      createRect(cv "NPLUS" "drawing" d cl sl l dl)

      ;; Design Bulk
      pinFigB = car(createPolygon(cv "" "SYMBOL" "WELLBODY" d sl l dl))

      createPin(cv "B" "input" pinFigB)
    else
      ;; Creation of PPLUS 
      createRect(cv "PPLUS" "drawing" d cl sl l dl)
    )

    ;; Design drain contacts
    designDrainContacts(cv x y d cl "CONT")

    ;; Design diagonal drain contacts
    designDrainContactsDiagonal(cv x y d cl "CONT")

    ;; Design drain M2_M1 Vias
    if( l <= 0.485 then
      designDrainVias(cv d cl x y "VI1") 
    )

    ;; Design diagonal drain M2_M1 Vias
    designDrainViasDiagonal(cv d cl x y "VI1")

    ;; Design drain M3_M2 Vias
    designDrainVias(cv d cl x y "VI2") 

    ;; Design diagonal drain M2_M1 Vias
    designDrainViasDiagonal(cv d cl x y "VI2")

    ;; Design source contacts
    designSourceContacts(cv l d dl cl x y "CONT")

    ;; Design diagonal source contacts
    designSourceContactsDiagonal(cv l d dl cl x y "CONT")
    
    ;; Design source M2_M1 Vias
    designSourceVias(cv l d dl sl x y "VI1")
    
    ;; Design diagonal source M2_M1 Vias
    designSourceViasDiagonal(cv l cl d dl x y "VI1")

    ;; Creation of labels
    ;designLabels(x y cv "TEXT" l d cl sl) 

    ;; Creation of Guard Ring    
    NPLUS_Length = d+2*cl+2*l+2*sl+2*DIFFNPLUS_minSpacing 
    NPLUS_Height = d+2*cl+2*l+2*sl+DIFFNPLUS_minSpacing+PO1DIFF_minSpacing+VI1_Size+2*VI1ME1_minSpacing

    x = x-cl-l-sl-DIFFNPLUS_minSpacing
    y = y+l+sl+PO1DIFF_minSpacing+VI1_Size+2*VI1ME1_minSpacing

    CreateGR(cv x y NPLUS_Length NPLUS_Height mosType)
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
        (l "string" "0.2u")
        (d "string" "1.12u")
        (dl "string" "0.085u")
        (sl "string" "0.36u")
      )
      let( ((cv pcCellView)) 
        getTechInfo(cv)
        createLayout(cv model l d dl sl)
      )  
    )
  )
  if(cellName == "P_12_HSL130E" then
    pcDefinePCell(
      list(ddGetObj(libName) cellName "layout")
      (
        (model "string" "p_12_hsl130e")
        (w "string" "6u")
        (l "string" "0.2u")
        (d "string" "1.12u")
        (dl "string" "0.085u")
        (sl "string" "0.36u")
      )
      let( ((cv pcCellView)) 
        getTechInfo(cv)
        createLayout(cv model l d dl sl)
      )  
    )
  )
)
