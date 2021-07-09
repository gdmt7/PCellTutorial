# Introduction

This repository corresponds to the work developed in a master's thesis, the code developed can be used as a tutorial in order to develop other types of Parametrized Cell (PCell) for different technologies.
To mitigate the impact of radiation exposure in microelectronics circuits, multiple methods have emerged in order to be studied, Radiation Hardened by Design (RHbD) was the choosen method, basically this technique rely in the modification of the transistor layout geometry.
Using a commercial technology of 130 nm from United Microelectronics Corporation (UMC) the main goal is to develop an Enclosed Layout Transistor (ELT) library with an NMOS and PMOS PCell, which can be used to design any circuit layout using radiation tolerant transistors. In this work two different types of layout for radiation tolerant were developed, presented as a rectangular and a octagonal PCell.

# Tools and language used for the development of PCell:

* Cadence Virtuoso Design Environment
* SKILL Language Programming
* Visual Studio Code

# How to run the Scripts:

* Copy the PCell folder you intend to use to your working directory in Cadence Virtuoso.
* In the Command Interpreter Window (CIW) of Cadence Virtuoso:  
  * **load**("./EXAMPLE/pcellMain.il")
 
* After loading the code, in the Cadence CIW call the function **init()** to run the script: 
  * **init**(libName attachLibName)
    * This function creates a library with the name **libName** and attaches the technology file **attachLibName** to the **libName** library. The **attachLibName** refers to the technology on which PCell is intended to be developed, in this case UMC 130 nm technology. 

* If you need to run the script again, you just need to run the **load** command in the CIW, bearing in mind that the library has already been created by the **init()** function.

# Considerations

* The work developed in this thesis used commercial EDA tools, without modifications in the standard design flow or in the internal models used by the tool, as well as in the PDK files used. 
* It is important to highlight and clarify that PCell's are DRC and LVS clean, remembering that these PCell's were developed for UMC 130 nm technology.
* If you intend to implement these scripts for another technology, you should study and understand the **getTechInfo** function developed, this contains all the information related to the design layout rules of the PDK.
  * The function **getTechInfo** is in the file **ELTpcell.il** both on the Octagonal and Recangular folders.
