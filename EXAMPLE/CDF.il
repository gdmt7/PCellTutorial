;; Create the CDF for the 'l' and 'w' parameters, the width (w)
;; parameter is either hidden or displayed but not editable.
let( (cellId cdfId)
    cellId = ddGetObj("radiationLib" "example")
    ;; create the base cell CDF
    cdfId = cdfCreateBaseCellCDF(cellId)
    ;; create the parameters
    cdfCreateParam( cdfId
      ?name           "model"
      ?prompt         "Model name"
      ?defValue       "example"
      ?type           "string"
      ?display        "nil"
      ?parseAsCEL     "yes"
    )    
    cdfCreateParam( cdfId
      ?name     "l"
      ?prompt   "Length"
      ?units   "lengthMetric"
      ?defValue "0.2u"
      ?type     "string"
      ?storeDefault "yes"
      ?display  "t"
      ?editable "t"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
      ?name     "d"
      ?prompt   "Distance d"
      ?units   "lengthMetric"
      ?defValue "1.115u"
      ?type     "string"
      ?storeDefault "yes"
      ?display  "t"
      ?editable "t"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )    
    cdfCreateParam( cdfId
      ?name     "h"
      ?prompt   "Height"
      ?units   "lengthMetric"
      ?defValue "0.1u"
      ?type     "string"
      ?storeDefault "yes"
      ?display  "t"
      ?editable "t"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )    
    cdfCreateParam( cdfId
      ?name     "sl"
      ?prompt   "Source Length"
      ?units   "lengthMetric"
      ?defValue "0.36u"
      ?type     "string"
      ?storeDefault "yes"
      ?display  "t"
      ?editable "t"
      ?parseAsNumber  "yes"
      ?parseAsCEL     "yes"
    )  
)