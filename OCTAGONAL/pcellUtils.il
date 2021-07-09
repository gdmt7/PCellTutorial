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
    let( (w l d dint cl alfa str) 
        w = cdfParseFloatString(cdfgData->w->value)*1e6
        l = cdfParseFloatString(cdfgData->l->value)*1e6
        d = cdfParseFloatString(cdfgData->d->value)*1e6
        dint = cdfParseFloatString(cdfgData->dint->value)*1e6
        cl = cdfParseFloatString(cdfgData->cl->value)*1e6

        alfa = 1.1780972451
        dint = (w/8) - (l/tan(alfa))
        cl = sqrt((dint*dint)/2)

        dint = snapGrid((round(dint*1000.0)/1000.0) grid) 
        sprintf(str "%gu" dint)
        cdfgData->dint->value = str

        ;w = (dint*8) + ((l/tan(alfa))*8)

        alfa = (22.5/180)*3.14
        d = tan(alfa)*l
        d = snapGrid((round(d*1000.0)/1000.0) grid)

        cl = snapGrid((round(cl*1000.0)/1000.0) grid)
        d = snapGrid((round(d*1000.0)/1000.0) grid)
        w = snapGrid((round(w*1000.0)/1000.0) grid)

        ;sprintf(str "%gu" dint)
        ;cdfgData->dint->value = str

        sprintf(str "%gu" d)
        cdfgData->d->value = str

        sprintf(str "%gu" cl)
        cdfgData->cl->value = str

        sprintf(str "%gu" w)
        cdfgData->w->value = str

        /*if( l < 0.36 then
            sprintf(str "%gu" 0.36)
            cdfgData->l->value = str
            l = cdfParseFloatString(cdfgData->l->value)*1e6
            sprintf(str "%gu" 1.465)
            cdfgData->dint->value = str
            dint = cdfParseFloatString(cdfgData->dint->value)*1e6
            sprintf(str "%gu" 1.035)
            cdfgData->cl->value = str
            cl = cdfParseFloatString(cdfgData->cl->value)*1e6
        )
        if( w < 6 then
            sprintf(str "%gu" 6)
            cdfgData->w->value = str
            w = cdfParseFloatString(cdfgData->w->value)*1e6
            sprintf(str "%gu" 1.465)
            cdfgData->dint->value = str
            dint = cdfParseFloatString(cdfgData->dint->value)*1e6
            sprintf(str "%gu" 1.035)
            cdfgData->cl->value = str
            cl = cdfParseFloatString(cdfgData->cl->value)*1e6
        )*/
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
  
    if(cellName == "N_12_HSL130E" then
        mosType = "n"
    )
    if(cellName == "P_12_HSL130E" then
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

    /*schCreateSymbolLabel(cvId 0.695:0.22 "analog instance label" "cdsName()" "lowerRight" "R0" "stick" 0.05 "ILLabel") 

    schCreateSymbolLabel(cvId 0.770:0.125 "analog device annotate" "cdsParam(1)" "lowerRight" "R0" "stick" 0.05 "ILLabel")
    schCreateSymbolLabel(cvId 0.775:-0.065 "analog device annotate" "cdsParam(2)" "lowerRight" "R0" "stick" 0.05 "ILLabel") 
    schCreateSymbolLabel(cvId 0.775:-0.155 "analog device annotate" "cdsParam(3)" "lowerRight" "R0" "stick" 0.05 "ILLabel")
    schCreateSymbolLabel(cvId 0.775:-0.250 "analog device annotate" "cdsParam(4)" "lowerRight" "R0" "stick" 0.05 "ILLabel") 
    schCreateSymbolLabel(cvId 0.775:-0.345 "analog device annotate" "cdsParam(5)" "lowerRight" "R0" "stick" 0.05 "ILLabel")*/

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
    )

    Create_auCdl(cvId libName cellName)
    Create_spectre(cvId libName cellName)

    dbSave(cvId)
  )
)

