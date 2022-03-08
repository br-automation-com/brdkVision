
PROGRAM _INIT
	(* Insert code here *)
	hmi.in.par.expTime[0] := 700;
	hmi.in.par.focus := 411;
	hmi.in.par.LED[0] := 1;
	
	
	this.mappView.enable 		:= TRUE;
	this.mappView.cameraIp 		:= '192.168.200.1';
	this.mappView.getImageArray := FALSE;
	this.mappView.timeout 		:= 3000;
	this.mappView.simulateConfig.appendNumber := TRUE;
	this.mappView.simulateConfig.minNumber := 1;
	this.mappView.simulateConfig.maxNumber := 3;
	this.mappView.simulateConfig.autoIncrementNumber := TRUE;
	this.mappView.simulateConfig.pDevice := ADR(this.simFileDevice);
	this.mappView.simulateConfig.pFile := ADR(this.simFilename);
	
	this.mpRecipeRegPar.MpLink := ADR(gRecipeCsv);
	this.mpRecipeRegPar.PVName := ADR('::Calibratio:hmi.in.par');
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	// trigger image
	hw.out.focus 		:= hmi.in.par.focus;
	
	IF hmi.in.cmd.visFunc <> this.oldVisFunc THEN
		state := 0;
		this.oldVisFunc := hmi.in.cmd.visFunc;
	END_IF
	
	CASE hmi.in.cmd.visFunc OF
		VIS_FUNC_LIGHT: 
			LightAction;
			
		VIS_FUNC_CAL:
			CalAction;
			
		VIS_FUNC_COL:
			ColAction;
			
		VIS_FUNC_MEASURE:
			MeasureAction;
			
		VIS_FUNC_MATCH:
			MatchAction;
			
		VIS_FUNC_OCR:
			OCRAction;
			
	END_CASE
	
	(*
			CAN BE USED FOR MATCHING
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
	*)
	

	
		
	
		this.mappView.imageFormat 	:= hmi.in.par.imgFormat;
		this.mappView.jpegQuality 	:= hmi.in.par.imgQuality;
		
		this.mappView.pImageArray 	:= ADR(this.imgArr);
		this.mappView.simulateConfig.activate := DiagCpuIsSimulated(); // true if PLC is simulated
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

