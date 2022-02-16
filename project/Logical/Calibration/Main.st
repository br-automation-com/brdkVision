
PROGRAM _INIT
	(* Insert code here *)
	hmi.in.par.expTime := 700;
	hmi.in.par.focus := 411;
	hmi.in.par.LED := 1;
	
	
	this.mappView.enable 		:= TRUE;
	this.mappView.cameraIp 		:= '192.168.200.1';
	this.mappView.getImageArray := FALSE;
	this.mappView.timeout 		:= 3000;
	
	this.mpRecipeRegPar.MpLink := ADR(gRecipeCsv);
	this.mpRecipeRegPar.PVName := ADR('::Calibratio:hmi.in.par');
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	// trigger image
	hw.out.ledColor 	:= hmi.in.par.LED;
	hw.out.ledSegment 	:= hmi.in.par.LEDsegment;
	hw.out.expTime 		:= hmi.in.par.expTime;
	hw.out.focus 		:= hmi.in.par.focus;
	hw.out.irFilter 	:= hw.out.ledColor = 100;

	CASE state OF 
		0:
			IF NOT hw.out.trigger  AND hw.in.ready THEN
				IF hmi.in.cmd.calibrate THEN
					// for calibration we only look for 4 round Blobs
					hw.out.numMax := 4;
					hw.out.enable := TRUE;
					hw.out.useRegionFeat := TRUE;
					
					state := 10;
				ELSIF hmi.in.cmd.trigger THEN
					hw.out.enable := FALSE;
					hw.out.useRegionFeat := FALSE;
					state := 10;
				END_IF
			END_IF
			
		10:
			// trigger image with nettime
			hw.out.trigger := TRUE;
			hw.out.delayNettime := hw.in.nettime+ 20000;
			this.timeoutTrigger.PT := T#2000ms;
			this.timeoutTrigger.IN := TRUE;
			
			state := 20;
		
		20:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				
				// check if its a calibration or its a pick result image
				IF hmi.in.cmd.calibrate THEN
					IF hw.in.va.numRes = 4  THEN
						this.calcCalibrate := TRUE;
					END_IF
				ELSE
					this.getPicks := TRUE;
				END_IF
				
				hmi.in.cmd.trigger := hmi.in.cmd.calibrate := FALSE;
				hw.out.trigger := FALSE;
				
				state := 0;
			ELSIF this.timeoutTrigger.Q THEN
				state := 0;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := hmi.in.cmd.calibrate := FALSE;
				hw.out.trigger := FALSE;
			END_IF
			
	END_CASE
	this.timeoutTrigger();
	
	
	// Process the picks
	IF this.getPicks THEN
		this.getPicks := FALSE;
		
		// reset current results
		brsmemset(ADR(this.matchRes),0,SIZEOF(this.matchRes));
		hmi.out.overlay := '';
		
		// Process each result from the VF
		FOR i:= 0 TO hw.in.VA_match.numRes BY 1 DO
			
			// convert to decimal numbers (and offset andge)
			this.matchRes[i].imgPos.x := DINT_TO_REAL(hw.in.VA_match.res[i].posX) / 100.0;
			this.matchRes[i].imgPos.y := DINT_TO_REAL(hw.in.VA_match.res[i].posX) / 100.0;
			this.matchRes[i].angle := DINT_TO_REAL(hw.in.VA_match.res[i].angle) / 100.0 + hmi.in.par.offset.z;
			
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
	
	// check that we only have 4 results
	IF this.calcCalibrate THEN
		this.calcCalibrate := FALSE;
		// Transfer VA results to 2 image points
		FOR i:=0 TO 3 BY 1 DO
			this.imgPos[i].x := DINT_TO_LREAL(hw.in.va.res[i].posX) /100.0; // px
			this.imgPos[i].y := DINT_TO_LREAL(hw.in.va.res[i].posY) /100.0; // px
			
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
				
		brdkViCal_Calibration(this.realPos[0],this.imgPos[0],4,hmi.in.par.P);
		
		hmi.out.overlay := '';
		brdkViGeom_drawCalibration(hmi.in.par.P,75,this.realPos[0],4,ADR(hmi.out.overlay),ADR('style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'),ADR('style="fill:red;stroke:red;stroke-width:5;fill-opacity:1;stroke-opacity:1"'));
		
	END_IF
	
	// Handle image click event
	IF hmi.in.cmd.click THEN
		hmi.in.cmd.click := FALSE;
		
		this.tmp2D.x := hmi.in.cmd.x;
		this.tmp2D.y := hmi.in.cmd.y;
		
		// get invers projection matix (only need to be done one time as the projection matrix only changes if a new calibration is done
		brdkViCal_InvP(hmi.in.par.P,this.invP);
		
		// from image to real coordinates
		brdkViCal_2dTo3d(this.tmp2D,this.invP,hmi.out.realPos);
	END_IF
	
		
	
	this.mappView.imageFormat 	:= hmi.in.par.imgFormat;
	this.mappView.jpegQuality 	:= hmi.in.par.imgQuality;
	this.mappView.pSvgImage 	:= ADR(hmi.out.svg);
	this.mappView.pImageArray 	:= ADR(this.imgArr);
	this.mappView();
	
	// recipe
	this.mpRecipeRegPar.ConfirmSave := this.mpRecipeRegPar.SaveNotification;
	this.mpRecipeRegPar(Enable := TRUE);
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	this.mappView(enable := FALSE);
	this.mpRecipeRegPar(Enable := FALSE);
END_PROGRAM

