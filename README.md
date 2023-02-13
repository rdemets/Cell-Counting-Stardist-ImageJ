# Motivations
## <em>Work in progress</em>

The aim of this macro is to count the number of cells using the DAPI fluorescent channel betweem the dermal and the epidermal region of a tissue. The cell detection is being performed using Stardist

## How to install

To install, drop the file in Fiji.app>macros>toolsets folder. Restart Fiji and the macro name will then appear under the **>>** menu on the right hand side of Fiji bar.

## Requirements

This macro requires **CSBDeep** and **Stardist** from the Fiji plugins updater. Please cite the respective authors.

## How to use

To activate the macro, find it under the **>>** menu on the right hand side of Fiji bar. Two buttons should appear on the Fiji bar. 
The first button will perform a segmentation of the images. The macro will ask for a folder where all the CZI files to analyze are. The algorithm is expecting an epidermal staining in the first channel and will use it to threshold the image using an automatic Huang2 algorithm. To segment the rest of the tissue, all the channels are added together and thresholded using the Triangle algorithm. The masks are being saved in the same folder and can be reviewed before measurement.
<br>The second button will do the measurement of the number of cells in the two regions defined during the first function. The epidermal region is being enlarged upon user request, but can be ommited if needed. Stardist is being used with its default value and using the pretrained DSB fluorescent model. The cell detection are enlarged for better visualization. Measurement is being performed and analysis are being saved automatically in the same folder.   


## Citations

Please cite [Stardist](https://link.springer.com/chapter/10.1007/978-3-030-00934-2_30) and [CSBDeep](https://www.nature.com/articles/s41592-018-0216-7) if you use this macro.

## Updates history
(0.0.2) Tasks splitted into two buttons
<br>(0.0.3) Enlarge cell detection and epidermal region 