procedure(designLabels(xpos ypos cellviewId layer l dl cl sw)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(dl/2):ypos-(dl/2) "D" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(dl/2):ypos+l+(sw/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(dl/2):ypos-dl-2*cl-l-(sw/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+dl+cl+l+(sw/2):ypos-(dl/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos-cl-l-(sw/2):ypos-(dl/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos-cl-(l/2):ypos+l+sw+0.18+(0.32/2) "G" "centerCenter" "R0" "stick" 0.25)
)

procedure(designGateContacts(cvId x y l sw layer)
    let((tf viaDef viaParams newVia gatePinWidth)
        tf=techGetTechFile(cvId)
        viaDef=techFindViaDefByName(tf layer)

        if( layer == "M1_POLY" then
            gatePinWidth = snapGrid((2*PO1CT_enclosure+CT_minSpacing+2*CT_Size) grid) 
            viaParams = list(list("cutRows" 1) list("cutColumns" 2))
            ;newVia = dbCreateVia(cvId viaDef list(x-d-((gatePinWidth-PO1_minWidth)/2)+(gatePinWidth/2) y+l+sw+PO1DIFF_minSpacing+((CT_Size+2*PO1CT_enclosure)/2)) "R0" viaParams) 
            newVia = dbCreateVia(cvId viaDef list(snapGrid((x-d-((gatePinWidth-0.16)/2)+(gatePinWidth/2)) grid) y+l+sw+PO1DIFF_minSpacing+((CT_Size+2*PO1CT_enclosure)/2)) "R0" viaParams) 
        else
            gatePinWidth = snapGrid((2*VI1ME1_minSpacing+VI1_minSpacing+2*VI1_Size) grid) 
            viaParams = list(list("cutRows" 1) list("cutColumns" 2))
            ;newVia = dbCreateVia(cvId viaDef list(x-d-((gatePinWidth-PO1_minWidth)/2)+(gatePinWidth/2) y+l+sw+PO1DIFF_minSpacing+((VI1_Size+2*VI1ME1_minSpacing)/2)) "R0" viaParams) 
            newVia = dbCreateVia(cvId viaDef list(snapGrid((x-d-((gatePinWidth-0.16)/2)+(gatePinWidth/2)) grid) y+l+sw+PO1DIFF_minSpacing+((VI1_Size+2*VI1ME1_minSpacing)/2)) "R0" viaParams) 
        )
    )
)

procedure(getContacts(width name)
    let((nc overSpace spaceFilled spaceLeft CT_Spacing CT_overSpacing)
        nc = 0 

        if( name == "drainHorizontal" then 
            nc = round((width/(CT_Size+CT_minSpacing))) - 1 /* -1 */
            spaceLeft = width - ((nc*CT_Size) + ((nc-1)*CT_minSpacing))
            overSpace = snapGrid((spaceLeft/2) grid)
            if( overSpace <= 0.2 then
                nc = nc - 1
                spaceLeft = width - ((nc*CT_Size) + ((nc-1)*CT_minSpacing))
                overSpace = snapGrid((spaceLeft/2) grid)
            )
        )
        if( name == "drainDiagonal" then 
            nc = round(width/(CT_diagonal+CT_minDiagonal)) - 1
            spaceFilled = nc*CT_diagonal+(nc-1)*CT_minDiagonal
            spaceLeft = width - spaceFilled
            overSpace = snapGrid((spaceLeft/2) grid)         
        )
        if( name == "sourceHorizontal" then 
            nc = round((width/(CT_Size+CT_minSpacing)))
            spaceLeft = width - ((nc*CT_Size) + ((nc-1)*CT_minSpacing))
            overSpace = snapGrid((spaceLeft/2) grid)
        )
        if( name == "sourceDiagonal" then
            nc = round((width/(CT_diagonal+CT_minDiagonal)))
            spaceFilled = nc*CT_diagonal + (nc-1)*CT_minDiagonal
            spaceLeft = width - spaceFilled
            overSpace = snapGrid((spaceLeft/2) grid)
        )
        if( name == "drainVI1" then 
            nc = round((width/(2*VI1_Size))) - 1
            spaceLeft = width - ((nc*VI1_Size) + ((nc-1)*VI1_Size))
            overSpace = snapGrid((spaceLeft/2) grid)
            if( width < 0.6 then
                nc = 1
                spaceLeft = width - ((nc*VI1_Size) + ((nc-1)*VI1_Size))
                overSpace = snapGrid((spaceLeft/2) grid)
            )
        )
        if( name == "sourceVI1" then 
            nc = round((width/(2*VI1_Size))) - 1
            spaceLeft = width - ((nc*VI1_Size) + ((nc-1)*VI1_Size))
            overSpace = snapGrid((spaceLeft/2) grid)
        )
        if( name == "drainVI1Diagonal" || name == "drainVI2Diagonal" then 
            nc = round((width/(VI1_diagonal+VI1_minDiagonal))) - 1
            spaceFilled = nc*VI1_diagonal+(nc-1)*VI1_minDiagonal
            spaceLeft = dint - spaceFilled
            overSpace = snapGrid((spaceLeft/2) grid)
        )
        if( name == "sourceVI1Diagonal" || name == "sourceVI2Diagonal" then 
            nc = round((width/(VI1_diagonal+VI1_minDiagonal)))
            spaceFilled = nc*VI1_diagonal+(nc-1)*VI1_minDiagonal
            spaceLeft = width - spaceFilled
            overSpace = snapGrid((spaceLeft/2) grid)
        )

        list(nc overSpace)
    )  
)

procedure(designDrainContactsDiagonal(cvId xpos ypos dint cl layer)   
    let( (yPO1CT_minSpacing nc overSpace overSpace_sides totalContacts)
        
        /*nc_d = round(((dint-2*CT_diagonal)/(CT_diagonal+CT_minDiagonal)))
        spaceFilled = nc_d*CT_diagonal+(nc_d-1)*CT_minDiagonal
        spaceLeft = dint - spaceFilled
        overSpace = snapGrid((spaceLeft/2) grid)*/

        yPO1CT_minSpacing = 0.17
        nc = car(getContacts(dint "drainDiagonal"))
        overSpace = cadr(getContacts(dint "drainDiagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)

        ;xpos = xpos - overSpace_sides + CT_Size
        ;ypos = ypos - overSpace_sides - yPO1CT_minSpacing

        xpos = xpos + CT_Size - (CT_Size/2) - overSpace_sides + 0.085
        ypos = ypos - (CT_Size/2) - overSpace_sides - 0.085

        totalContacts = 4*nc

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then 
                    xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == nc then xpos = 0 - cl + CT_Size + overSpace_sides + yPO1CT_minSpacing ypos = 0 - cl - dint  + CT_Size - overSpace_sides) 
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= 2*nc - 1 then 
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == 2*nc then xpos = 0 + dint + overSpace_sides  ypos = 0 - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= 3*nc - 1 then
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == 3*nc then xpos = 0 + dint + cl - overSpace_sides - CT_Size - yPO1CT_minSpacing  ypos = 0 - dint - cl - overSpace_sides + CT_Size)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designDrainContacts(cvId xpos ypos dint cl layer)   
    let( (nc overSpace_1 overSpace_2 totalContacts)

        nc = car(getContacts(dint "drainHorizontal"))
        overSpace_1 = cadr(getContacts(dint "drainHorizontal"))
        overSpace_2 = snapGrid((dint - (nc*CT_Size+(nc-1)*CT_minSpacing)-overSpace_1) grid)

        totalContacts = 4*nc
 
        xpos = xpos + overSpace_1
        ypos = ypos - PO1CT_minSpacing

        for( i 1 totalContacts 
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then xpos = xpos + CT_minSpacing + CT_Size) 
                if(i == nc then xpos = xpos + overSpace_2 + cl - PO1CT_minSpacing ypos = ypos - (cl-PO1CT_minSpacing) - overSpace_1) 
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                if(i <= 2*nc - 1 then ypos = ypos - CT_minSpacing - CT_Size)
                if(i == 2*nc then xpos = xpos + PO1CT_minSpacing - cl - overSpace_1 ypos = ypos - overSpace_2 - cl + PO1CT_minSpacing)
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                if(i <= 3*nc - 1 then xpos = xpos - CT_minSpacing - CT_Size)
                if(i == 3*nc then xpos = xpos - cl - overSpace_2 + PO1CT_minSpacing ypos = ypos - PO1CT_minSpacing + cl + overSpace_1)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                ypos = ypos + CT_minSpacing + CT_Size
            )
        )
    )
)

procedure(designSourceContactsDiagonal(cvId l dint d cl xpos ypos layer)
    let((yPO1CT_minSpacing nc spaceFilled spaceLeft overSpace overSpace_sides totalContacts)

        yPO1CT_minSpacing = 0.165
        sourceWidth = dint+2*d

        nc = car(getContacts(sourceWidth "sourceDiagonal"))
        overSpace = cadr(getContacts(sourceWidth "sourceDiagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)
        
        /*nc = round(((sourceWidth-CT_diagonal)/(CT_diagonal+CT_minDiagonal)))
        spaceFilled = nc*CT_diagonal+(nc-1)*CT_minDiagonal
        spaceLeft = sourceWidth - spaceFilled
        overSpace = snapGrid((spaceLeft/2) grid)*/

        ;xpos = xpos - d - overSpace_sides - CT_Size - yPO1CT_minSpacing
        ;ypos = ypos + l - overSpace_sides + yPO1CT_minSpacing

        xpos = xpos - d - CT_Size - overSpace_sides - yPO1CT_minSpacing
        ypos = ypos + l - overSpace_sides + yPO1CT_minSpacing

        totalContacts = 4*nc

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then 
                    xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                ) 
                ;if(i == nc_d then xpos = 0 - d - CT_Size - sourceWidth_sides + overSpace_sides ypos = 0 + l - sourceWidth_sides - sourceWidth - overSpace_sides - yPO1CT_minSpacing)
                if(i == nc then xpos = 0 - cl - l + overSpace_sides - yPO1CT_minSpacing  ypos = 0 - cl - dint - d - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if( i <= 2*nc - 1 then 
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                ;if( i == 2*nc_d then xpos = 0 + sourceWidth - d + overSpace_sides + yPO1CT_minSpacing ypos = 0 + l - overSpace_sides + CT_Size) 
                if( i == 2*nc then xpos = 0 + dint + d + overSpace_sides + yPO1CT_minSpacing ypos = 0 + l - overSpace_sides + yPO1CT_minSpacing) 
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if( i <= 3*nc - 1 then
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                ;if( i == 3*nc_d then xpos = 0 + sourceWidth - d + sourceWidth_sides - overSpace_sides  ypos = 0 + l - sourceWidth_sides - sourceWidth - overSpace_sides - yPO1CT_minSpacing)
                if( i == 3*nc then xpos = 0 + dint + cl + l - CT_Size - overSpace_sides + yPO1CT_minSpacing ypos = 0 - cl - dint - d - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designSourceContacts(cvId l dint d cl xpos ypos layer)
    let((xPO1CT_minSpacing sourceWidth nc totalContacts sourceWidth_sides overSpace_1 overSpace_2)   

        sourceWidth = dint+2*d
        sourceWidth_sides = sqrt(sourceWidth*sourceWidth/2)
        ;sourceWidth_sides = snapGrid(sqrt(sourceWidth*sourceWidth/2) grid)

        nc = car(getContacts(sourceWidth "sourceHorizontal"))
        overSpace_1 = cadr(getContacts(sourceWidth "sourceHorizontal"))
        overSpace_2 = snapGrid((sourceWidth - (nc*CT_Size+(nc-1)*CT_minSpacing)-overSpace_1) grid)

        totalContacts = 4*nc

        ;xpos = xpos - d - CT_Size - sourceWidth_sides - PO1CT_minSpacing
        ;ypos = ypos + l - sourceWidth_sides - overSpace_1

        xpos = xpos - cl - l - CT_Size -  PO1CT_minSpacing
        ypos = ypos - cl + d - overSpace_1

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then ypos = ypos - CT_minSpacing - CT_Size)
                ;if(i == nc then xpos = xpos + PO1CT_minSpacing + CT_Size + sourceWidth_sides + overSpace_1 ypos = ypos - overSpace_2 - CT_Size - sourceWidth_sides - PO1CT_minSpacing)
                ;if(i == nc then xpos = xpos + PO1CT_minSpacing + CT_Size + l + 0.48 - d + overSpace_1 ypos = ypos - overSpace_1 - d)
                if(i == nc then xpos = xpos + PO1CT_minSpacing + l + cl - d + CT_Size + overSpace_1 ypos = ypos - overSpace_2 + d - cl - CT_Size - l - PO1CT_minSpacing)
            )

            if( i > nc && i <= 2*nc  then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                if(i <= 2*nc - 1 then xpos = xpos + CT_minSpacing + CT_Size)
                ;if(i == 2*nc then xpos = xpos + CT_Size + overSpace_2 + sourceWidth_sides + PO1CT_minSpacing ypos = ypos + CT_Size + PO1CT_minSpacing + sourceWidth_sides + overSpace_1) 
                if(i == 2*nc then xpos = xpos + overSpace_2 - d + cl + CT_Size + l + PO1CT_minSpacing ypos = ypos + PO1CT_minSpacing + l + cl - d + CT_Size + overSpace_1) 
            )

            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                if(i <= 3*nc - 1 then ypos = ypos + CT_minSpacing + CT_Size)
            )
        )

        xPO1CT_minSpacing = 0.15
        sourceWidth = sourceWidth - 0.16 - xPO1CT_minSpacing ; -> 0.15 = min cont to poly para cumprir DRC com a diagonal
        nc = round(sourceWidth/(CT_Size+CT_minSpacing))
        overSpace_1 = snapGrid((sourceWidth - (nc*CT_Size+(nc-1)*CT_minSpacing)) grid)
        /*if( overSpace_1 == 0.37 then
            nc = nc + 1
            overSpace_1 = snapGrid((sourceWidth - (nc*CT_Size+(nc-1)*CT_minSpacing)) grid)
        )*/

        ;xpos = xpos - PO1CT_minSpacing - sourceWidth_sides - snapGrid((overSpace_1/2) grid)

        xpos = xpos - PO1CT_minSpacing - l - cl + d - overSpace_1
        ypos = ypos + overSpace_2 + CT_Size - d + cl + l + PO1CT_minSpacing

        for( i 1 nc
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
            xpos = xpos - CT_minSpacing - CT_Size
        )
    )
)

procedure(designDrainViasDiagonal(cvId dint cl xpos ypos layer)   
    let( (nc spaceFilled spaceLeft overSpace overSpace_sides totalContacts)

        nc = car(getContacts(dint "drainVI1Diagonal"))
        overSpace = cadr(getContacts(dint "drainVI1Diagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)
        
        /*nc = round(((dint-VI1_diagonal)/(VI1_diagonal+VI1_minDiagonal)))
        spaceFilled = nc*VI1_diagonal+(nc-1)*VI1_minDiagonal
        spaceLeft = dint - spaceFilled
        overSpace = snapGrid((spaceLeft/2) grid)*/

        xpos = xpos - (VI1_Size/2) - overSpace_sides + 0.03
        ypos = ypos - (VI1_Size/2) - overSpace_sides - 0.025

        ;xpos = xpos - overSpace_sides
        ;ypos = ypos - overSpace_sides - 0.13

        totalContacts = 4*nc

        for( i 1 totalContacts 
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size)) 
                if(i <= nc - 1 then
                    xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if(i == nc then xpos = 0 - cl - (VI1_Size/2) + overSpace_sides + VI1_Size + 0.025 ypos = 0 - cl - dint + (VI1_Size/2) - overSpace_sides + 0.03) 
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size)) 
                if(i <= 2*nc - 1 then 
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if(i == 2*nc then xpos = 0 + dint - (VI1_Size/2) + overSpace_sides - 0.03 ypos = 0 - overSpace_sides - (VI1_Size/2) - 0.025)
            )
            if( i > 2*nc && i <= 3*nc then 
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                if(i <= 3*nc - 1 then 
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if(i == 3*nc then xpos = 0 + dint + cl - (VI1_Size/2) - overSpace_sides - VI1_Size - 0.025 ypos = 0 - dint - cl + (VI1_Size/2) - overSpace_sides + 0.03)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designDrainVias(cvId dint cl xpos ypos layer)   
    let( (nc overSpace_1 overSpace_2 totalContacts PO1VI1minSpacing)

        PO1VI1minSpacing = 0.08 
        nc = car(getContacts(dint "drainVI1"))
        overSpace_1 = cadr(getContacts(dint "drainVI1"))
        overSpace_2 = snapGrid((dint - (nc*VI1_Size+(nc-1)*VI1_Size) - overSpace_1) grid)

        totalContacts = 4*nc

        xpos = xpos + overSpace_1
        ypos = ypos - PO1VI1minSpacing

        for( i 1 totalContacts 
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size)) 
                if(i <= nc - 1 then xpos = xpos + 2*ME2_minSpacing)
                if(i == nc then xpos = xpos + overSpace_2 + cl - PO1VI1minSpacing  ypos = ypos - (cl-PO1VI1minSpacing) - overSpace_1) 
            )

            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size)) 
                if(i <= 2*nc - 1 then ypos = ypos - 2*ME2_minSpacing)
                if(i == 2*nc then xpos = xpos - cl - overSpace_1 + PO1VI1minSpacing ypos = ypos - cl - overSpace_2 + PO1VI1minSpacing)
            )

            if( i > 2*nc && i <= 3*nc then 
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                if(i <= 3*nc - 1 then xpos = xpos - 2*ME2_minSpacing)
                if(i == 3*nc then xpos = xpos - cl - overSpace_2 + PO1VI1minSpacing ypos = ypos + cl + overSpace_1 - PO1VI1minSpacing)
            )

            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                ypos = ypos + 2*ME2_minSpacing 
            )
        )
    )
)

