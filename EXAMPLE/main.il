procedure(abConvertRefToAttach(libName attachLibName)
    let( (libId)
        libId = ddGetObj(libName)
        techBindTechFile(libId attachLibName)
    )
)

procedure(init(libName attachLibName)
    let( (cellId cdfId port) 

        load("./SKILL/EXAMPLE/main.il")
        
        dbCreateLib(libName)
        abConvertRefToAttach(libName attachLibName)

        ;; Create transistor nELT
        cellName = "example"
        ELTdefinePC(libName cellName)
        cellId = ddGetObj(libName cellName)
        ;; if the cell CDF already exists, delete it
        when( cdfId = cdfGetBaseCellCDF(cellId)
            cdfDeleteCDF(cdfId)
        )
        ;; create the base cell CDF
        cdfId = cdfCreateBaseCellCDF(cellId)
        load("./SKILL/EXAMPLE/CDF.il")
        CreateSymbol(libName cellName)

        port = outfile("./radiationLib/libInit.il" "w")
        fprintf(port "load(\"./SKILL/EXAMPLE/main.il\")")
        close(port)
    )
)

procedure(snapGrid(size grid)
    size = round(size/grid)*grid
)

procedure(CreateSymbol(libName cellName)
    let((cvId)

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

    schCreateSymbolLabel(cvId 0.645:0.035 "analog pin annotate" "cdsTerm(\"B\")" "lowerRight" "R0" 
    "stick" 0.05 "ILLabel")
    schCreateSymbolLabel(cvId 0.095:0.035 "analog pin annotate" "cdsTerm(\"G\")" "lowerRight" "R0" 
    "stick" 0.05 "ILLabel")

    schCreateSymbolShape(cvId "line" "solid" list(0.1875:-0.0625 0.25:-0.09375 0.1875:-0.125)) 
    schCreateSymbolPin(cvId instSympin "D" "inputOutput" 0.25:0.1875 "R0")
    schCreateSymbolPin(cvId instSympin "S" "inputOutput" 0.25:-0.1875 "R0")
    schCreateSymbolLabel(cvId 0.22:0.125 "analog pin annotate" "cdsTerm(\"D\")" "lowerRight" 
    "R0" "stick" 0.05 "ILLabel")      
    schCreateSymbolLabel(cvId 0.22:-0.18 "analog pin annotate" "cdsTerm(\"S\")" "lowerRight" 
    "R0" "stick" 0.05 "ILLabel")

    Create_auCdl(cvId libName cellName)
    Create_spectre(cvId libName cellName)
    )
)

cvId = pcDefinePCell(list(ddGetObj("radiationLib") "example" "layout" "maskLayout")
    ;; default parameters setup.
    (
        (model "example")
        (d "string" "1.115u") 
        (l "string" "0.36u")
        (h "string" "0.1u")
        (sl "string" "0.36u")
    )
    let((x y net pinFig spaceLeft nc nc_v)
        x = 0
        y = 0
        d = cdfParseFloatString(d)*1e6
        l = cdfParseFloatString(l)*1e6
        h = cdfParseFloatString(h)*1e6
        sl = cdfParseFloatString(sl)*1e6

        /* Actual body of pcell code */
        x = 0 /* Init the x coordinate variable */
        y = 0 /* Init the y coordinate variable */
        
        /* Use of the internal variable "pcCellView" */
        dbCreatePolygon(pcCellView list("DIFF" "drawing") list((x:y) (x+d:y) (x+d+h:y-h) (x+d+h:y-h-d) (x+d:y-2*h-d) (x:y-2*h-d) (x-h:y-h-d) (x-h:y-h)))
        
        pinFig = dbCreatePolygon(pcCellView list("ME1" "drawing") list((x:y) (x+d:y) (x+d+h:y-h) (x+d+h:y-h-d) (x+d:y-2*h-d) (x:y-2*h-d) (x-h:y-h-d) (x-h:y-h)))
        
        /* Create net with name D */
        D = dbCreateNet(pcCellView "D")

        /* Create a terminal associated with the net D */
        dbCreateTerm(D "" "input")

        /* Create the pin with name Drain and shape pinFig */
        dbCreatePin(D pinFig "Drain")  

        /* Design the gate pin in PO1 */
        dbCreatePolygon(pcCellView list("PO1" "drawing") list((x-h:y-h) (x-h:y-d-h) (x:y-d-2*h) (x+d:y-d-2*h) (x+d+h:y-d-h) (x+d+h:y-h) (x+d:y) (x-h-l:y) (x-h-l:y+l+sl+0.18) (x-h:y+l+sl+0.18) 
        (x-h:y+h+l) (x:y+l) (x+d+l:y+l) (x+d+l+h:y-(h-l)) (x+d+h+l:y-d-h-l) (x+d+l:y-d-2*h-l) (x-l:y-d-2*h-l) (x-h-l:y-d-h-l) (x-h-l:y) (x:y)))
        
        /* Get the technology file id */
        tf=techGetTechFile(pcCellView)
        
        /* Get the contact "M1 POLY" from the technology file. */
        viaDef=techFindViaDefByName(tf "M1_POLY")
        /* The size of the array to be designed */
        viaParams = list(list("cutRows" 1) list("cutColumns" 2))
        
        /* Design the array via using dbCreateVia database function */
        dbCreateVia(pcCellView viaDef list(x-h-(l/2) y+l+sl+0.18+
        ((2*0.06+0.16)/2)) "R0" viaParams)
        
        /* Design the source diffusion layer */
        dbCreateRect(pcCellView list("DIFF" "drawing") list((x-h-l-sl:y+l+sl)
        (x+d+h+l+sl:y-2*h-d-l-sl)))
                
        /*net = dbCreateNet(pcCellView "G")
        dbCreateTerm(net "" "input")
        dbCreatePin(net pinFig "Gate")*/

        nc = round((d/(0.16+0.2)))
        spaceleft = d - ((nc*0.16) + ((nc-1)*0.2))
        overSpace = snapGrid((spaceleft/2) grid)

        nc_v = nc - 2  
        totalC = 2*nc + 2*nc_v
        
        x = x + overSpace  
        y = y - h - overSpace

        for( i 1 totalC 
            if( i <= nc then
                dbCreateRect(pcCellView list("CONT" "drawing") list(x:y x+0.16:y-0.16))
                if(i <= nc - 1 then x = x + 0.2 + 0.16)
            )
            if( i > nc && i <= nc + nc_v then
                y = y - 0.2 - 0.16 
                dbCreateRect(pcCellView list("CONT" "drawing") list(x:y x+0.16:y-0.16)) 
                if(i == nc + nc_v then y = y - 0.2 - 0.16)
            )
            if( i > nc + nc_v && i <= 2*nc + nc_v then 
                dbCreateRect(pcCellView list("CONT" "drawing") list(x:y x+0.16:y-0.16))  
                if(i > nc + nc_v && i < 2*nc + nc_v then x = x - 0.2 - 0.16)
            )
            if( i > 2*nc + nc_v then
                y = y + 0.2 + 0.16
                dbCreateRect(pcCellView list("CONT" "drawing") list(x:y x+0.16:y-0.16))  
            )
        )
        CreateSymbol("radiationLib" "example")
    )
)


