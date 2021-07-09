procedure(abConvertRefToAttach(libName attachLibName)
    (let (libId)
        libId = ddGetObj(libName)
        techBindTechFile(libId attachLibName)
    )
)

procedure(init(libName attachLibName)
    let( (cellId cdfId port path) 

        load("./SKILL/RECTANGULAR/pcellUtils.il")
        load("./SKILL/RECTANGULAR/ELTpcell.il")
        
        dbCreateLib(libName)
        abConvertRefToAttach(libName attachLibName)

        ;; Create transistor nELT
        cellName = "N_ELT"
        ELTdefinePC(libName cellName)
        cellId = ddGetObj(libName cellName)
        ;; if the cell CDF already exists, delete it
        when( cdfId = cdfGetBaseCellCDF(cellId)
            cdfDeleteCDF(cdfId)
        )
        ;; create the base cell CDF
        cdfId = cdfCreateBaseCellCDF(cellId)
        load("./SKILL/RECTANGULAR/nCDF.il")
        CreateSymbol(libName cellName)

        ;; Create transistor pELT
        cellName = "P_ELT"
        ELTdefinePC(libName cellName)
        cellId = ddGetObj(libName cellName)
        ;; if the cell CDF already exists, delete it
        when( cdfId = cdfGetBaseCellCDF(cellId)
            cdfDeleteCDF(cdfId)
        )
        ;; create the base cell CDF
        cdfId = cdfCreateBaseCellCDF(cellId)
        load("./SKILL/RECTANGULAR/pCDF.il")
        CreateSymbol(libName cellName)

        port = outfile("./radiationLib/libInit.il" "w")
        fprintf(port "load(\"./SKILL/RECTANGULAR/ELTpcell.il\")")
        close(port)
    )
)

/*let( (libName cellName)
    ;; Load files
    load("./SKILL/RECTANGULAR/pcellUtils.il")
    load("./SKILL/RECTANGULAR/ELTpcell.il")
    libName = "radiationLib"
    
    ;; Create transistor nELT
    cellName = "N_ELT"
    ELTdefinePC(libName cellName)
    load("./SKILL/RECTANGULAR/nCDF.il")
    CreateSymbol(libName cellName)

    ;; Create transistor pELT
    cellName = "P_ELT"
    ELTdefinePC(libName cellName)
    load("./SKILL/RECTANGULAR/pCDF.il")
    CreateSymbol(libName cellName)
)*/