procedure(designSourceViasDiagonal(cvId l cl dint d xpos ypos layer)
    let( (yPO1CT_minSpacing nc sourceWidth spaceFilled spaceLeft overSpace overSpace_sides totalContacts) 
       
        yPO1CT_minSpacing = 0.15
        sourceWidth = dint + 2*d

        nc = car(getContacts(sourceWidth "sourceVI1Diagonal"))
        overSpace = cadr(getContacts(sourceWidth "sourceVI1Diagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)

        xpos = xpos - d - VI1_Size - overSpace_sides - yPO1CT_minSpacing
        ypos = ypos + l - overSpace_sides + yPO1CT_minSpacing

        totalContacts = 4*nc

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                if(i <= nc - 1 then 
                    xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                ) 
                if(i == nc then xpos = 0 - cl - l + overSpace_sides - yPO1CT_minSpacing ypos = 0 - cl + d - sourceWidth - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                if( i <= 2*nc - 1 then 
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if( i == 2*nc then xpos = 0 + dint + d + overSpace_sides + yPO1CT_minSpacing ypos = 0 + l - overSpace_sides + yPO1CT_minSpacing) 
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                if( i <= 3*nc - 1 then
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if( i == 3*nc then xpos = 0 + dint + cl + l - VI1_Size - overSpace_sides + yPO1CT_minSpacing ypos = 0 - cl - dint - d - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designSourceVias(cvId l dint d sw xpos ypos layer)
    let( (xPO1VI1_minSpacing PO1VI1minSpacing sourceWidth nc overSpace_1 overSpace_2 totalContacts sourceWidth_sides) 
    
        PO1VI1minSpacing = 0.08 
        sourceWidth = dint + 2*d 
        sourceWidth_sides = snapGrid(sqrt(sourceWidth*sourceWidth/2) grid) 

        nc = car(getContacts(sourceWidth "sourceVI1"))
        overSpace_1 = cadr(getContacts(sourceWidth "sourceVI1"))
        overSpace_2 = snapGrid((sourceWidth - (nc*VI1_Size+(nc-1)*VI1_Size) - overSpace_1) grid)

        totalContacts = 4*nc

        xpos = xpos - d - sourceWidth_sides - VI1_Size - PO1VI1minSpacing
        ypos = ypos + l - sourceWidth_sides - overSpace_1

        for( i 1 totalContacts 
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                if(i <= nc - 1 then ypos = ypos - 2*ME2_minSpacing)
                if(i == nc then xpos = xpos + PO1VI1minSpacing + sourceWidth_sides + VI1_Size + overSpace_1 ypos = ypos - overSpace_2 - sourceWidth_sides - VI1_Size - PO1VI1minSpacing) 
            )

            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                if(i <= 2*nc - 1 then xpos = xpos + 2*ME2_minSpacing)
                if(i == 2*nc then xpos = xpos + overSpace_2 + sourceWidth_sides + VI1_Size + PO1VI1minSpacing ypos = ypos + PO1VI1minSpacing + sourceWidth_sides + VI1_Size + overSpace_1)
            )

            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                if(i <= 3*nc - 1 then ypos = ypos + 2*ME2_minSpacing )
            )
        )

        xPO1VI1_minSpacing = 0.025
        sourceWidth = sourceWidth - 0.16 - xPO1VI1_minSpacing - 0.05; -> dar nome a esta varivel
        nc = round(sourceWidth/(2*VI1_Size))
        overSpace = snapGrid((sourceWidth - (nc*VI1_Size+(nc-1)*VI1_Size)) grid)
        /*if( (nc*VI1_Size+(nc-1)*VI1_Size) > sourceWidth then
            nc = nc - 1
            overSpace = snapGrid((sourceWidth - (nc*VI1_Size+(nc-1)*VI1_Size)) grid)
        )*/

        xpos = xpos - sourceWidth_sides - ((sw - VI1_Size)/2) - VI1_Size - snapGrid((overSpace/2) grid)
        ypos = ypos + overSpace_2 + sourceWidth_sides + VI1_Size + ((sw - VI1_Size)/2)

        for( i 1 nc
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))  
            xpos = xpos - 2*ME2_minSpacing
        )
    )
)

procedure(getGRContacts(length height)
    let((minBoundarie ncLength ncHeight)
        minBoundarie = 2*CTDIFF_minSpacing
        ncLength = round((length/(CT_Size+CT_minSpacing)))
        missSpace = length - minBoundarie - (ncLength*CT_Size) - ((ncLength-1)*CT_minSpacing)
        if( missSpace <= 0 then
            appendSpace = 0 - missSpace
            length = length + appendSpace
        else
            appendSpace = CT_Size - (missSpace - CT_minSpacing)
            length = length + appendSpace
        )
        ncLength = round((length/(CT_Size+CT_minSpacing)))

        ncHeight = round((height/(CT_Size+CT_minSpacing)))
        missSpace = height - minBoundarie - (ncHeight*CT_Size) - ((ncHeight-1)*CT_minSpacing)
        if( missSpace <= 0 then
            appendSpace = 0 - missSpace
            height = height + appendSpace
        else
            appendSpace = CT_Size - (missSpace - CT_minSpacing)
            height = height + appendSpace
        )
        ncHeight = round((height/(CT_Size+CT_minSpacing)))
        list(length ncLength height ncHeight)
    )
)

procedure(designGRContacts(cv x y ncLength ncWidth)   
    let((ncTotal xpos ypos) 
        ncWidth = ncWidth - 2
        ncTotal = (2*ncLength) + (2*ncWidth)

        xpos = x + CTDIFF_minSpacing
        ypos = y - CTDIFF_minSpacing

        for( i 1 ncTotal - 1
            if( i <= ncLength then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i < ncLength then xpos = xpos + CT_minSpacing + CT_Size)
            )

            if( i >= ncLength && i < ncLength + ncWidth then
                if(i == ncLength then ypos = ypos - CT_minSpacing - CT_Size) 
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                ypos = ypos - CT_minSpacing - CT_Size
            )

            if( i >= ncLength + ncWidth && i < 2*ncLength + ncWidth then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                xpos = xpos - CT_minSpacing - CT_Size
            )

            if( i >= 2*ncLength + ncWidth then
                if(i == 2*ncLength + ncWidth then xpos = xpos + CT_minSpacing + CT_Size ypos = ypos + CT_minSpacing + CT_Size)
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                ypos = ypos + CT_minSpacing + CT_Size
            )
        )
    )
)

procedure(CreateGR(cv xpos ypos NPLUS_Length NPLUS_Height mosType)
    let((DIFF_Length DIFF_Height DIFF_Width ncLength ncWidth PPLUS_Length PPLUS_Height PPLUSNPLUS_LengthSpacing PPLUSNPLUS_HeightSpacing) 
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
        ;; Creation of outer PPLUS
        ;dbCreateRect(cv list("PPLUS" "drawing") list((xpos-DIFFPPLUS_Spacing:ypos+DIFFPPLUS_Spacing) (xpos+DIFF_Length+DIFFPPLUS_Spacing:ypos-DIFF_Height-DIFFPPLUS_Spacing)))

        ;; Creation of inner PPLUS
        ;dbCreateRect(cv list("PPLUS" "drawing") list((xpos+DIFFPPLUS_Spacing+DIFF_Width:ypos-DIFFPPLUS_Spacing-DIFF_Width) (xpos+DIFF_Length-DIFFPPLUS_Spacing-DIFF_Width:ypos-DIFF_Height+DIFF_Width+DIFFPPLUS_Spacing)))

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

procedure(designGRContacts_V2(cv xpos ypos DIFF_Length)   
    let((nc spaceLeft overSpace_1 overSpace_2 totalContacts) 

        nc = round((DIFF_Length/(CT_Size+CT_minSpacing)))
        spaceLeft = DIFF_Length - ((nc*CT_Size) + ((nc-1)*CT_minSpacing))
        overSpace_1 = snapGrid((spaceLeft/2) grid)
        overSpace_2 = snapGrid((DIFF_Length - (nc*CT_Size+(nc-1)*CT_minSpacing)-overSpace_1) grid)

        xpos = xpos - DIFFPPLUS_Spacing + overSpace_1
        ypos = ypos + DIFFPPLUS_Spacing + CTDIFF_minSpacing + CT_Size

        totalContacts = 4*nc

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i < nc then xpos = xpos + CT_minSpacing + CT_Size)
                if(i == nc then xpos = xpos + GR_Diagonal_sides + overSpace_2 + CTDIFF_minSpacing + CT_Size ypos = ypos - GR_Diagonal_sides - CT_Size - CTDIFF_minSpacing - overSpace_1)
            )

            if( i > nc && i <= 2*nc then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= 2*nc - 1 then  ypos = ypos - CT_minSpacing - CT_Size)
                if(i == 2*nc then xpos = xpos - CTDIFF_minSpacing - CT_Size - GR_Diagonal_sides - overSpace_1 ypos = ypos - GR_Diagonal_sides - overSpace_2 - CT_Size - CTDIFF_minSpacing)          
            )

            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= 3*nc - 1 then xpos = xpos - CT_minSpacing - CT_Size)
                if(i == 3*nc then xpos = xpos - overSpace_2 - GR_Diagonal_sides - CT_Size - CTDIFF_minSpacing ypos = ypos + CTDIFF_minSpacing + CT_Size + GR_Diagonal_sides + overSpace_1)
            )

            if( i > 3*nc then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                ypos = ypos + CT_minSpacing + CT_Size
            )
        )
    )
)

