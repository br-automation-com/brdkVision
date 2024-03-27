
ACTION	mainCalibrationAction:
	// always update pointers in case of copy download without execution of init/exit
	this.imgTrig.pCameraHw := ADR(hw.cam);
	this.imgTrig.pLightHw := ADR(hw.backLight);
	
	// trigger image
	hw.cam.out.par.flashColor 	:= hmi.in.par.LED;
	hw.cam.out.par.flashSegment	:= hmi.in.par.LEDsegment;
	hw.cam.out.par.exposureTime	:= hmi.in.par.expTime;
	hw.cam.out.par.focus 		:= hmi.in.par.focus;
	hw.cam.out.par.IRFilter 	:= hw.cam.out.par.flashColor = BRDKVIBASE_CAM_LED_IR;

	IF hmi.in.cmd.calibrate THEN
		// for calibration we only look for 4 round Blobs
		hw.blob.out.common.numSearchMax := 4;
		hw.blob.out.common.enable := TRUE;
		hw.blob.out.regionFeatures := TRUE;			
	ELSIF hmi.in.cmd.trigger THEN
		hw.blob.out.common.enable := FALSE;
		hw.blob.out.regionFeatures := FALSE;		
	END_IF
	
	
	// handles triggering af images 
	this.imgTrig.pLightHw := ADR(hw.backLight); // pointer to light structure or light structure array if more than one
	this.imgTrig.numLights := 1; //Number of lights
	this.imgTrig.useCamColorForLight := TRUE; // set Lights to same color as Camera 
	this.imgTrig.useCamExpTimeForLight := TRUE; // Set light exposure time to same as camera
	this.imgTrig();
	
	// IF calibration then also trigger an image 
	IF EDGEPOS(hmi.in.cmd.calibrate) THEN
		hmi.in.cmd.trigger := TRUE;
	END_IF
	
	// Trigger image
	IF ((this.imgTrig.ready AND NOT this.imgTrig.busy) OR DiagCpuIsSimulated()) AND hmi.in.cmd.trigger THEN
		hmi.in.cmd.trigger 			:= FALSE;
		this.imgTrig.trigger 		:= TRUE;
		this.imgTrig.delayNettime 	:= hw.io.input.nettime + 50000; // add 50ms
	END_IF
		
			
	// Check for new image result
	IF this.imgTrig.newImage OR (this.imgTrig.trigger AND DiagCpuIsSimulated()) THEN
		this.mappView.updateImage := TRUE;
		
	
		// incase of simulation hardware results
		IF DiagCpuIsSimulated() THEN
			// Random error
			IF brdkViBase_random(0,7) > 4 THEN
				hw.blob.in.common.numResults := 3;
			ELSE
				hw.blob.in.common.numResults := 4;
			END_IF	
				
			hw.blob.in.results[0].positionX := 31118;
			hw.blob.in.results[0].positionY := 15084;
			hw.blob.in.results[1].positionX := 74896;
			hw.blob.in.results[1].positionY := 15408;
			hw.blob.in.results[2].positionX := 31487;
			hw.blob.in.results[2].positionY := 58665;
			hw.blob.in.results[3].positionX := 74391;
			hw.blob.in.results[3].positionY := 58582;
		END_IF
				
		// check if its a calibration or its a pick result image
		IF hmi.in.cmd.calibrate THEN
			this.mappView.simulateConfig.maxNumber := 1; // select only first image
					
			IF hw.blob.in.common.numResults = 4 THEN
			(*
				Calibation Plate
				
				|-------------------|
				|					| 37,5
				|	O			O	|
				|					| 			 150mm
				|					| 75mm
				|					|
				|	O		 	O	|
				| 					| 37,5mm
				--------------------|
				37,5     75mm    37,5	
				_____________________	
						150 mm
				
				Placement of real coordinate systems compared to image and calibration plate holes
				
				0,0         imgWidth,0
				   /|\ Y
				O	|	O
					|
				----------> X
					|
				O	|	O
					|
				0,imgHeiht	imgWidht,imgHeight
			*)
	
			// Transfer VA results to 2 image points
				FOR i:=0 TO 3 BY 1 DO
					// if simulation then fill in four points
	
		
					// scale to px decimal value	
					this.imgPos[i].x := DINT_TO_REAL(hw.blob.in.results[i].positionX) / 100.0;
					this.imgPos[i].y := DINT_TO_REAL(hw.blob.in.results[i].positionY) / 100.0;
		
					// Hardcoded check for point location in each quater of the image 
					IF this.imgPos[i].x > this.imgWidth/2 THEN
						this.realPos[i].x := 37.5; //mm
					ELSE
						this.realPos[i].x := -37.5; // mm
				
					END_IF
			
					IF this.imgPos[i].y > this.imgHeight/2 THEN
						this.realPos[i].y := -37.5; // mm
				
					ELSE
						this.realPos[i].y := 37.5; //mm
					END_IF
			
				END_FOR
				
				// Calculate camera projection matrix (3d -> img coordinate) based on four 3D points the four corresponding img points
				brdkViCal_Calibration(this.realPos[0],this.imgPos[0],4,hmi.in.par.P);
	
				// get invers projection matix (only need to be done one time as the projection matrix only changes if a new calibration is done
				brdkViCal_InvP(hmi.in.par.P,this.invP);

				hmi.out.overlay := ''; // Clear overlay
				// Draw the calibration result based on the 3D data (the four points and x and y axis )
				brdkViGeom_drawCalibration(hmi.in.par.P,75,this.realPos[0],4,10,ADR(hmi.out.overlay),ADR('style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'),ADR('style="fill:red;stroke:red;stroke-width:5;fill-opacity:1;stroke-opacity:1"'));
		
			ELSE // if numresults <> 4
				hmi.out.overlay := ''; // Clear overlay
			
				// Draw warning text on image
				this.tmp2D.x := 50; 
				this.tmp2D.y := 50;
				brdkViGeom_drawSvgText(ADR('Warning: The four point BLOBs was not found!!$N check MappVision for model details.'),this.tmp2D,1,ADR(hmi.out.overlay),ADR('style="font: italic 40px serif; fill: red;"'));
			
				// Draw the found results
				IF hw.blob.in.common.numResults > 0 THEN
					FOR i:=0 TO hw.blob.in.common.numResults-1 BY 1 DO
						// Draw circle
						this.tmp2D.x := DINT_TO_REAL(hw.blob.in.results[i].positionX) / 100.0;
						this.tmp2D.y := DINT_TO_REAL(hw.blob.in.results[i].positionY) / 100.0;
						brdkViGeom_drawSvgCircle(this.tmp2D,50.0,ADR(hmi.out.overlay),ADR('style="fill:blue;stroke:red;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'));
					END_FOR
				END_IF
			END_IF // END if numResults = 4
		ELSE // If not calibrate, Process found results
			this.mappView.simulateConfig.maxNumber := 3; // reset to 3 as calibrate might have set it to 1
	
			// reset current results
			brsmemset(ADR(this.matchRes),0,SIZEOF(this.matchRes));
			hmi.out.overlay := '';
		
			// Process each result from the VF
			FOR i:= 0 TO hw.blob.in.common.numResults BY 1 DO
			
				// convert to decimal numbers (and offset andge)
				this.matchRes[i].imgPos.x := DINT_TO_REAL(hw.blob.in.results[i].positionX) / 100.0;
				this.matchRes[i].imgPos.y := DINT_TO_REAL(hw.blob.in.results[i].positionY) / 100.0;
				this.matchRes[i].angle := DINT_TO_REAL(hw.blob.in.results[i].orientation) / 100.0 + hmi.in.par.offset.z;
			
				// find rotation point (will be used to add offset to x and y axis relative to object orientation)
				this.rotPoint.x := COS(this.matchRes[i].angle*0.0174532925199444);
				this.rotPoint.y := SIN(this.matchRes[i].angle*-0.0174532925199444);
				// add offset (x,y) to object poisition relative to object orientation
				this.matchRes[i].imgPos.x := this.matchRes[i].imgPos.x  + this.rotPoint.x*hmi.in.par.offset.x + this.rotPoint.y*hmi.in.par.offset.y;
				this.matchRes[i].imgPos.y := this.matchRes[i].imgPos.y  + this.rotPoint.y*hmi.in.par.offset.x - this.rotPoint.x*hmi.in.par.offset.y;
			
				// Get 3d position
				brdkViCal_2dTo3d(this.matchRes[i].imgPos,this.invP,this.matchRes[i].pickPos); // Project px to mm 
				this.matchRes[i].pickPos.z := LREAL_TO_REAL(brdkViCal_2dto3dOrientation(this.matchRes[i].angle,this.invP,this.imgCenter.x,this.imgCenter.y)); 
			
				// offset shape point to result location
				IF this.shapesPx.clearenceEnd.numPoints > 0 THEN
					FOR j:=0 TO this.shapesPx.clearenceEnd.numPoints - 1 BY 1 DO
						brdkViGeom_offsetVector(-this.matchRes[i].angle, this.matchRes[i].imgPos,this.matchRes[i].shapePoints.clearenceEnd[j]);
					END_FOR
					brdkViGeom_drawSvgPoly(this.matchRes[i].shapePoints.clearenceEnd[0],this.shapesPx.clearenceEnd.numPoints, ADR(hmi.out.overlay),ADR('style="fill:yellow;stroke:yellow;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'));
				END_IF
			
				IF this.shapesPx.clearenceStart.numPoints > 0 THEN
					FOR j:=0 TO this.shapesPx.clearenceStart.numPoints - 1 BY 1 DO
						brdkViGeom_offsetVector(-this.matchRes[i].angle, this.matchRes[i].imgPos,this.matchRes[i].shapePoints.clearenceStart[j]);
					END_FOR
					brdkViGeom_drawSvgPoly(this.matchRes[i].shapePoints.clearenceStart[0],this.shapesPx.clearenceStart.numPoints, ADR(hmi.out.overlay),ADR('style="fill:yellow;stroke:yellow;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'));
				END_IF
			
				IF this.shapesPx.reference.numPoints > 0 THEN
					FOR j:=0 TO this.shapesPx.reference.numPoints - 1 BY 1 DO
						brdkViGeom_offsetVector(-this.matchRes[i].angle, this.matchRes[i].imgPos,this.matchRes[i].shapePoints.reference[j]);
					END_FOR
					brdkViGeom_drawSvgPoly(this.matchRes[i].shapePoints.reference[0],this.shapesPx.reference.numPoints, ADR(hmi.out.overlay),ADR('style="fill:green;stroke:green;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'));
				END_IF
			END_FOR
		END_IF
	END_IF // end New image results
		
	// Handle image click event
	IF hmi.in.cmd.click THEN
		hmi.in.cmd.click := FALSE;
		
		this.tmp2D.x := hmi.in.cmd.x;
		this.tmp2D.y := hmi.in.cmd.y;
		
		// If image is decoded and the size is larger than 0 then we can get the px value
		IF this.mappView.getImageArray AND 	this.imgArr.size > 0 THEN
			hmi.out.pxColor := brdkViImg_getPixel(LREAL_TO_INT(this.tmp2D.x),LREAL_TO_INT(this.tmp2D.y),this.imgArr.width,this.imgArr.pData); // Get pixel color value
		ELSE
			hmi.out.pxColor := 0;
		END_IF
		
		//convert click image coordiantes to real coordinates
		brdkViCal_2dTo3d(this.tmp2D,this.invP,hmi.out.realPos);

		hmi.out.overlay := '';
		this.tmp2D.x := this.tmp2D.x -50;
		this.tmp2D.y := this.tmp2D.y -50;
		
		brdkViGeom_drawSvgImage(ADR(this.url),this.tmp2D,ADR(''),100,100,ADR(hmi.out.overlay),ADR(''));
	END_IF
		
	this.mappView.wsPort 		:= 18001;
	this.mappView.imageFormat 	:= hmi.in.par.imgFormat;
	this.mappView.jpegQuality 	:= hmi.in.par.imgQuality;
	this.mappView.pSvgImage 	:= 0;//ADR(hmi.out.svg);
	this.mappView.pImageArray 	:= ADR(this.imgArr);
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