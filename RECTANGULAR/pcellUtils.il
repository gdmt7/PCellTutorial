/* pcellUtils.il

Author          Guilherme Trindade
Group           INESC-ID - Analog and Mixed-Signal Circuits (CAM)
Language        SKILL
Revision No.    1.0
Date Created    Fev 25, 2020
Modified         
By:

************************
LIBRARY = "UMC130"
CELL    = "pcellUtils"
************************

*/

procedure(calcWmethod()
    let( (w l d dl sl alfa str) 
        w = cdfParseFloatString(cdfgData->w->value)*1e6
        l = cdfParseFloatString(cdfgData->l->value)*1e6
        d = cdfParseFloatString(cdfgData->d->value)*1e6
        dl = cdfParseFloatString(cdfgData->dl->value)*1e6
        sl = cdfParseFloatString(cdfgData->sl->value)*1e6

        ;alfa = 1.1780972451

        alfa = (22.5/180)*3.14  ; justificar este valor graus ou radianus?
        dl = tan(alfa)*l
        dl = snapGrid((round(dl*1000.0)/1000.0) grid) 
        sprintf(str "%gu" dl)
        cdfgData->dl->value = str

        d = (w/4) - dl - (0.212132+2*dl)/2 - 0.212132/2
        d = snapGrid((round(d*1000.0)/1000.0) grid) 
        sprintf(str "%gu" d)
        cdfgData->d->value = str

        ;w = 4*(d + dl + (0.212132+2*dl)/2 + 0.212132/2)

        ;d = (w/4) - 2*dl - 0.212132

        ;w = snapGrid((round(w*1000.0)/1000.0) grid)

        ;d = snapGrid((round(d*1000.0)/1000.0) grid) 

        ;dl = snapGrid((round(dl*1000.0)/1000.0) grid) 

        ;sprintf(str "%gu" w)
        ;cdfgData->w->value = str

        ;sprintf(str "%gu" d)
        ;cdfgData->d->value = str

        ;sprintf(str "%gu" dl)
        ;cdfgData->dl->value = str
    )
)

procedure(snapGrid(size grid)
    size = round(size/grid)*grid
)

procedure(Create_auCdl(symbolId libName cellName)
  let((cvId)
    cvId = dbOpenCellViewByType(libName cellName "auCdl" "schematicSymbol" "w")
    schCloneSymbol(cvId symbolId 0:0 "R0")

    dbSave(cvId)
  )
)

procedure(Create_spectre(symbolId libName cellName)
  let((cvId)
    cvId = dbOpenCellViewByType(libName cellName "spectre" "schematicSymbol" "w")
    schCloneSymbol(cvId symbolId 0:0 "R0")

    dbSave(cvId)
  )
)

