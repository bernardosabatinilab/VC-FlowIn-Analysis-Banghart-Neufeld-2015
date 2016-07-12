## Voltage clamp flow in analysis used in Banghart & Neufeld et al 2015 (Figures 2,4-7)

This is a collection of MATLAB codes to analyze voltage-clamp electrophysiological recordings during whole bath flow-in of drugs obtained with ScanImage. 

The typical data analysis pipeline can be found in IPSC_Estim_FlowIn_Analysis.m. You can also run this pipeline using the MATLAB Jupyter notebook FlowIn_AnalysisExample.ipynb. 

  The pipeline is as follows:
  1. prompt the user to select a folder from which it loads all the acqusitions in the '0' channel
  2. specify the flow-in epochs (not including baseline)
  3. plot the raw and baselined data. 
  4. pecify the range to calculate the IPSC peaks
  5. plot Rs, Rm, PPR, C, Peaks, Leak Current, with each epoch in a different color. A legend with what flow-ins correspond to what drug will appear on the Peaks figure.(This is when I usually put all the figures into the "Show Plot Tools", so I can modify the axes, change marker size if I want etc...)
  6. Once you are happy with the figures, type in 'Y' into the command window where you are asked if you'd like to save the figures (as TIFFS) and  dataStructure into the current directory. The dataStructure is a structure that contains fields for all the parameters (Rm, Rs, Peak1, Peak2 etc...) so you can easily reload a cell in the future to do future analysis without having to rerun this script.
