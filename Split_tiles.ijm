// FIJI Macro to split active image into 512x512 tiles and save with "Sample1_XXX.tif" names

outputPath = "U:/SynCell GnD/1.Results/3.Year3/GnD00X-Integration/Nikon/20241129-pKEL-G607spike-pkel-011/";
sampleNumber=1
baseName = "Sample" + sampleNumber + "_";
tileSize = 512;
counter = 1;

// Duplicate original image as working copy, including all channels
originalTitle = getTitle();
run("Duplicate...", "title=WorkingCopy duplicate channels");
selectWindow("WorkingCopy");

width = getWidth();
height = getHeight();

for (y = 0; y < height; y += tileSize) {
    for (x = 0; x < width; x += tileSize) {
        selectWindow("WorkingCopy");
        makeRectangle(x, y, tileSize, tileSize);
        run("Duplicate...", "duplicate channels");
        formattedNum = IJ.pad(counter, 3);
        saveAs("Tiff", outputPath + baseName + formattedNum + ".tif");
        close();
        counter++;
    }
}

// Close the working copy at the end
selectWindow("WorkingCopy");
close();