procedure(designGRContactsDiagonal_V2(cv xpos ypos diagonalSize dint cl sw d xPO1DIFF_Spacing DIFFNPLUS_minSpacing DIFFPPLUS_Spacing NPLUSPPLUS_Spacing)   
    let((nc spaceFilled spaceLeft overSpace totalContacts) 

        nc = round(diagonalSize/(CT_diagonal+CT_minDiagonal))
        spaceFilled = nc*CT_diagonal+(nc-1)*CT_minDiagonal
        spaceLeft = diagonalSize - spaceFilled
        overSpace = snapGrid((spaceLeft/2) grid) 
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)

        xpos = xpos - 0.14 - overSpace_sides - CT_Size
        ypos = ypos + DIFFPPLUS_Spacing + 0.14 - overSpace_sides

        totalContacts = 4*nc

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then 
                    xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == nc then 
                    xpos = 0 - cl - l - sw - NPLUSPPLUS_Spacing - DIFFPPLUS_Spacing - 0.14 + overSpace_sides ypos = 0 - cl - dint - d - xPO1DIFF_Spacing - DIFFNPLUS_minSpacing - NPLUSPPLUS_Spacing - DIFFPPLUS_Spacing - 0.14 - overSpace_sides  
                ) 
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= 2*nc - 1 then 
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == 2*nc then xpos = 0 + dint + cl + l + sw + DIFFNPLUS_minSpacing + NPLUSPPLUS_Spacing + DIFFPPLUS_Spacing + 0.14 - overSpace_sides  ypos = 0 - cl - dint - d - xPO1DIFF_Spacing - DIFFNPLUS_minSpacing - NPLUSPPLUS_Spacing - DIFFPPLUS_Spacing - 0.14 - overSpace_sides)
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cv list("CONT" "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= 3*nc - 1 then
                    xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == 3*nc then xpos = 0 + dint + d + xPO1DIFF_Spacing + DIFFNPLUS_minSpacing + NPLUSPPLUS_Spacing + DIFFPPLUS_Spacing + 0.14 + overSpace_sides ypos = 0 + l + sw + DIFFNPLUS_minSpacing + NPLUSPPLUS_Spacing + DIFFPPLUS_Spacing + 0.14 - overSpace_sides)
            )
            if( i > 3*nc then
                dbCreateRect(cv list("CONT"  "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
            )
        )
    )
)


