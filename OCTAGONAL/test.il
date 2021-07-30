procedure(GetTechInfo(cvId parameter)
  let( (pcTechFile)
    pcTechFile = techGetTechFile(cvId)

    case( parameter
        ( "PO1_minWidth"
            PO1_minWidth = techGetSpacingRule(pcTechFile "minWidth" "PO1")
        )
        ( "ME1_minSpacing"
            ME1_minSpacing = techGetSpacingRule(pcTechFile "minSpacing" "ME1")
        )
        ( "grid"
            grid = techGetMfgGridResolution(pcTechFile)
        )
    )
    ;list(nc overSpace)
  )
)

/*case(testString
  (("one" "two") printf("1 or 2\n"))
  (("three" "four") printf("3 or 4\n"))
  (t printf("something else\n"))
)*/

procedure(ELTdefinePC(libName cellName)
    pcDefinePCell(
      list(ddGetObj(libName) cellName "layout")
      (
        (model "string" "TEST")
      ) 
    )
)