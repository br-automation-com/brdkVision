ACTION mainSimpleAction:
	// always update pointers in case of copy download without execution of init/exit
	this.imgTrig.pCameraHw := ADR(hw.cam);
	this.imgTrig.pLightHw := ADR(hw.backLight);
	this.imgTrig.simulate.enable := DiagCpuIsSimulated();
	this.imgTrig.simulate.imgProcessingDelay := T#50ms;
	
	
	// trigger image
	hw.cam.out.par.flashColor 	:= hmi.in.par.LED;
	hw.cam.out.par.flashSegment	:= hmi.in.par.LEDsegment;
	hw.cam.out.par.exposureTime	:= hmi.in.par.expTime;
	hw.cam.out.par.focus 		:= hmi.in.par.focus;
	hw.cam.out.par.IRFilter 	:= hw.cam.out.par.flashColor = BRDKVIBASE_CAM_LED_IR;
	
	// handles triggering af images
	this.imgTrig.pCameraHw := ADR(hw.cam); // Pointer to camera hw structure
	this.imgTrig.pLightHw := ADR(hw.backLight); // pointer to light structure or light structure array if more than one
	this.imgTrig.numLights := 1; //Number of lights
	this.imgTrig.useCamColorForLight := TRUE; // set Lights to same color as Camera 
	this.imgTrig.useCamExpTimeForLight := TRUE; // Set light exposure time to same as camera
	this.imgTrig();
	
	// Trigger image
	IF this.imgTrig.ready AND NOT this.imgTrig.busy AND hmi.in.cmd.trigger THEN
		hmi.in.cmd.trigger 			:= FALSE;
		this.imgTrig.trigger 		:= TRUE;
		this.imgTrig.delayNettime 	:= hw.io.input.nettime + 50000; // add 50ms
	END_IF
					
	// Check for new image result
	IF this.imgTrig.newImage THEN
		this.mappView.updateImage := TRUE; // Trigger an update of the image on HMI
		
		IF hw.blob.in.common.numResults > 0 THEN
			FOR i:= 0 TO hw.blob.in.common.numResults-1 BY 1 DO
				this.tmp2D.x := DINT_TO_REAL(hw.blob.in.results[i].positionX) / 100.0;
				this.tmp2D.y := DINT_TO_REAL(hw.blob.in.results[i].positionY) / 100.0;
				// draw circle on overlay
				brdkViGeom_drawSvgCircle(this.tmp2D,50.0,ADR(hmi.out.overlay),ADR('style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'));

			END_FOR
		END_IF
	END_IF
	
	
	// Handle image click event on HMI image
	IF hmi.in.cmd.click THEN
		hmi.in.cmd.click := FALSE;
		
		this.tmp2D.x := hmi.in.cmd.x; //Click X coordinate
		this.tmp2D.y := hmi.in.cmd.y; // Click Y coordinate
		hmi.out.overlay := '';
		
		// If image is decoded and the size is larger than 0 then we can get the px value
		IF this.mappView.getImageArray AND 	this.imgArr.size > 0 THEN
			hmi.out.pxColor := brdkViImg_getPixel(LREAL_TO_INT(this.tmp2D.x),LREAL_TO_INT(this.tmp2D.y),this.imgArr.width,this.imgArr.pData); // Get pixel color value
		ELSE
			hmi.out.pxColor := 0;
		END_IF
		
		this.tmp2D.x := this.tmp2D.x -50; // offset -50 as image is 100 width such that center is in click position
		this.tmp2D.y := this.tmp2D.y -50; // offset -50 as image is 100 width such that center is in click position
		// Draw image in overlay (cross air)
		brdkViGeom_drawSvgImage(ADR(this.url),this.tmp2D,ADR(''),100,100,ADR(hmi.out.overlay),ADR(''));
	END_IF
	
	// Function to retrieve image from camera to show on HMI
	this.mappView.enable 		:= TRUE; // Enable
	this.mappView.pMappLink 	:= ADR(gBlobCamera); // Pointer to Vision component Mapp link variable
	this.mappView.getImageArray := TRUE; // If true the retrived image is also decoded to an USINT array
	this.mappView.pImageArray 	:= ADR(this.imgArr); // Pointer to brdkViImg_ImageArray_typ
	this.mappView.timeout 		:= 3000; // time out when retriving the image from the camera
	this.mappView.wsPort 		:= hmi.in.par.wsPort; // Web socket port number (use the same on brdk vision Image widget) (0 = web socket is not used)
	this.mappView.imageFormat 	:= hmi.in.par.imgFormat; // Image format to download JPEG or BMP
	this.mappView.jpegQuality 	:= hmi.in.par.imgQuality; // Quality for th	e JPEG image
	this.mappView.pImageArray 	:= ADR(this.imgArr); // Pointer to image array data structure (Decoded image information and 2d byte array)
	this.mappView.pSvgImage     := ADR(this.wsSvg); // Optional for web socket usage, but can be used to contain the SVG image if OPC UA is used
	// Simulation Configuration (Get images from file device instead of camera)
	this.mappView.simulateConfig.activate := DiagCpuIsSimulated(); // true if PLC is simulated
	this.mappView.simulateConfig.appendNumber := TRUE; // If true number is appended to file name
	this.mappView.simulateConfig.minNumber := 1; // Min number to append
	this.mappView.simulateConfig.maxNumber := 3; // Max number to append
	this.mappView.simulateConfig.autoIncrementNumber := TRUE; // Automatically Increment number
	this.mappView.simulateConfig.pDevice := ADR(this.simFileDevice); // Pointer to file device name where simulation images are located
	this.mappView.simulateConfig.pFile := ADR(this.simFilename); // pointer to filename string (with out file extension, which come from seleted image type Jpeg or BMP) where number is appended to
	this.mappView();
	
	
	this.getImage(enable := FALSE); // not used as the one inside mappView is used
	this.wsServer(enable := FALSE); // not used as the one inside mappView is used
	
	// recipe
	this.mpRecipeRegPar.ConfirmSave := this.mpRecipeRegPar.SaveNotification;
	this.mpRecipeRegPar(Enable := TRUE);
		
END_ACTION

