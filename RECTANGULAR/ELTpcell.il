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

load("./SKILL/RECTANGULAR/pcellUtils.il")

procedure(GetTechInfo(cvId)
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

    PO1DIFF_overhang = 0.18
    CTDIFF_minSpacing = 0.06         ;; 24F - Mininum N+ DIFFUSION enclosure of N+ DIFFUSION CONTACT
    PO1CT_enclosure = 0.06           ;; 24E - Minimum POLY1 enhosure of CONTACT
    DIFFNPLUS_minOverlap = 0.16      ;; 21F - Minimum N+ implant overlap DIFFUSION to form N+ region
    DIFFPPLUS_Spacing = 0.16
    VI1_minSpacing_3x3 = 0.28        ;; 2B - Minimum MVIA1 to MVIA1 spacing - 0.20, in MVIA1 array with size >= 3x3 - 0.28
    VI1ME1_minEnclosure = 0.06         ;; 2C - Minimum METAL1 line end endlosure of MVIA1 when METAL1 width < 0.24 um
    NWELL_PPLUS_Spacing = 0.1
    NPLUSPPLUS_Spacing = PO1DIFF_overhang-DIFFPPLUS_Spacing+VI1_Size+2*VI1ME1_minEnclosure

    CT_diagonal = round(sqrt(2*0.16*0.16)*1000000.0)/1000000.0 ;0.226274
    VI1_diagonal = round(sqrt(2*0.20*0.20)*1000000.0)/1000000.0 ;0.282843

    VI1_minDiagonal = 0.205061
    CT_minDiagonal = 0.205061
  )
)

