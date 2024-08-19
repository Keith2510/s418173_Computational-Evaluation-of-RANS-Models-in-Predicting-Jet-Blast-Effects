
# Computational Evaluation of RANS Models in Predicting Jet Blast Effects.

This repository contains the scripts developed for the thesis "Computational Evaluation of RANS Models in Predicting Jet Blast Effects." by Keith Sequeira (MSc Computational Fluid Dynamics, IRP - 2024). The scripts included here are essential for the modelling, analysis and visualization tasks performed in the thesis, focusing on the study of turbulence models in jet blast scenarios.

## Repository Structure

The repository is organized into two main folders:

1. **Automated Geometry Modelling Python Scripts**
   - This folder contains Python scripts for ANSYS SpaceClaim that automate the creation of geometric models for jet blast simulations. The scripts included are:

   - `SingleJet_Model_Meters.py`: 
     - Models a cylindrical domain in meters for a single jet and assigns all named selections.
     - Users should adjust the dimensions of the cylinder and domain as needed.

   - `SingleJet_Model_Millimeters.py`: 
     - Similar to the above script, but models the domain in millimetres.
     - Adjust dimensions according to your specific requirements.

   - `MultipleJet_Model_Meters.py`: 
     - Models multiple cylindrical domains and assigns all named selections.
     - The script requires user input for the inlet (cylinder outlet) and for specifying the dimensions of both the cylinders and the domain.

2. **MATLAB Scripts**
   - This folder contains MATLAB scripts for performing various analyses related to the jet blast simulations including hazardous zone calculations, iteration studies and mesh independence studies. The scripts included are:

   - `Hazardous_Zone.m`:
     - Calculates the hazardous region around the jet based on a specified velocity limit.
     - Requires solution data to be exported from the horizontal centreplane
     - To be noted that this script takes a significant amount of time to give plots

   - `Iteration_Study.m`:
     - Analyses and visualizes the results of an iteration study, focusing on key variables such as x-velocity, static temperature and turbulent kinetic energy across different iterations along with mass flow rate and forces.
     - The script requires user inputs, which are provided in a dedicated section at the beginning.

   - `Jet_Blast_Analysis_Setup.m`:
     - Sets up the analysis for jet blast scenarios and generates plots for all the variables examined in the thesis.
     - Includes a user input section at the beginning.

   - `Mesh_Independence_Study.m`:
     - Compares results across different mesh configurations, focusing on x-velocity, static temperature and turbulent kinetic energy.
     - Useful for ensuring that the simulation results are independent of the mesh resolution.

## Usage Instructions

1. **ANSYS SpaceClaim Scripts:**
   - Open ANSYS SpaceClaim.
   - Load the desired script from the "Automated Geometry Modelling Python Scripts" folder.
   - Run the script.
   - Review and adjust the model as necessary to fit your specific application.

2. **MATLAB Scripts:**
   - Open MATLAB.
   - Navigate to the "MATLAB Scripts" folder.
   - Load and run the script corresponding to the analysis you wish to perform.
   - Provide the necessary inputs as prompted by the script.
   - Review the generated plots and results for your analysis.

## Requirements

- **Software:**
  - ANSYS SpaceClaim for running the geometry modelling scripts.
  - MATLAB for running the analysis scripts.

## Acknowledgments
Special thank you to my supervisor Tamás Józsa for his assistance in troubleshooting the Jet_Blast_Analysis_Setup.m MATLAB script fix. The scripts in this repository were developed with assistance from ChatGPT and Bing AI, which contributed to the scripting and automation processes.



---

This README provides a comprehensive overview of the contents of the repository and how to use the included scripts effectively. Let me know if you need any further adjustments!

Contact
For questions or feedback, please reach out to:  
Keith Sequeira
K.Sequeira.173@Cranfield.ac.uk
www.linkedin.com/in/keithsequeira2510
MSc Computational Fluid Dynamics, Cranfield University

---

Thank you for using this script!