procedure(CreateSymbol(libName cellName)
  let((cvId mosType)
  
    if(cellName == "N_ELT" then
        mosType = "n"
    )
    if(cellName == "P_ELT" then
        mosType = "p"
    )

    cvId = dbOpenCellViewByType(libName cellName "symbol" "schematicSymbol" "w")
    instSympin = dbOpenCellViewByType("basic" "sympin" "symbol")

    schCreateInstBox(cvId list(0:-0.1875 0.25:0.1875))  

    schCreateSymbolShape(cvId "line" "solid" list(0.0:0.0 0.09375:0.0))
    schCreateSymbolShape(cvId "line" "solid" list(0.125:0.0 0.25:0.0)) 
    schCreateSymbolShape(cvId "line" "solid" list(0.125:-0.09375 0.25:-0.09375 0.25:-0.1875))
    schCreateSymbolShape(cvId "line" "solid" list(0.125:0.09375 0.25:0.09375 0.25:0.1875))
    schCreateSymbolShape(cvId "line" "solid" list(0.125:-0.09375 0.125:0.09375)) 
    schCreateSymbolShape(cvId "line" "solid" list(0.09375:0.09375 0.09375:-0.09375)) 
    
    schCreateSymbolPin(cvId instSympin "G" "inputOutput" 0:0 "R0")
    schCreateSymbolPin(cvId instSympin "B" "inputOutput" 0.25:0 "R0")

    schCreateSymbolLabel(cvId 0.695:0.22 "analog instance label" "cdsName()" "lowerRight" "R0" "stick" 0.05 "ILLabel") 

    schCreateSymbolLabel(cvId 0.770:0.125 "analog device annotate" "cdsParam(1)" "lowerRight" "R0" "stick" 0.05 "ILLabel")
    schCreateSymbolLabel(cvId 0.775:-0.065 "analog device annotate" "cdsParam(2)" "lowerRight" "R0" "stick" 0.05 "ILLabel") 
    schCreateSymbolLabel(cvId 0.775:-0.155 "analog device annotate" "cdsParam(3)" "lowerRight" "R0" "stick" 0.05 "ILLabel")
    schCreateSymbolLabel(cvId 0.775:-0.250 "analog device annotate" "cdsParam(4)" "lowerRight" "R0" "stick" 0.05 "ILLabel") 
    schCreateSymbolLabel(cvId 0.775:-0.345 "analog device annotate" "cdsParam(5)" "lowerRight" "R0" "stick" 0.05 "ILLabel")

    schCreateSymbolLabel(cvId 0.645:0.035 "analog pin annotate" "cdsTerm(\"B\")" "lowerRight" "R0" "stick" 0.05 "ILLabel")
    schCreateSymbolLabel(cvId 0.095:0.035 "analog pin annotate" "cdsTerm(\"G\")" "lowerRight" "R0" "stick" 0.05 "ILLabel")

    if( mosType == "n" then
        schCreateSymbolShape(cvId "line" "solid" list(0.1875:-0.0625 0.25:-0.09375 0.1875:-0.125)) 
        schCreateSymbolPin(cvId instSympin "D" "inputOutput" 0.25:0.1875 "R0")
        schCreateSymbolPin(cvId instSympin "S" "inputOutput" 0.25:-0.1875 "R0")
        schCreateSymbolLabel(cvId 0.22:0.125 "analog pin annotate" "cdsTerm(\"D\")" "lowerRight" "R0" "stick" 0.05 "ILLabel")      
        schCreateSymbolLabel(cvId 0.22:-0.18 "analog pin annotate" "cdsTerm(\"S\")" "lowerRight" "R0" "stick" 0.05 "ILLabel")
    else
        schCreateSymbolShape(cvId "line" "solid" list(0.23:0.125 0.17:0.095 0.23:0.065)) 
        schCreateSymbolPin(cvId instSympin "S" "inputOutput" 0.25:0.1875 "R0")
        schCreateSymbolPin(cvId instSympin "D" "inputOutput" 0.25:-0.1875 "R0")
        schCreateSymbolLabel(cvId 0.22:0.125 "analog pin annotate" "cdsTerm(\"S\")" "lowerRight" "R0" "stick" 0.05 "ILLabel")      
        schCreateSymbolLabel(cvId 0.22:-0.18 "analog pin annotate" "cdsTerm(\"D\")" "lowerRight" "R0" "stick" 0.05 "ILLabel")

        ;schCreateSymbolPin(cvId instSympin "PSUB" "input" 0:-0.1875 "R0")
        ;schCreateSymbolShape(cvId "line" "solid" list(-0.035:-0.225 0.035:-0.225))
        ;schCreateSymbolShape(cvId "line" "solid" list(-0.035:-0.15 0.035:-0.15))

        ;schCreateSymbolShape(cvId "line" "solid" list(-0.035:-0.15 -0.035:-0.225))
        ;schCreateSymbolShape(cvId "line" "solid" list(-0.035:-0.15 -0.035:-0.225))

        ;schCreateSymbolShape(cvId "line" "solid" list(0.04:-0.15 0.04:-0.225))
        ;schCreateSymbolShape(cvId "line" "solid" list(0.04:-0.15 0.04:-0.225))
        ;schCreateSymbolLabel(cvId 0.05:-0.30 "analog pin annotate" "cdsTerm(\"PSUB\")" "lowerRight" "R0" "stick" 0.05 "ILLabel")
    )

    Create_auCdl(cvId libName cellName)
    Create_spectre(cvId libName cellName)

    dbSave(cvId)
  )
)