procedure(CreateGR_V2(cv xpos ypos PPLUS_Length DIFF_Length mosType GR_Diagonal_sides)
    let((DIFF_Width)
        DIFF_Width = CT_Size+2*CTDIFF_minSpacing

        if(mosType == "n" then
            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos+PPLUS_Length+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos+PPLUS_Length:ypos)))

            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides:ypos-GR_Diagonal_sides)))

            xpos = xpos - GR_Diagonal_sides
            ypos = ypos - GR_Diagonal_sides

            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-PPLUS_Length-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos:ypos-PPLUS_Length)))
            
            ypos = ypos - PPLUS_Length
            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides:ypos-GR_Diagonal_sides)))

            xpos = xpos + GR_Diagonal_sides
            ypos = ypos - GR_Diagonal_sides
            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+PPLUS_Length+2*DIFFPPLUS_Spacing+DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+PPLUS_Length:ypos)))
            
            xpos = xpos + PPLUS_Length
            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides:ypos+GR_Diagonal_sides)))

            xpos = xpos + GR_Diagonal_sides
            ypos = ypos + GR_Diagonal_sides
            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+PPLUS_Length+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos:ypos+PPLUS_Length)))

            ypos = ypos + PPLUS_Length
            dbCreatePolygon(cv list("PPLUS" "drawing") list((xpos:ypos) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides:ypos+GR_Diagonal_sides)))
        else            
            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos+PPLUS_Length+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos+PPLUS_Length:ypos)))

            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides:ypos-GR_Diagonal_sides)))

            xpos = xpos - GR_Diagonal_sides
            ypos = ypos - GR_Diagonal_sides

            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-PPLUS_Length-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos:ypos-PPLUS_Length)))
            
            ypos = ypos - PPLUS_Length
            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides:ypos-GR_Diagonal_sides)))

            xpos = xpos + GR_Diagonal_sides
            ypos = ypos - GR_Diagonal_sides
            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos-2*DIFFPPLUS_Spacing-DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+PPLUS_Length+2*DIFFPPLUS_Spacing+DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+PPLUS_Length:ypos)))
            
            xpos = xpos + PPLUS_Length
            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+GR_Diagonal_sides-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+GR_Diagonal_sides:ypos+GR_Diagonal_sides)))

            xpos = xpos + GR_Diagonal_sides
            ypos = ypos + GR_Diagonal_sides
            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos-2*DIFFPPLUS_Spacing-DIFF_Width) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+PPLUS_Length+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos:ypos+PPLUS_Length)))

            ypos = ypos + PPLUS_Length
            dbCreatePolygon(cv list("NPLUS" "drawing") list((xpos:ypos) (xpos+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width:ypos+GR_Diagonal_sides+2*DIFFPPLUS_Spacing+DIFF_Width) (xpos-GR_Diagonal_sides:ypos+GR_Diagonal_sides)))
        )


        ;; Create Diffusion GuardRing
        xpos = xpos - GR_Diagonal_sides - PPLUS_Length - DIFFPPLUS_Spacing
        ypos = ypos + GR_Diagonal_sides + DIFFPPLUS_Spacing

        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos+DIFF_Width) (xpos+DIFF_Length+DIFF_Width:ypos+DIFF_Width) (xpos+DIFF_Length:ypos)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos+DIFF_Width) (xpos+DIFF_Length+DIFF_Width:ypos+DIFF_Width) (xpos+DIFF_Length:ypos)))

        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos+DIFF_Width) (xpos-GR_Diagonal_sides-DIFF_Width:ypos-GR_Diagonal_sides+DIFF_Width) (xpos-GR_Diagonal_sides:ypos-GR_Diagonal_sides)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos+DIFF_Width) (xpos-GR_Diagonal_sides-DIFF_Width:ypos-GR_Diagonal_sides+DIFF_Width) (xpos-GR_Diagonal_sides:ypos-GR_Diagonal_sides)))

        xpos = xpos - GR_Diagonal_sides
        ypos = ypos - GR_Diagonal_sides
        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos+DIFF_Width) (xpos-DIFF_Width:ypos-DIFF_Length-DIFF_Width) (xpos:ypos-DIFF_Length)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos+DIFF_Width) (xpos-DIFF_Width:ypos-DIFF_Length-DIFF_Width) (xpos:ypos-DIFF_Length)))

        ypos = ypos - DIFF_Length
        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos-DIFF_Width) (xpos+GR_Diagonal_sides-DIFF_Width:ypos-GR_Diagonal_sides-DIFF_Width) (xpos+GR_Diagonal_sides:ypos-GR_Diagonal_sides)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos-DIFF_Width) (xpos+GR_Diagonal_sides-DIFF_Width:ypos-GR_Diagonal_sides-DIFF_Width) (xpos+GR_Diagonal_sides:ypos-GR_Diagonal_sides)))

        xpos = xpos + GR_Diagonal_sides
        ypos = ypos - GR_Diagonal_sides
        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos-DIFF_Width) (xpos+DIFF_Length+DIFF_Width:ypos-DIFF_Width) (xpos+DIFF_Length:ypos)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos-DIFF_Width:ypos-DIFF_Width) (xpos+DIFF_Length+DIFF_Width:ypos-DIFF_Width) (xpos+DIFF_Length:ypos)))

        xpos = xpos + DIFF_Length
        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos+DIFF_Width:ypos-DIFF_Width) (xpos+GR_Diagonal_sides+DIFF_Width:ypos+GR_Diagonal_sides-DIFF_Width) (xpos+GR_Diagonal_sides:ypos+GR_Diagonal_sides)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos+DIFF_Width:ypos-DIFF_Width) (xpos+GR_Diagonal_sides+DIFF_Width:ypos+GR_Diagonal_sides-DIFF_Width) (xpos+GR_Diagonal_sides:ypos+GR_Diagonal_sides)))

        xpos = xpos + GR_Diagonal_sides
        ypos = ypos + GR_Diagonal_sides
        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos+DIFF_Width:ypos-DIFF_Width) (xpos+DIFF_Width:ypos+DIFF_Length+DIFF_Width) (xpos:ypos+DIFF_Length)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos+DIFF_Width:ypos-DIFF_Width) (xpos+DIFF_Width:ypos+DIFF_Length+DIFF_Width) (xpos:ypos+DIFF_Length)))

        ypos = ypos + DIFF_Length
        dbCreatePolygon(cv list("DIFF" "drawing") list((xpos:ypos) (xpos+DIFF_Width:ypos+DIFF_Width) (xpos-GR_Diagonal_sides+DIFF_Width:ypos+GR_Diagonal_sides+DIFF_Width) (xpos-GR_Diagonal_sides:ypos+GR_Diagonal_sides)))
        dbCreatePolygon(cv list("ME1" "drawing") list((xpos:ypos) (xpos+DIFF_Width:ypos+DIFF_Width) (xpos-GR_Diagonal_sides+DIFF_Width:ypos+GR_Diagonal_sides+DIFF_Width) (xpos-GR_Diagonal_sides:ypos+GR_Diagonal_sides)))
    )
)