procedure(createPolygon(cv pin layer type l d h dl sl)
  let((x y pinFig square_sides)
    x = 0 
    y = 0

    if( layer == "DIFF" then
      ;dbCreatePolygon(cv list("DIFF" "drawing") list((x-h-l:y+l+sl) (x-h-l-sl:y+l) (x-h-l-sl:y-d-2*h-l) (x-h-l:y-d-2*h-l-sl) (x+d+h+l:y-d-2*h-l-sl) (x+d+h+l+sl:y-d-2*h-l) (x+d+h+l+sl:y+l) (x+d+h+l:y+l+sl)))

      dbCreatePolygon(cv list("DIFF" "drawing") list((x-dl-0.24:y+l+sl) (x-h-l-sl:y-h+dl+0.24) (x-h-l-sl:y-d-h-dl-0.24) (x-dl-0.24:y-d-2*h-l-sl) (x+d+dl+0.24:y-d-2*h-l-sl) (x+d+h+l+sl:y-d-h-dl-0.24) (x+d+h+l+sl:y-h+dl+0.24) (x+d+dl+0.24:y+l+sl)))
    )
    if( pin == "D" then
      pinFig = dbCreatePolygon(cv list(layer type) list((x:y) (x+d:y) (x+d+h:y-h) (x+d+h:y-h-d) (x+d:y-2*h-d) (x:y-2*h-d) (x-h:y-h-d) (x-h:y-h)))
      
      ;pinFig = dbCreatePolygon(cv list(layer type) list((x+d-0.15:y-sl) (x+d+h-sl:y-h-0.15) (x+d+h-sl:y-h-d+0.15) (x+d-0.15:y-d-2*h+sl) (x+0.15:y-d-2*h+sl) (x-h+sl:y-d-h+0.15) (x-h+sl:y-h-0.15) 
      ;(x+0.15:y-sl) (x+d-0.15:y-sl) (x+d-0.15:y) (x:y) (x-h:y-h) (x-h:y-h-d) (x:y-2*h-d) (x+d:y-2*h-d) (x+d:y-2*h-d) (x+d+h:y-d-h) (x+d+h:y-h) (x+d:y) (x+d-0.15:y)))
    )
    if( pin == "EG" then
      square_sides = 0.1

      dbCreatePolygon(cv list("PO1" "drawing") list((x:y+l) (x:y) (x+d:y) (x+d+h:y-h) (x+d+h:y-d-h) (x+d:y-d-2*h) (x:y-d-2*h) (x-h:y-d-h) (x-h:y-h) (x:y) (x:y+l) (x-dl:y+l) (x-h-l:y-h+dl) 
      (x-h-l:y-d-h-dl) (x-dl:y-d-2*h-l) (x+d+dl:y-d-2*h-l) (x+d+h+l:y-d-h-dl) (x+d+l+h:y-h+dl) (x+d+dl:y+l)))

      dbCreatePolygon(cv list("SDSYM" "drawing") list((x:y+l) (x:y) (x+d:y) (x+d+h:y-h) (x+d+h:y-d-h) (x+d:y-d-2*h) (x:y-d-2*h) (x-h:y-d-h) (x-h:y-h) (x:y) (x:y+l) (x-dl:y+l) (x-h-l:y-h+dl) 
      (x-h-l:y-d-h-dl) (x-dl:y-d-2*h-l) (x+d+dl:y-d-2*h-l) (x+d+h+l:y-d-h-dl) (x+d+l+h:y-h+dl) (x+d+dl:y+l)))

      dbCreatePolygon(cv list("PO1" "drawing") list((x-dl:y+l) (x-dl:y+l+sl+PO1DIFF_overhang) (x-dl+0.16:y+l+sl+PO1DIFF_overhang) (x-dl+0.16:y+l+square_sides) (x-dl+0.16+square_sides:y+l))) 

      dbCreatePolygon(cv list("PO1" "PO_LVS") list((x-dl+0.005:y+l+sl) (x-dl+0.16:y+l+sl) (x-dl+0.16:y+l+square_sides) (x-dl+0.16+square_sides:y+l) (x-dl+0.005:y+l)))

      dbCreatePolygon(cv list("SDSYM" "drawing") list((x-dl:y+l) (x-dl:y+l+sl+PO1DIFF_overhang) (x-dl+0.16:y+l+sl+PO1DIFF_overhang) (x-dl+0.16:y+l+square_sides) (x-dl+0.16+square_sides:y+l))) 
    )
    if( pin == "S" then
      ;pinFig = dbCreatePolygon(cv list(layer type) list((x-dl:y+l+sl) (x-dl:y+l) (x+d+dl:y+l) (x+d+h+l:y+dl-h) (x+d+h+l:y-d-h-dl) (x+d+dl:y-d-2*h-l) (x-dl:y-d-2*h-l) (x-l-h:y-d-h-dl) (x-l-h:y+dl-h) 
      ;(x-dl:y+l) (x-dl:y+l+sl) (x-l-h:y+l+sl) (x-l-sl-h:y+l) (x-l-sl-h:y-d-2*h-l) (x-l-h:y-d-2*h-l-sl) (x+d+h+l:y-d-2*h-l-sl) (x+d+h+l+sl:y-d-2*h-l) (x+d+h+l+sl:y+l) (x+d+h+l:y+l+sl)))

      pinFig = dbCreatePolygon(cv list(layer type) list((x-dl:y+l+sl) (x-dl:y+l) (x+d+dl:y+l) (x+d+h+l:y+dl-h) (x+d+h+l:y-d-h-dl) (x+d+dl:y-d-2*h-l) (x-dl:y-d-2*h-l) (x-l-h:y-d-h-dl) (x-l-h:y+dl-h) 
      (x-dl:y+l) (x-dl:y+l+sl) (x-dl-0.24:y+l+sl) (x-l-sl-h:y-h+dl+0.24) (x-l-sl-h:y-d-h-dl-0.24) (x-dl-0.24:y-d-2*h-l-sl) (x+d+dl+0.24:y-d-2*h-l-sl) (x+d+h+l+sl:y-d-h-dl-0.24) (x+d+h+l+sl:y-h+dl+0.24) (x+d+dl+0.24:y+l+sl)))
    )   
    if( layer == "SYMBOL" then
      ;pinFig = dbCreatePolygon(cv list(layer type) list((x-h-l:y+l+sl) (x-h-l-sl:y+l) (x-h-l-sl:y-d-2*h-l) (x-h-l:y-d-2*h-l-sl) (x+d+h+l:y-d-2*h-l-sl) (x+d+h+l+sl:y-d-2*h-l) (x+d+h+l+sl:y+l) (x+d+h+l:y+l+sl)))

      pinFig = dbCreatePolygon(cv list(layer type) list((x-dl-0.24:y+l+sl) (x-h-l-sl:y-h+dl+0.24) (x-h-l-sl:y-d-h-dl-0.24) (x-dl-0.24:y-d-2*h-l-sl) (x+d+dl+0.24:y-d-2*h-l-sl) (x+d+h+l+sl:y-d-h-dl-0.24) (x+d+h+l+sl:y-h+dl+0.24) (x+d+dl+0.24:y+l+sl)))
    )
    list(pinFig)
  )
)

