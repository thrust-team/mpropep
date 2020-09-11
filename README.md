# cpropep + MATLAB = mpropep
This repository contains a library of scripts to use the amazing rocketworkbench utility `cpropep` inside MATLAB scripts.

## How to install

Easier than ever! Just download the files or clone the repo in your favorite folder. This repo also includes the executable, propellant data and thermochemical data. 

## Usage example



## How to make `cpropep` work with MATLAB

### How to make `cpropep` work (Windows)

The `cpropep.exe` file is a command line utility that needs a configuration file, `cpropep.conf`, specifying the location of the list of propellant data `propellant.dat` and thermochemical quantities for  the reaction computation `thermo.dat`.

The input file `input.txt` specifies the quantities of the compounds and the conditions under which to execute the computations. For further information read the file `input_info.txt`.

To run the program natively, open Command Prompt and move to the folder where `cpropep.exe` resides, for example:


``` batch
c:\> cd c:\Users\user\Documents\GitHub\mpropep\cpropep
c:\Users\user\Documents\GitHub\mpropep\cpropep> cpropep.exe [-fopq]
```

To check if the program works, type:

```batch
> cpropep.exe -i
Thermo data file: thermo.dat
Propellant data file: propellant.dat
----------------------------------------------------------
Cpropep is [...]
Copyright (C) 2000 Antoine Lefebvre <antoine.lefebvre@polymtl.ca>
----------------------------------------------------------
```

The first two output lines show that the program found the two data files it needs and is ready to do some solving.

If the input file is named `input.txt`, the output of the utility will be displayed in the command prompt after typing:

```batch
> cpropep.exe -f input.txt
Thermo data file: thermo.dat
Propellant data file: propellant.dat
Computing case 1
[solver type]

Propellant composition
Code  Name                                mol    Mass (g)  Composition
[ID1] ......                              ....   .......   ...........
[ID2] ......                              ....   .......   ...........
Density :  ....
n different elements
..  ..  ..  ..  .. ..
Total mass:  ...
Enthalpy  :  ...

m possible gazeous species
p possible condensed species

                       CHAMBER      THROAT        EXIT
Pressure (atm)   :        ....        ....        ....
Temperature (K)  :        ....        ....        ....
[...]                   
Isp/g (s)        :                    ....        ....

Molar fractions

[compound1]               ....        ....        ....
[compound2]               ....        ....        ....
[compound3]               ....        ....        ....
[...]
[compoundq]               ....        ....        ....
```

In order to save the output to a text file `output.txt` you can write:
```batch
> cpropep.exe -f input.txt -o output.txt
```

### Where MATLAB comes in

The scripts developed in this repo make use of the command line interface by executing `cpropep.exe` inside MATLAB and via simple batch scripts.

In particular, the aim is to develop a system that seamlessly creates the `input.txt` file, runs the program with due flags, generates an output file `output.txt` and parses this output file to extract the desired results.

#### Preparation

This library assumes the file `list.txt`, which contains the propellant list as interpreted by the utility, exists in the `/cpropep/` folder and is up to date with the `propellant.dat` it was generated from. If you wish to edit `propellant.dat` by adding, removing, or editing some compounds remember to delete the `list.txt` file. This text file is used by the MATLAB scripts to infer the name of a compound given its identification number and is automatically updated by the library.

#### Input file generation with `writeInputFile()`

<to be added>

#### Output file parsing with `readOutputFile()`

<to be added>