procedure(designLabels(xpos ypos cellviewId layer l w1 h sw)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(w1/2):ypos-(w1/2) "D" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(w1/2):ypos+l+(sw/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(w1/2):ypos-w1-2*h-l-(sw/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+w1+h+l+(sw/2):ypos-(w1/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos-h-l-(sw/2):ypos-(w1/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos-h-(l/2):ypos+l+sw+0.18+(0.32/2) "G" "centerCenter" "R0" "stick" 0.25)
)

procedure(designGateContacts(cvId x y l dl sl layer)
    let((tf viaDef viaParams newVia gatePinWidth)
        tf=techGetTechFile(cvId)
        viaDef=techFindViaDefByName(tf layer)

        if( layer == "M1_POLY" then
            gatePinWidth = snapGrid((2*PO1CT_enclosure+CT_minSpacing+2*CT_Size) grid) 
            viaParams = list(list("cutRows" 1) list("cutColumns" 2))
            newVia = dbCreateVia(cvId viaDef list(snapGrid(x-dl-((gatePinWidth-0.16)/2)+(gatePinWidth/2) grid) y+l+sl+PO1DIFF_overhang+((2*PO1CT_enclosure+CT_Size)/2)) "R0" viaParams) 
        else
            gatePinWidth = snapGrid((2*VI1ME1_minEnclosure+VI1_minSpacing+2*VI1_Size) grid) 
            viaParams = list(list("cutRows" 1) list("cutColumns" 2))
            newVia = dbCreateVia(cvId viaDef list(snapGrid(x-dl-((gatePinWidth-0.16)/2)+(gatePinWidth/2) grid) y+l+sl+PO1DIFF_overhang+((2*VI1ME1_minEnclosure+VI1_Size)/2)) "R0" viaParams) 
        )
    )
)

procedure(getContacts(width name)
    let((minBoundarie nc spaceleft overSpace)
        nc = 0 

        if( name == "drainContact" then 
            nc = round((width/(CT_Size+CT_minSpacing)))
            spaceleft = width - ((nc*CT_Size) + ((nc-1)*CT_minSpacing))
            overSpace = snapGrid((spaceleft/2) grid)
        ) 
        if( name == "drainVia" then 
            nc = round((width/(VI1_Size+VI1_minSpacing)))
            spaceleft = width - ((nc*VI1_Size) + ((nc-1)*VI1_minSpacing))
            overSpace = snapGrid((spaceleft/2) grid)
        ) 
        if( name == "sourceContact" then
            nc = round((width/(CT_Size+CT_minSpacing)))
            spaceleft = width - ((nc*CT_Size) + ((nc-1)*CT_minSpacing))
            overSpace = snapGrid((spaceleft/2) grid)
        )
        if( name == "sourceVia" then
            nc = round((width/(VI1_Size+VI1_minSpacing)))
            spaceleft = width - ((nc*VI1_Size) + ((nc-1)*VI1_minSpacing))
            overSpace = snapGrid((spaceleft/2) grid)
        )
        list(nc overSpace)
    )
) 

procedure(designDrainContacts(cvId xpos ypos d h layer)   
    let( (nc totalC nc_v overSpace)

        nc = car(getContacts(d "drainContact"))
        overSpace = cadr(getContacts(d "drainContact"))

        nc_v = nc - 2
        totalC = 2*nc + 2*nc_v
        
        xpos = xpos + overSpace  
        ypos = ypos - h - overSpace

        for( i 1 totalC 
            if( i <= nc then
                dbCreateRect(cvId list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16))
                if(i <= nc - 1 then xpos = xpos + 0.2 + 0.16)
            )
            if( i > nc && i <= nc + nc_v then
                ypos = ypos - 0.2 - 0.16 
                dbCreateRect(cvId list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16)) 
                ;if(i == nc + nc_v then ypos = ypos - 0.2 - 0.16)
            )
            if( i > nc + nc_v && i <= 2*nc + nc_v then 
                if(i > nc + nc_v && i < 2*nc then ypos = ypos - 0.2 - 0.16)
                dbCreateRect(cvId list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16))  
                if(i > nc + nc_v && i < 2*nc + nc_v then xpos = xpos - 0.2 - 0.16)
            )
            if( i > 2*nc + nc_v then
                ypos = ypos + 0.2 + 0.16
                dbCreateRect(cvId list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16))  
            )
        )
    )
)

