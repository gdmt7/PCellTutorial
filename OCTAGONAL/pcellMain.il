procedure(abConvertRefToAttach(libName attachLibName)
    (let (libId)
        libId = ddGetObj(libName)
        techBindTechFile(libId attachLibName)
    )
)

procedure(init(libName attachLibName)
    let( (cellId cdfId port path) 

        load("./SKILL/OCTAGONAL/pcellUtils.il")
        load("./SKILL/OCTAGONAL/ELTpcell.il")
        
        dbCreateLib(libName)
        abConvertRefToAttach(libName attachLibName)

        ;; Create transistor nELT
        cellName = "N_12_HSL130E"
        ELTdefinePC(libName cellName)
        cellId = ddGetObj(libName cellName)
        ;; if the cell CDF already exists, delete it
        when( cdfId = cdfGetBaseCellCDF(cellId)
            cdfDeleteCDF(cdfId)
        )
        ;; create the base cell CDF
        cdfId = cdfCreateBaseCellCDF(cellId)
        load("./SKILL/OCTAGONAL/nCDF.il")
        CreateSymbol(libName cellName)

        ;; Create transistor pELT
        cellName = "P_12_HSL130E"
        ELTdefinePC(libName cellName)
        cellId = ddGetObj(libName cellName)
        ;; if the cell CDF already exists, delete it
        when( cdfId = cdfGetBaseCellCDF(cellId)
            cdfDeleteCDF(cdfId)
        )
        ;; create the base cell CDF
        cdfId = cdfCreateBaseCellCDF(cellId)
        load("./SKILL/OCTAGONAL/pCDF.il")
        CreateSymbol(libName cellName)

        port = outfile("./radiationLib/libInit.il" "w")
        fprintf(port "load(\"./SKILL/OCTAGONAL/ELTpcell.il\")")
        close(port)
    )
)

/*let( (libName cellName)
    ;; Load files
    load("./SKILL/OCTAGONAL/pcellUtils.il")
    load("./SKILL/OCTAGON/ELTpcell.il")
    libName = "radiationLib"
    
    ;; Create transistor nELT
    cellName = "N_12_HSL130E"
    ELTdefinePC(libName cellName)
    load("./SKILL/OCTAGONAL/nCDF.il")
    CreateSymbol(libName cellName)

    ;; Create transistor pELT
    cellName = "P_12_HSL130E"
    ELTdefinePC(libName cellName)
    load("./SKILL/OCTAGONAL/pCDF.il")
    CreateSymbol(libName cellName)
)*/
