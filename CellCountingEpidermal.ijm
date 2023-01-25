// This macro aims to quantify 
// All function used are available from the stable version of Fiji.
// Requires installation of 
// 

// Macro author R. De Mets
// Version : 0.0.3 , 20/09/2022
// Enlarge ROI to pick cytoplasm a bit
// Epidermal crop

// Global variables to execute both macros in sequence

macro "Segment Action Tool - C000D63DfdC000D59DbcC000D17C000DddC000D38C000Da5C000D8aC000D04C000D74C111DabC111DedC111D06C111Dc7C111DfbC111D05C111D69C111D53Db6C111De9DfcC111D43C111C222Dd8C222D34C222D27C222D48C222D95C333DccC333C444D85C444D9aC444D24C444C555D79C555D64DeaC555C666D14C666DbbC666C777D58C888D16C888Da6C999D37C999CaaaDc8CaaaDdcCaaaD44CaaaD89Db7CaaaDaaCaaaCbbbD75CbbbDecCbbbDd9CbbbDebCbbbCcccD15CcccD54CcccD68CdddD26CdddCeeeDcbCeeeD35CeeeD47CeeeD96CeeeD86CeeeD99CfffD25D65CfffD78CfffDbaCfffDdaCfffD45Db8CfffDa7CfffD36D57Dc9CfffDdbCfffD46D55D56D66D67D76D77D87D88D97D98Da8Da9Db9Dca"{
	setBatchMode(true);
	run("Close All");
	dirS = getDirectory("Choose source Directory");
	pattern = ".*"; // for selecting all the files in the folder
	
	
	filenames = getFileList(dirS);
	count = 0;
	
	// Open each file
	for (i = 0; i < filenames.length; i++) {
	//for (i = 0; i < 1; i++) {
		currFile = dirS+filenames[i];
		print(currFile);
		if(endsWith(currFile, ".czi") && matches(filenames[i], pattern)) { // process czi files matching regex
			//open(currFile);
			roiManager("reset");
			run("Clear Results");
			run("Set Measurements...", "mean redirect=None decimal=2");
			
			run("Bio-Formats Windowless Importer", "open=[" + currFile+"]");
			getPixelSize(unit, pw, ph, pd);
			getDimensions(width, height, channels, slices, frames);
			title = File.nameWithoutExtension;
		
			
			// ### Full Cell ###
			width = getWidth();
			height = getHeight();
			window_title = getTitle();

			setBackgroundColor(0, 0, 0);
			run("Duplicate...", " ");
			rename("Epiderm_mask");
			run("Gaussian Blur...", "sigma=5");
			
			run("Auto Threshold", "method=Huang2");
			//run("Keep Largest Region");
			run("Analyze Particles...", "size=1000-Infinity include add");
			newImage("MaskEpi", "8-bit black", width, height, 1);
			//run("Fill Holes (Binary/Gray)");
			count = roiManager("count");
			for (roi=0; roi<count; roi++) {
			    roiManager("Select", roi);
				run("Invert");
			}
			
			selectWindow(window_title);
			rename("Tissue");
			run("Split Channels");
			for (j = 2; j <= channels; j++) {
				imageCalculator("Add", "C1-Tissue","C"+j+"-Tissue");
				close("C"+j+"-Tissue");
			}
			selectWindow("C1-Tissue");
			run("Gaussian Blur...", "sigma=5");
			run("Auto Threshold", "method=Triangle");
			run("Convert to Mask");
			rename("MaskDerm");
			close("Epiderm_mask");
			run("Images to Stack", "use");
			run("Invert", "stack");
			run("Fill Holes", "stack");
			saveAs("Tiff", dirS+title+"_Masks.tif");
			run("Close All");
			
			
			
		}
	}
	Dialog.create("Done");
	Dialog.show();
}