procedure(designDrainVias(cvId xpos ypos d h layer)   
    let( (nc overSpace totalC nvertC)

        nc = car(getContacts(d "drainVia"))
        overSpace = cadr(getContacts(d "drainVia"))

        nvertC = nc - 2 
        totalC = 2*nc + 2*nvertC
        
        xpos = xpos + overSpace
        ypos = ypos - overSpace - h

        for( i 1 totalC 
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                if(i <= nc - 1 then xpos = xpos + 2*ME2_minSpacing)
            )
            if( i > nc && i <= nc + nvertC then
                ypos = ypos - 2*ME2_minSpacing
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size)) 
            )
            if( i > nc + nvertC && i <= 2*nc + nvertC then 
                if(i > nc + nvertC && i < 2*nc then ypos = ypos - 2*ME2_minSpacing)
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))    
                if(i > nc + nvertC && i < 2*nc + nvertC then xpos = xpos - 2*ME2_minSpacing)
            )
            if( i > 2*nc + nvertC then
                ypos = ypos + 2*ME2_minSpacing
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))  
            )
        )
    )
)

procedure(designSourceContacts(cvId xpos ypos d l h dl layer)
    let( (sourceWidth nc totalC overSpace_1 hh sd hs cs)  

        sourceWidth = d + 2*dl

        nc = car(getContacts(sourceWidth "sourceContact"))
        overSpace = cadr(getContacts(sourceWidth "sourceContact"))
        overSpace_1 = sourceWidth - ((nc*CT_Size) + ((nc-1)*CT_minSpacing)) - overSpace

        totalC = 3*nc

        xpos = xpos - h - l - PO1CT_minSpacing - CT_Size
        ypos = ypos - h + dl - overSpace

        for( i 1 totalC
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then ypos = ypos - CT_minSpacing - CT_Size)
            )

            if( i > nc && i <= 2*nc then
                if( i == nc + 1 then xpos = xpos + PO1CT_minSpacing + l + h - dl + CT_Size + overSpace ypos = ypos - CT_Size - overSpace_1 + dl - h - l - PO1CT_minSpacing) 
                dbCreateRect(cvId list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size)) 
                if(i <= 2*nc - 1 then xpos = xpos + CT_minSpacing + CT_Size)
            )

            if( i > 2*nc then
                if( i == 2*nc + 1 then xpos = xpos + overSpace_1 + CT_Size - dl + h + l + PO1CT_minSpacing ypos = ypos + CT_Size + PO1CT_minSpacing + l + h - dl + overSpace)
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size)) 
                if(i <= totalC - 1 then ypos = ypos + CT_minSpacing + CT_Size)
            )
        )

        sourceWidth = (d + 2*dl) - 0.22 - 0.1 ;square_sides
        nc = car(getContacts(sourceWidth "sourceContact"))
        overSpace = cadr(getContacts(sourceWidth "sourceContact"))

        xpos = xpos - PO1CT_minSpacing - l - h + dl - overSpace 
        ypos = ypos + CT_Size + overSpace_1 - dl + h + l + PO1CT_minSpacing 

        for( i 1 nc
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
            xpos = xpos - CT_minSpacing - CT_Size
        ) 

        if( l < 0.7 then
            hh = sqrt(2*h*h) ; hipotenusa h
            sd = hh + 2*dl    ; source diagonal
            hs = (sd/2) - PO1CT_minSpacing ; hipotenusa source
            cs = snapGrid(sqrt((hs*hs)/2) grid) ;cateto da source

            xpos = 0 - dl - cs - 0.17
            ypos = 0 + l + CT_Size - cs
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))

            xpos = 0 + CT_Size + d + dl + cs + 0.17
            ypos = 0 + CT_Size + l - cs
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))

            xpos = 0 - dl - cs - 0.17
            ypos = 0 - d - 2*h - l + cs
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))

            xpos = 0 + d + dl + CT_Size + cs + 0.17
            ypos = 0 - d - 2*h - l + cs
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
        else
            width = sqrt(2*h*h) + 2*dl 
            nc = round((width/(0.226274+0.205061)))
            spaceleft = width - ((nc*0.226274) + ((nc-1)*0.205061))
            overSpace = snapGrid((spaceleft/2) grid)
            c_overSpace = snapGrid(sqrt(overSpace*overSpace/2) grid) ; cateto overSpace

            xpos = 0 - dl - 0.17 - c_overSpace
            ypos = 0 + l + CT_Size - c_overSpace

            for( i 1 4*nc
                if( i <= nc then
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                    if(i <= nc - 1 then 
                        xpos = xpos - 0.145 - 0.16
                        ypos = ypos - 0.145 - 0.16
                    )
                )
                if( i > nc && i <= 2*nc then
                    if(i == nc + 1 then xpos = 0 - h - l + c_overSpace ypos = 0 - h - d - dl - c_overSpace - 0.17)
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                    if(i <= 2*nc - 1 then 
                        xpos = xpos + 0.145 + 0.16
                        ypos = ypos - 0.145 - 0.16
                    )
                )
                if( i > 2*nc && i <= 3*nc then
                    if(i == 2*nc + 1 then xpos = 0 + CT_Size + d + dl + c_overSpace + 0.17 ypos = 0 - 2*h - d - l + c_overSpace)
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                    if(i <= totalC - 1 then 
                        xpos = xpos + 0.145 + 0.16
                        ypos = ypos + 0.145 + 0.16
                    )
                )
                if( i > 3*nc then
                    if(i == 3*nc + 1 then xpos = 0 + CT_Size + d + dl + c_overSpace + 0.17 ypos = 0 + l + CT_Size - c_overSpace)
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                    if(i <= totalC - 1 then 
                        xpos = xpos + 0.145 + 0.16
                        ypos = ypos - 0.145 - 0.16
                    )
                )
            )        
        )
    )
)

