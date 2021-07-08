# Introduction

To mitigate the impact of radiation exposure in microelectronics circuits, multiple methods have emerged in order to be studied, RHbD was the choosen method, basically this technique rely in the modification of the transistor layout geometry.
Using a commercial technology of 130 nm from UMC the main goal is to develop an ELT library with an NMOS and PMOS PCell, which can be used to design any circuit layout using radiation tolerant transistors. In this thesis two different types of layout for radiation tolerant were developed, presented as a rectangular and a octagonal PCell.

# Tools and language used for the development of PCell:

* Cadence Virtuoso Design Environment
* SKILL Language Programming
* Visual Studio Code

# How to run the Scripts:

* Copies the PCell folder you intend to use to the working directory in Cadence.
  * ```console
    foo@bar:~$ cp [option] source destination
    ```
* In the Command Interpreter Window (CIW) of Cadence Virtuoso:  
  * **load**("./EXAMPLE/pcellMain.il")
 
* After loading the code, use the function created to to run the script: 
  * **init**(libName attachLibName)