macro "Measure Action Tool - C65aD08D12D29D54D55D6dD6eD7cD7eD8aD8bD8eD97D9bD9dDa3Da4Da7DacDaeDb3Dc4Dd2DdeDe5DedDefDf2Df3DfdCdeeD06D07D24D26D35D40D41D45D52D53D6aD7dD81D8cD8dD96D9cD9fDb4DdbDeaDf5C7ecD01D22D23D2eD32D33D34D3eD42D43D44D7aD80D86D89D95DbeDceDd7DdcDe0De6De8DfaCfffD00D10D11D20D21D28D30D31D39D49D4fD59D66D92Db7De7C894D27D76D87D88DafDc2Dc7Dd1DdfDebDecDfbDfcCefeD1fD58D67D68D69D77D78D79Dd5Df8C9deD57Da2Da6Db2DbfDcfC6b8D90D91Da0Da1Da5Db0Db1Dc0Dc1Dc5Dd0Df6CeeeD36D56Db5Dd6Df7CdbaD2fD3fDb6Dc6CbddD38D46D47D48CdeeD37"{
	setBatchMode(true);
	run("Close All");
	dirS = getDirectory("Choose source Directory");
	pattern = ".*"; // for selecting all the files in the folder

	
	filenames = getFileList(dirS);
	count = 0;
	
	// Open each file
	for (i = 0; i < filenames.length; i++) {
	//for (i = 0; i < 1; i++) {
		currFile = dirS+filenames[i];
		if(endsWith(currFile, ".czi") && matches(filenames[i], pattern)) { // process czi files matching regex
			//open(currFile);
			roiManager("reset");
			run("Clear Results");
			run("Set Measurements...", "mean redirect=None decimal=2");
			
			run("Bio-Formats Windowless Importer", "open=[" + currFile+"]");
			
			getPixelSize(unit, pw, ph, pd);
			width = getWidth();
			height = getHeight();
			window_title = getTitle();
			
			title = File.nameWithoutExtension;
			run("Bio-Formats Windowless Importer", "open=[" +dirS + title+"_Masks.tif]");
			rename("Masks");
			run("Stack to Images");		


			
			// Epidermal crop
			selectWindow("Masks-0001");
			run("Create Selection");
			roiManager("Add");
			run("Enlarge...", "enlarge=500");
			roiManager("Add");
					
			selectWindow(window_title);
			run("Select All");
			run("Duplicate...", "duplicate");
			roiManager("Select", 0);
			run("Clear Outside", "stack");
			rename("Dermal");
			
						
																		
			newImage("Temp", "8-bit white", width, height, 1);	
			roiManager("Select", 0);	
			run("Invert");
			roiManager("Select", 1);	
			run("Invert");
			run("Select All");
			run("Invert");
			
			selectWindow("Masks-0002");
			run("Invert");
			imageCalculator("AND create", "Temp","Masks-0002");
			//run("Invert");							
			run("Create Selection");
			roiManager("Add");
	
			selectWindow(window_title);
			run("Select All");
			run("Duplicate...", "duplicate");
			roiManager("Select", 2);
			run("Clear", "stack");
			rename("Epidermal");


			
			
			// Stardist segmentation Dermal
			roiManager("reset");
			run("Clear Results");
			selectWindow("Dermal");
			setSlice(3);
			run("Select All");
			run("Duplicate...", " ");
			//waitForUser;

			//setBatchMode(false);
			run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'Dermal-1', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
			if (is("Batch Mode")==0) {
				saveAs("Tiff", dirS+title+"_Label_Dermal.tif");
			}
			//setBatchMode(true);
			count = roiManager("count");
			array = newArray(count);
			for (nuc=0; nuc<array.length; nuc++) {
			    array[nuc] = nuc;
			    roiManager("Select", nuc);
				run("Enlarge...", "enlarge=1");
				roiManager("Update");
			}
			roiManager("Save", dirS+title+"_roi_dermal.zip");
			selectWindow(window_title);
			roiManager("select", array);
			roiManager("multi-measure measure_all one append");
			saveAs("Results", dirS+title+"_results_dermal.csv");
			
			
			
			// Stardist segmentation epidermal
			
			roiManager("reset");
			run("Clear Results");
			selectWindow("Epidermal");
			//waitForUser;

			setSlice(3);
			run("Select All");
			run("Duplicate...", " ");
			//setBatchMode(false);
			run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'Epidermal-1', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
			if (is("Batch Mode")==0) {
				saveAs("Tiff", dirS+title+"_Label_Epidermal.tif");
			}
			//setBatchMode(true);
			count = roiManager("count");
			array = newArray(count);
			for (nuc=0; nuc<array.length; nuc++) {
			    array[nuc] = nuc;
			    roiManager("Select", nuc);
				run("Enlarge...", "enlarge=1");
				roiManager("Update");
			}
			roiManager("Save", dirS+title+"_roi_epidermal.zip");
			selectWindow(window_title);
			roiManager("select", array);
			roiManager("multi-measure measure_all one append");
			saveAs("Results", dirS+title+"_results_epidermal.csv");
			run("Close All");
			
			
			
		}
	}
	Dialog.create("Done");
	Dialog.show();
}
			