procedure(designSourceVias(cvId xpos ypos d l h dl sl layer)
    let( (sourceWidth nc totalC VI1CT_minSpacing overSpace_1) 

        sourceWidth = d + 2*dl
        VI1CT_minSpacing = (sl - VI1_Size)/2

        nc = car(getContacts(sourceWidth "sourceVia"))
        overSpace = cadr(getContacts(sourceWidth "sourceVia"))
        overSpace_1 = sourceWidth - ((nc*VI1_Size) + ((nc-1)*VI1_Size)) - overSpace
 
        totalC = 3*nc

        xpos = xpos - h - l - VI1CT_minSpacing - VI1_Size
        ypos = ypos - h + dl - overSpace

        for( i 1 totalC 
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))  
                if(i <= nc - 1 then ypos = ypos - 2*ME2_minSpacing)
            )

            if( i > nc && i <= 2*nc then
                if(i == nc + 1 then xpos = xpos + VI1CT_minSpacing + l + h - dl + overSpace + VI1_Size ypos = ypos - overSpace_1+ dl - h - l - VI1_Size - VI1CT_minSpacing) 
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))  
                if(i <= 2*nc - 1 then xpos = xpos + 2*ME2_minSpacing)
            )

            if( i > 2*nc then
                if(i == 2*nc + 1 then xpos = xpos + overSpace_1 - dl + h + l + VI1CT_minSpacing + VI1_Size ypos = ypos + VI1CT_minSpacing + l + h - dl + overSpace + VI1_Size)
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))  
                if(i <= totalC - 1 then ypos = ypos + 2*ME2_minSpacing)
            )
        )

        sourceWidth = (d + 2*dl) - 0.22 - 0.1 ;square_sides
        nc = car(getContacts(sourceWidth "sourceVia"))
        overSpace = cadr(getContacts(sourceWidth "sourceVia"))

        xpos = xpos - VI1CT_minSpacing - l - h + dl - overSpace - VI1_Size
        ypos = ypos + overSpace_1 - dl + h + l + VI1CT_minSpacing + VI1_Size

        for( i 1 nc
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
            xpos = xpos - 2*ME2_minSpacing
        ) 

        if( l < 0.75 then
            hh = sqrt(2*h*h) ;hipotenusa h
            sd = hh + 2*dl    ;source diagonal
            hs = (sd/2) - 0.067179 ;hipotenusa source 0.042426
            cs = snapGrid(sqrt((hs*hs)/2) grid) ;cateto da source

            xpos = 0 - dl - VI1_Size - cs - 0.1
            ypos = 0 + l + VI1_Size - cs 
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))

            xpos = 0 + d + dl + cs + 0.1
            ypos = 0 + l + VI1_Size - cs 
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))

            xpos = 0 - dl - VI1_Size - cs - 0.1
            ypos = 0 - d - 2*h - l + cs
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))

            xpos = 0 + d + dl + cs + 0.1
            ypos = 0 - d - 2*h - l + cs
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
        else
            width = sqrt(2*h*h) + 2*dl 
            nc = round((width/(0.282843+0.205061)))
            spaceleft = width - ((nc*0.282843) + ((nc-1)*0.205061))
            overSpace = snapGrid((spaceleft/2) grid)
            c_overSpace = snapGrid(sqrt(overSpace*overSpace/2) grid)

            xpos = 0 - dl - VI1_Size - c_overSpace - 2*0.075
            ypos = 0 + l + VI1_Size - c_overSpace - 0.075

            for( i 1 4*nc
                if( i <= nc then
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                    if(i <= nc - 1 then 
                        xpos = xpos - 0.145 - 0.2
                        ypos = ypos - 0.145 - 0.2
                    )
                )
                if( i > nc && i <= 2*nc then
                    if(i == nc + 1 then xpos = 0 - h - l - VI1_Size + c_overSpace + 0.075 ypos = 0 - d - h - dl - c_overSpace - 2*0.075)
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                    if(i <= 2*nc - 1 then 
                        xpos = xpos + 0.145 + 0.2
                        ypos = ypos - 0.145 - 0.2
                    )
                )
                if( i > 2*nc && i <= 3*nc then
                    if(i == 2*nc + 1 then xpos = 0 + d + dl + c_overSpace + 2*0.075 ypos = 0 - d - 2*h - l + c_overSpace + 0.075)
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                    if(i <= totalC - 1 then 
                        xpos = xpos + 0.145 + 0.2
                        ypos = ypos + 0.145 + 0.2
                    )
                )
                if( i > 3*nc then
                    if(i == 3*nc + 1 then xpos = 0 + d + dl + c_overSpace + 2*0.075 ypos = 0 + l + VI1_Size - c_overSpace - 0.075)
                    dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                    if(i <= totalC - 1 then 
                        xpos = xpos + 0.145 + 0.2
                        ypos = ypos - 0.145 - 0.2
                    )
                )
            )
        )
    )
)