procedure(createRect(cv layer type l d h dl)
  let((pinFig gatePinWidth)
    if( layer == "NPLUS" || layer == "PPLUS" then
      dbCreateRect(cv list(layer type) list((x-h-l-sl-DIFFNPLUS_minOverlap:y+l+sl+PO1DIFF_overhang+VI1_Size+2*VI1ME1_minEnclosure) 
      (x+d+h+l+sl+DIFFNPLUS_minOverlap:y-d-2*h-l-sl-DIFFNPLUS_minOverlap))) 
    else
      gatePinWidth = snapGrid((2*VI1ME1_minEnclosure+VI1_minSpacing_3x3+2*VI1_Size) grid)  
      pinFig = dbCreateRect(cv list(layer type) list((snapGrid((x-dl-((gatePinWidth-0.22)/2)) grid):y+l+sl+PO1DIFF_overhang) (snapGrid((x-dl+0.22+((gatePinWidth-0.22)/2)) grid):y+l+sl+PO1DIFF_overhang+(VI1_Size+2*VI1ME1_minEnclosure)))) 
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

procedure(Createlayout(cv model l d h sl)
  let((x y mosType alfa NPLUS_Length NPLUS_Height)
    x = 0 
    y = 0

    if(model == "n_elt" then
        mosType = "n"
    )
    if(model == "p_elt" then
        mosType = "p"
    )

    ;; Convert string to float and multiply for a 
    ;; factor of mega(1e6) to get the value in meters
    l = cdfParseFloatString(l)*1e6
    d = cdfParseFloatString(d)*1e6
    h = cdfParseFloatString(h)*1e6
    sl = cdfParseFloatString(sl)*1e6

    alfa = (22.5/180)*3.14  ; justificar este valor graus ou radianus?
    dl = tan(alfa)*l
    dl = snapGrid((round(dl*1000.0)/1000.0) grid)

    createPolygon(cv "DIFF" "DIFF" "drawing" l d h dl sl)

    createPolygon(cv "D" "ME1" "drawing" l d h dl sl)
    createPolygon(cv "D" "ME2" "drawing" l d h dl sl)
    pinFigD = car(createPolygon(cv "D" "ME3" "drawing" l d h dl sl))

    createPin(cv "D" "input" pinFigD)

    ;; Creation of endlosed gate in PO1.
    createPolygon(cv "EG" "PO1" "drawing" l d h dl sl) 

    pinFigG = car(createRect(cv "ME1" "drawing" l d h dl))

    createPin(cv "G" "input" pinFigG)

    ;; Creation of gate contact M1 to POLY
    designGateContacts(cv x y l dl sl "M1_POLY")

    ;; Creation of gate contact M2 to M1
    designGateContacts(cv x y l dl sl "M2_M1")

    createPolygon(cv "S" "ME1" "drawing" l d h dl sl)
    pinFigS = car(createPolygon(cv "S" "ME2" "drawing" l d h dl sl))

    createPin(cv "S" "inputOutput" pinFigS)

    if(mosType == "n" then
      ;; Creation of NPLUS
      createRect(cv "NPLUS" "drawing" l d h dl)

      ;; Design Bulk
      pinFigB = car(createPolygon(cv "" "SYMBOL" "WELLBODY" l d h dl sl))

      createPin(cv "B" "input" pinFigB)
    else
      ;; Creation of PPLUS 
      createRect(cv "PPLUS" "drawing" l d h dl)
    )

    designDrainContacts(cv x y d h "CONT") 

    designDrainVias(cv x y d h "VI1")

    designDrainVias(cv x y d h "VI2")

    designSourceContacts(cv x y d l h dl "CONT")

    designSourceVias(cv x y d l h dl sl "VI1")

    ;; Creation of Guard Ring    
    NPLUS_Length = d+2*h+2*l+2*sl+2*DIFFNPLUS_minOverlap 
    NPLUS_Height = d+2*h+2*l+2*sl+DIFFNPLUS_minOverlap+PO1DIFF_overhang+VI1_Size+2*VI1ME1_minEnclosure

    x = x-h-l-sl-DIFFNPLUS_minOverlap
    y = y+l+sl+PO1DIFF_overhang+VI1_Size+2*VI1ME1_minEnclosure

    CreateGR(cv x y NPLUS_Length NPLUS_Height mosType)
  )
)

procedure(ELTdefinePC(libName cellName)
  if(cellName == "N_ELT" then
    pcDefinePCell(
      list(ddGetObj(libName) cellName "layout")
      (
        (model "string" "n_elt")
        (w "string" "4.5u")
        (l "string" "0.2u")
        (d "string" "0.7u")
        (h "string" "0.15u")
        (dl "string" "0.085u")
        (sl "string" "0.36u")

      )
      let( ((cv pcCellView)) 
        GetTechInfo(cv)
        Createlayout(cv model l d h sl)
      )  
    )
  )
  if(cellName == "P_ELT" then
    pcDefinePCell(
      list(ddGetObj(libName) cellName "layout")
      (
        (model "string" "p_elt")
        (w "string" "9.6u")
        (l "string" "0.2u")
        (d "string" "1.115u")
        (h "string" "0.15u")
        (dl "string" "0.085u")
        (sl "string" "0.36u")
      )
      let( ((cv pcCellView)) 
        GetTechInfo(cv)
        Createlayout(cv model l d h sl)
      )  
    )
  )
)

