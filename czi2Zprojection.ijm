// Prompt the user to select a folder
folderPath = getDirectory("Choose a folder containing .czi files");

// Prompt the user to select ONE .czi file
//openPath = File.openDialog("Choose a .czi file");

// Get the list of .czi files in the folder
list = getFileList(folderPath);

// Loop through each file in the folder
for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".czi")) {
		// Open the .czi file
		openPath = folderPath + list[i];
		run("Bio-Formats Importer", "open=[" + openPath + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

		// Get the file directory and name
		fileDir = File.getParent(openPath);
		fileName = File.getName(openPath);
		fileNameNoExt = replace(fileName, ".czi", "");
		
		// Split channels
		run("Split Channels");
		
		// Select the first channel
		selectWindow("C1-" + fileNameNoExt + ".czi");
		
		// Choose LUT for your Z Project
		run("Green");

		// Perform Z projection (maximum intensity)
		run("Z Project...", "projection=[Max Intensity]");
		
		run("Scale Bar...", "width=10 height=5 horizontal bold overlay");

		// Save the resulting projection
		savePath = fileDir + "/" + fileNameNoExt + "_channel1_maxZ.tif";
		saveAs("PNG", savePath);
		
		// Close all images
		run("Close All");
    }
}