procedure(getGRContacts(length height)
    let((minBoundarie ncLength ncHeight)
        minBoundarie = 2*0.06
        ncLength = round((length/(0.16+0.2)))
        missSpace = length - minBoundarie - (ncLength*0.16) - ((ncLength-1)*0.2)
        if( missSpace <= 0 then
            appendSpace = 0 - missSpace
            length = length + appendSpace
        else
            appendSpace = 0.16 - (missSpace - 0.2)
            length = length + appendSpace
        )
        ncLength = round((length/(0.16+0.2)))

        ncHeight = round((height/(0.16+0.2)))
        missSpace = height - minBoundarie - (ncHeight*0.16) - ((ncHeight-1)*0.2)
        if( missSpace <= 0 then
            appendSpace = 0 - missSpace
            height = height + appendSpace
        else
            appendSpace = 0.16 - (missSpace - 0.2)
            height = height + appendSpace
        )
        ncHeight = round((height/(0.16+0.2)))
        list(length ncLength height ncHeight)
    )
)

procedure(designGRContacts(cv x y ncLength ncWidth)   
    let((ncTotal xpos ypos) 
        ncWidth = ncWidth - 2
        ncTotal = (2*ncLength) + (2*ncWidth)

        xpos = x + 0.06
        ypos = y - 0.06

        for( i 1 ncTotal - 1
            if( i <= ncLength then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16))
                if(i < ncLength then xpos = xpos + 0.2 + 0.16)
            )

            if( i >= ncLength && i < ncLength + ncWidth then
                if(i == ncLength then ypos = ypos - 0.2 - 0.16) 
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16))
                ypos = ypos - 0.2 - 0.16
            )

            if( i >= ncLength + ncWidth && i < 2*ncLength + ncWidth then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16))
                xpos = xpos - 0.2 - 0.16
            )

            if( i >= 2*ncLength + ncWidth then
                if(i == 2*ncLength + ncWidth then xpos = xpos + 0.2 + 0.16 ypos = ypos + 0.2 + 0.16)
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+0.16:ypos-0.16))
                ypos = ypos + 0.2 + 0.16
            )
        )
    )
)

