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
    let( (w l dl d cl alfa str) 
        w = cdfParseFloatString(cdfgData->w->value)*1e6
        l = cdfParseFloatString(cdfgData->l->value)*1e6
        dl = cdfParseFloatString(cdfgData->dl->value)*1e6
        d = cdfParseFloatString(cdfgData->d->value)*1e6

        alfa = 1.1780972451
        d = (w/8) - (l/tan(alfa))
        cl = snapGrid(sqrt(d*d/2) grid)

        d = snapGrid((round(d*1000.0)/1000.0) grid) 
        sprintf(str "%gu" d)
        cdfgData->d->value = str

        alfa = (22.5/180)*3.14
        dl = tan(alfa)*l
        dl = snapGrid((round(dl*1000.0)/1000.0) grid)

        dl = snapGrid((round(dl*1000.0)/1000.0) grid)
        w = snapGrid((round(w*1000.0)/1000.0) grid)

        sprintf(str "%gu" dl)
        cdfgData->dl->value = str

        sprintf(str "%gu" w)
        cdfgData->w->value = str

        /*if( l < 0.36 then
            sprintf(str "%gu" 0.36)
            cdfgData->l->value = str
            l = cdfParseFloatString(cdfgData->l->value)*1e6
            sprintf(str "%gu" 1.465)
            cdfgData->d->value = str
            d = cdfParseFloatString(cdfgData->d->value)*1e6
            sprintf(str "%gu" 1.035)
        )
        if( w < 6 then
            sprintf(str "%gu" 6)
            cdfgData->w->value = str
            w = cdfParseFloatString(cdfgData->w->value)*1e6
            sprintf(str "%gu" 1.465)
            cdfgData->d->value = str
            d = cdfParseFloatString(cdfgData->d->value)*1e6
            sprintf(str "%gu" 1.035)
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

procedure(designLabels(xpos ypos cellviewId layer l dl cl sl)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(dl/2):ypos-(dl/2) "D" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(dl/2):ypos+l+(sl/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+(dl/2):ypos-dl-2*cl-l-(sl/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos+dl+cl+l+(sl/2):ypos-(dl/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos-cl-l-(sl/2):ypos-(dl/2) "S" "centerCenter" "R0" "stick" 0.25)
    dbCreateLabel(cellviewId list(layer "drawing") xpos-cl-(l/2):ypos+l+sl+0.18+(0.32/2) "G" "centerCenter" "R0" "stick" 0.25)
)

procedure(designGateContacts(cvId x y l sl layer)
    let((tf viaDef viaParams newVia gatePinWidth)
        tf=techGetTechFile(cvId)
        viaDef=techFindViaDefByName(tf layer)

        if( layer == "M1_POLY" then
            gatePinWidth = snapGrid((2*PO1CT_enclosure+CT_minSpacing+2*CT_Size) grid) 
            viaParams = list(list("cutRows" 1) list("cutColumns" 2))
            newVia = dbCreateVia(cvId viaDef list(snapGrid((x-dl-((gatePinWidth-0.16)/2)+(gatePinWidth/2)) grid) y+l+sl+PO1DIFF_minSpacing+((CT_Size+2*PO1CT_enclosure)/2)) "R0" viaParams) 
        else
            gatePinWidth = snapGrid((2*VI1ME1_minSpacing+VI1_minSpacing+2*VI1_Size) grid) 
            viaParams = list(list("cutRows" 1) list("cutColumns" 2))
            newVia = dbCreateVia(cvId viaDef list(snapGrid((x-dl-((gatePinWidth-0.16)/2)+(gatePinWidth/2)) grid) y+l+sl+PO1DIFF_minSpacing+((VI1_Size+2*VI1ME1_minSpacing)/2)) "R0" viaParams) 
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
            spaceLeft = d - spaceFilled
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

procedure(designDrainContactsDiagonal(cvId xpos ypos d cl layer)   
    let( (yPO1CT_minSpacing nc overSpace overSpace_sides totalContacts)

        yPO1CT_minSpacing = 0.17
        nc = car(getContacts(d "drainDiagonal"))
        overSpace = cadr(getContacts(d "drainDiagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)

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
                if(i == nc then xpos = 0 - cl + CT_Size + overSpace_sides + yPO1CT_minSpacing ypos = 0 - cl - d  + CT_Size - overSpace_sides) 
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= 2*nc - 1 then 
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == 2*nc then xpos = 0 + d + overSpace_sides  ypos = 0 - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
                if(i <= 3*nc - 1 then
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if(i == 3*nc then xpos = 0 + d + cl - overSpace_sides - CT_Size - yPO1CT_minSpacing  ypos = 0 - d - cl - overSpace_sides + CT_Size)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designDrainContacts(cvId xpos ypos d cl layer)   
    let( (nc overSpace_1 overSpace_2 totalContacts)

        nc = car(getContacts(d "drainHorizontal"))
        overSpace_1 = cadr(getContacts(d "drainHorizontal"))
        overSpace_2 = snapGrid((d - (nc*CT_Size+(nc-1)*CT_minSpacing)-overSpace_1) grid)

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

procedure(designSourceContactsDiagonal(cvId l d dl cl xpos ypos layer)
    let((yPO1CT_minSpacing nc spaceFilled spaceLeft overSpace overSpace_sides totalContacts)

        yPO1CT_minSpacing = 0.165
        sourceWidth = d+2*dl

        nc = car(getContacts(sourceWidth "sourceDiagonal"))
        overSpace = cadr(getContacts(sourceWidth "sourceDiagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)

        xpos = xpos - dl - CT_Size - overSpace_sides - yPO1CT_minSpacing
        ypos = ypos + l - overSpace_sides + yPO1CT_minSpacing

        totalContacts = 4*nc

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then 
                    xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                ) 
                if(i == nc then xpos = 0 - cl - l + overSpace_sides - yPO1CT_minSpacing  ypos = 0 - cl - d - dl - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if( i <= 2*nc - 1 then 
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if( i == 2*nc then xpos = 0 + d + dl + overSpace_sides + yPO1CT_minSpacing ypos = 0 + l - overSpace_sides + yPO1CT_minSpacing) 
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if( i <= 3*nc - 1 then
                    xpos = xpos + CT_Size + snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                    ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                )
                if( i == 3*nc then xpos = 0 + d + cl + l - CT_Size - overSpace_sides + yPO1CT_minSpacing ypos = 0 - cl - d - dl - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                xpos = xpos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
                ypos = ypos - CT_Size - snapGrid(sqrt((CT_minDiagonal*CT_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designSourceContacts(cvId l d dl cl xpos ypos layer)
    let((xPO1CT_minSpacing sourceWidth nc totalContacts sourceWidth_sides overSpace_1 overSpace_2)   

        sourceWidth = d+2*dl
        sourceWidth_sides = sqrt(sourceWidth*sourceWidth/2)

        nc = car(getContacts(sourceWidth "sourceHorizontal"))
        overSpace_1 = cadr(getContacts(sourceWidth "sourceHorizontal"))
        overSpace_2 = snapGrid((sourceWidth - (nc*CT_Size+(nc-1)*CT_minSpacing)-overSpace_1) grid)

        totalContacts = 4*nc

        xpos = xpos - cl - l - CT_Size -  PO1CT_minSpacing
        ypos = ypos - cl + dl - overSpace_1

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))
                if(i <= nc - 1 then ypos = ypos - CT_minSpacing - CT_Size)
                if(i == nc then xpos = xpos + PO1CT_minSpacing + l + cl - dl + CT_Size + overSpace_1 ypos = ypos - overSpace_2 + dl - cl - CT_Size - l - PO1CT_minSpacing)
            )

            if( i > nc && i <= 2*nc  then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+CT_Size:ypos-CT_Size))  
                if(i <= 2*nc - 1 then xpos = xpos + CT_minSpacing + CT_Size)
                if(i == 2*nc then xpos = xpos + overSpace_2 - dl + cl + CT_Size + l + PO1CT_minSpacing ypos = ypos + PO1CT_minSpacing + l + cl - dl + CT_Size + overSpace_1) 
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

        xpos = xpos - PO1CT_minSpacing - l - cl + dl - overSpace_1
        ypos = ypos + overSpace_2 + CT_Size - dl + cl + l + PO1CT_minSpacing

        for( i 1 nc
            dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos-CT_Size:ypos-CT_Size))
            xpos = xpos - CT_minSpacing - CT_Size
        )
    )
)

procedure(designDrainViasDiagonal(cvId d cl xpos ypos layer)   
    let( (nc spaceFilled spaceLeft overSpace overSpace_sides totalContacts)

        nc = car(getContacts(d "drainVI1Diagonal"))
        overSpace = cadr(getContacts(d "drainVI1Diagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)

        xpos = xpos - (VI1_Size/2) - overSpace_sides + 0.03
        ypos = ypos - (VI1_Size/2) - overSpace_sides - 0.025

        totalContacts = 4*nc

        for( i 1 totalContacts 
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size)) 
                if(i <= nc - 1 then
                    xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if(i == nc then xpos = 0 - cl - (VI1_Size/2) + overSpace_sides + VI1_Size + 0.025 ypos = 0 - cl - d + (VI1_Size/2) - overSpace_sides + 0.03) 
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size)) 
                if(i <= 2*nc - 1 then 
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if(i == 2*nc then xpos = 0 + d - (VI1_Size/2) + overSpace_sides - 0.03 ypos = 0 - overSpace_sides - (VI1_Size/2) - 0.025)
            )
            if( i > 2*nc && i <= 3*nc then 
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                if(i <= 3*nc - 1 then 
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if(i == 3*nc then xpos = 0 + d + cl - (VI1_Size/2) - overSpace_sides - VI1_Size - 0.025 ypos = 0 - d - cl + (VI1_Size/2) - overSpace_sides + 0.03)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))   
                xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designDrainVias(cvId d cl xpos ypos layer)   
    let( (nc overSpace_1 overSpace_2 totalContacts PO1VI1minSpacing)

        PO1VI1minSpacing = 0.08 
        nc = car(getContacts(d "drainVI1"))
        overSpace_1 = cadr(getContacts(d "drainVI1"))
        overSpace_2 = snapGrid((d - (nc*VI1_Size+(nc-1)*VI1_Size) - overSpace_1) grid)

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

procedure(designSourceViasDiagonal(cvId l cl d dl xpos ypos layer)
    let( (yPO1CT_minSpacing nc sourceWidth spaceFilled spaceLeft overSpace overSpace_sides totalContacts) 
       
        yPO1CT_minSpacing = 0.15
        sourceWidth = d + 2*dl

        nc = car(getContacts(sourceWidth "sourceVI1Diagonal"))
        overSpace = cadr(getContacts(sourceWidth "sourceVI1Diagonal"))
        overSpace_sides = snapGrid(sqrt((overSpace*overSpace)/2) grid)

        xpos = xpos - dl - VI1_Size - overSpace_sides - yPO1CT_minSpacing
        ypos = ypos + l - overSpace_sides + yPO1CT_minSpacing

        totalContacts = 4*nc

        for( i 1 totalContacts
            if( i <= nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                if(i <= nc - 1 then 
                    xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                ) 
                if(i == nc then xpos = 0 - cl - l + overSpace_sides - yPO1CT_minSpacing ypos = 0 - cl + dl - sourceWidth - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > nc && i <= 2*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                if( i <= 2*nc - 1 then 
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if( i == 2*nc then xpos = 0 + d + dl + overSpace_sides + yPO1CT_minSpacing ypos = 0 + l - overSpace_sides + yPO1CT_minSpacing) 
            )
            if( i > 2*nc && i <= 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                if( i <= 3*nc - 1 then
                    xpos = xpos + VI1_Size + snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                    ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                )
                if( i == 3*nc then xpos = 0 + d + cl + l - VI1_Size - overSpace_sides + yPO1CT_minSpacing ypos = 0 - cl - d - dl - overSpace_sides - yPO1CT_minSpacing)
            )
            if( i > 3*nc then
                dbCreateRect(cvId list(layer "drawing") list(xpos:ypos xpos+VI1_Size:ypos-VI1_Size))
                xpos = xpos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
                ypos = ypos - VI1_Size - snapGrid(sqrt((VI1_minDiagonal*VI1_minDiagonal)/2) grid)
            )
        )
    )
)

procedure(designSourceVias(cvId l d dl sl xpos ypos layer)
    let( (xPO1VI1_minSpacing PO1VI1minSpacing sourceWidth nc overSpace_1 overSpace_2 totalContacts sourceWidth_sides) 
    
        PO1VI1minSpacing = 0.08 
        sourceWidth = d + 2*dl 
        sourceWidth_sides = snapGrid(sqrt(sourceWidth*sourceWidth/2) grid) 

        nc = car(getContacts(sourceWidth "sourceVI1"))
        overSpace_1 = cadr(getContacts(sourceWidth "sourceVI1"))
        overSpace_2 = snapGrid((sourceWidth - (nc*VI1_Size+(nc-1)*VI1_Size) - overSpace_1) grid)

        totalContacts = 4*nc

        xpos = xpos - dl - sourceWidth_sides - VI1_Size - PO1VI1minSpacing
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

        xpos = xpos - sourceWidth_sides - ((sl - VI1_Size)/2) - VI1_Size - snapGrid((overSpace/2) grid)
        ypos = ypos + overSpace_2 + sourceWidth_sides + VI1_Size + ((sl - VI1_Size)/2)

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

        DIFF_Height = NPLUS_Height + 2*DIFF_Width + 4*DIFFPPLUS_Spacing

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