/* pCDF.il

Author          Guilherme Trindade
Group           INESC-ID - Analog and Mixed-Signal Circuits (CAM)
Language        SKILL
Revision No.    1.0
Date Created    Apr 05, 2020
Modified         
By:

************************
LIBRARY = "UMC130"
CELL    = "pCDF"
************************

*/

let( (cellId cdfId libName cellName)
  libName = "radiationLib"
  cellName = "P_12_HSL130E"
  when(cellId = ddGetObj(libName cellName)
    ;; if the cell CDF already exists, delete it
    when( cdfId = cdfGetBaseCellCDF(cellId)
      cdfDeleteCDF(cdfId)
    )
    ;; create the base cell CDF
    cdfId = cdfCreateBaseCellCDF(cellId)
    ;; create the parameters
    cdfCreateParam( cdfId
      ?name           "model"
      ?prompt         "Model name"
      ?defValue       "p_12_hsl130e"
      ?type           "string"
      ?display        "nil"
      ?parseAsCEL     "yes"
    )    
    cdfCreateParam( cdfId
      ?name     "l"
      ?prompt   "Length"
      ?units   "lengthMetric"
      ?defValue "0.30u"
      ?type     "string"
      ?storeDefault "yes"
      ?display  "t"
      ?editable "t"
      ?callback "calcWmethod()"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
      ?name     "w"
      ?prompt   "Width"
      ?storeDefault "yes"
      ?units   "lengthMetric"
      ?defValue "6u"
      ?type     "string"
      ?display  "t"
      ?editable "t"
      ?callback "calcWmethod()"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
      ?name     "d"
      ?prompt   "d"
      ?storeDefault "yes"
      ?units   "lengthMetric"
      ?defValue "0.75u"
      ?type     "string"
      ?display  "t"
      ?editable "nil"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
      ?name     "dl"
      ?prompt   "dl"
      ?storeDefault "yes"
      ?units   "lengthMetric"
      ?defValue "0.125u"
      ?type     "string"
      ?display  "t"
      ?editable "nil"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
      ?name     "sl"
      ?prompt   "sl"
      ?storeDefault "yes"
      ?units   "lengthMetric"
      ?defValue "0.36u"
      ?type     "string"
      ?display  "t"
      ?editable "nil"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )

    ;; Simulator Information
    cdfId->simInfo = list( nil )
    cdfId->simInfo->auCdl = '( nil
      netlistProcedure  ansCdlSubcktCallExtended
      instParameters    (l w)
      termOrder         (D G S B)
      propMapping       nil
      namePrefix        "M"
      ;componentName     P
      modelName         P_12_HSL130E
    )

    cdfId->simInfo->spectre = '( nil
      termMapping       (nil D \:dl G \:g S \:s B \:b)
      instParameters    (w l m)
      otherParameters   (model)
      termOrder         (D G S B)
      ;propMapping       (nil m simM w)
    )

    /*cdfId->simInfo->spectreS = '( nil
      termOrder         (D G S B)
      propMapping       (nil m simM nf fingers)
      netlistProcedure  ansSpectreSDevPrim
      otherParameters   (model region)
      instParameters    (w l as ad ps pd m nf mis_flag trise)
      termMapping       (nil D dl G g S s B b)
      namePrefix        M
      componentName     mos2
      current           port
    )*/

    ;;; Properties
    cdfId->formInitProc            = ""
    cdfId->doneProc                = ""
    cdfId->buttonFieldWidth        = 340
    cdfId->fieldHeight             = 35
    cdfId->fieldWidth              = 350
    cdfId->promptWidth             = 175
    cdfId->paramLabelSet           = "-model l w"
    cdfId->opPointLabelSet         = "id vgs vds vth vdsat"
    cdfId->modelLabelSet           = "vtho vsat"

    cdfSaveCDF(cdfId)
  )
)