procedure(CreateGR(cv xpos ypos NPLUS_Length NPLUS_Height mosType)
    let((DIFF_PPLUS_Spacing DIFF_Length DIFF_Height DIFF_Width ncLength ncWidth PPLUS_Length PPLUS_Height PPLUSNPLUS_LengthSpacing PPLUSNPLUS_HeightSpacing) 
        DIFF_Width = CT_Size+2*CTDIFF_minSpacing
        
        DIFF_Length = NPLUS_Length + 2*DIFF_Width + 4*DIFFPPLUS_Spacing
        ;DIFF_Height = NPLUS_Height + 2*DIFF_Width + 4*DIFFPPLUS_Spacing + 0.28

        DIFF_Height = NPLUS_Height + 2*DIFF_Width + 4*DIFFPPLUS_Spacing
        ;DIFF_Height = NPLUS_Height + DIFFNPLUS_minSpacing + 0.16 + 0.16 + 0.28 + 0.18 + 0.32 + 0.16 + 0.16 + 0.28

        retList = getGRContacts(DIFF_Length DIFF_Height)

        DIFF_Length = car(retList)
        DIFF_Height = caddr(retList)

        ncLength = cadr(retList)
        ncWidth = cadddr(retList)

        PPLUS_Length = DIFF_Length-2*DIFF_Width-2*DIFFPPLUS_Spacing
        PPLUS_Height = DIFF_Height-2*DIFF_Width-2*DIFFPPLUS_Spacing

        PPLUSNPLUS_LengthSpacing = snapGrid((PPLUS_Length - NPLUS_Length)/2 grid)
        PPLUSNPLUS_HeightSpacing = snapGrid((PPLUS_Height - NPLUS_Height)/2 grid)

        xpos = xpos - DIFF_Width - PPLUSNPLUS_LengthSpacing - DIFFPPLUS_Spacing
        ypos = ypos + DIFF_Width + PPLUSNPLUS_HeightSpacing + DIFFPPLUS_Spacing

        designGRContacts(cv xpos ypos ncLength ncWidth)

        if(mosType == "n" then
            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos-DIFFPPLUS_Spacing:ypos+DIFFPPLUS_Spacing) (xpos-DIFFPPLUS_Spacing:ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) 
            (xpos+DIFF_Width+DIFFPPLUS_Spacing:ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) (xpos+DIFF_Width+DIFFPPLUS_Spacing:ypos-DIFF_Width-DIFFPPLUS_Spacing) 
            (xpos+(DIFF_Length-DIFF_Width-DIFFPPLUS_Spacing):ypos-DIFF_Width-DIFFPPLUS_Spacing) (xpos+(DIFF_Length-DIFF_Width-DIFFPPLUS_Spacing):ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) 
            (xpos-DIFFPPLUS_Spacing:ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) (xpos-DIFFPPLUS_Spacing:ypos-(DIFF_Height+DIFFPPLUS_Spacing)) 
            (xpos+DIFF_Length+DIFFPPLUS_Spacing:ypos-(DIFF_Height+DIFFPPLUS_Spacing)) (xpos+DIFF_Length+DIFFPPLUS_Spacing:ypos+DIFFPPLUS_Spacing)))
        else
            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos-DIFFPPLUS_Spacing:ypos+DIFFPPLUS_Spacing) (xpos-DIFFPPLUS_Spacing:ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) 
            (xpos+DIFF_Width+DIFFPPLUS_Spacing:ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) (xpos+DIFF_Width+DIFFPPLUS_Spacing:ypos-DIFF_Width-DIFFPPLUS_Spacing) 
            (xpos+(DIFF_Length-DIFF_Width-DIFFPPLUS_Spacing):ypos-DIFF_Width-DIFFPPLUS_Spacing) (xpos+(DIFF_Length-DIFF_Width-DIFFPPLUS_Spacing):ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) 
            (xpos-DIFFPPLUS_Spacing:ypos-(DIFF_Height-DIFF_Width-DIFFPPLUS_Spacing)) (xpos-DIFFPPLUS_Spacing:ypos-(DIFF_Height+DIFFPPLUS_Spacing)) 
            (xpos+DIFF_Length+DIFFPPLUS_Spacing:ypos-(DIFF_Height+DIFFPPLUS_Spacing)) (xpos+DIFF_Length+DIFFPPLUS_Spacing:ypos+DIFFPPLUS_Spacing)))

            pinFigB = dbCreateRect(cv list("NWEL" "drawing") list((xpos-DIFFPPLUS_Spacing-NWELL_PPLUS_Spacing:ypos+DIFFPPLUS_Spacing+NWELL_PPLUS_Spacing) (xpos+DIFF_Length+DIFFPPLUS_Spacing+NWELL_PPLUS_Spacing:ypos-DIFF_Height-DIFFPPLUS_Spacing-NWELL_PPLUS_Spacing)))

            B = dbCreateNet(cv "B")
            termB = dbCreateTerm(B "" "inputOutput")
            pinB = dbCreatePin(B pinFigB "Bulk")
        )

        ;; Creation of Diffusion and ME1 contact
        dbCreateRect(cv list("DIFF" "drawing") list((xpos:ypos) (xpos+DIFF_Length:ypos-DIFF_Width)))
        dbCreateRect(cv list("ME1" "drawing") list((xpos:ypos) (xpos+DIFF_Length:ypos-DIFF_Width)))

        dbCreateRect(cv list("DIFF" "drawing") list((xpos:ypos-DIFF_Width) (xpos+DIFF_Width:ypos-DIFF_Height)))
        dbCreateRect(cv list("ME1" "drawing") list((xpos:ypos-DIFF_Width) (xpos+DIFF_Width:ypos-DIFF_Height)))

        ypos = ypos - DIFF_Height
        dbCreateRect(cv list("DIFF" "drawing") list((xpos+DIFF_Width:ypos) (xpos+DIFF_Length:ypos+DIFF_Width)))
        dbCreateRect(cv list("ME1" "drawing") list((xpos+DIFF_Width:ypos) (xpos+DIFF_Length:ypos+DIFF_Width)))

        xpos = xpos + DIFF_Length
        dbCreateRect(cv list("DIFF" "drawing") list((xpos-DIFF_Width:ypos+DIFF_Width) (xpos:ypos+DIFF_Height-DIFF_Width)))
        dbCreateRect(cv list("ME1" "drawing") list((xpos-DIFF_Width:ypos+DIFF_Width) (xpos:ypos+DIFF_Height-DIFF_Width)))
    )
)