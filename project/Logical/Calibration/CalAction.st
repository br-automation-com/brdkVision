
ACTION CalAction: 

	CASE state OF 
		0:
			IF NOT hw.out.trigger  AND (hw.in.ready[0] OR DiagCpuIsSimulated()) THEN
(*				IF hmi.in.cmd.calibrate THEN
					// for calibration we only look for 4 round Blobs
					
					
					state := 10;*)
				IF hmi.in.cmd.trigger THEN
					state := 10;
				END_IF
			END_IF
			
		10:
			// trigger image with nettime
			hw.out.trigger := TRUE;
			
			hw.out.numMax := 4;
			hw.out.enable := TRUE;
			hw.out.useRegionFeat := TRUE;
			
			hw.out.delayNettime := hw.in.nettime+ 20000;
			this.timeoutTrigger.PT := T#2000ms;
			this.timeoutTrigger.IN := TRUE;
			
			hw.out.ledColor[0] 	:= 0;
			hw.out.ledSegment 	:= hmi.in.par.LEDsegment;
			hw.out.expTime[0] 		:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			hw.out.ledColor[3] 	:= 0;
			hw.out.expTime[3] 	:= hmi.in.par.expTime[3];
			// TODO
			// hw.out.angle[1]		:= 

			hw.out.ledColor[2] 	:= 0;
			hw.out.expTime[2] 	:= hmi.in.par.expTime[2];
			// TODO
			// hw.out.angle[0]		:= 

			hw.out.ledColor[1] 	:= hmi.in.par.LED[1];
			hw.out.expTime[1]	:= hmi.in.par.expTime[1];
			
			state := 20;
		
		20:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				this.mappView.pSvgImage 	:= ADR(hmi.out.svg1);
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			
				IF hw.in.VA_match.numRes = 4 THEN
					state := 30;
				ELSE
					state := 0;
				END_IF	
			ELSIF this.timeoutTrigger.Q THEN
				state := 0;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
		
		30:
			
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
		
			hmi.out.overlay1 := '';
			brdkViGeom_drawCalibration(hmi.in.par.P,75,this.realPos[0],4,ADR(hmi.out.overlay1),ADR('style="fill:blue;stroke:blue;stroke-width:5;fill-opacity:0.3;stroke-opacity:1"'),ADR('style="fill:red;stroke:red;stroke-width:5;fill-opacity:1;stroke-opacity:1"'));
			state := 0;
	END_CASE
	
	// Handle image click event
	IF hmi.in.cmd.click THEN
		hmi.in.cmd.click := FALSE;
		
		this.tmp2D.x := hmi.in.cmd.x;
		this.tmp2D.y := hmi.in.cmd.y;
		
		// get invers projection matix (only need to be done one time as the projection matrix only changes if a new calibration is done
		brdkViCal_InvP(hmi.in.par.P,this.invP);

		// from image to real coordinates
		brdkViCal_2dTo3d(this.tmp2D,this.invP,hmi.out.realPos);


		hmi.out.overlay1 := '';
		this.tmp2D.x := this.tmp2D.x -50;
		this.tmp2D.y := this.tmp2D.y -50;
		
		brdkViGeom_drawSvgImage(ADR(this.url),this.tmp2D,ADR(''),100,100,ADR(hmi.out.overlay1),ADR(''));
		this.tmp2D.x := this.tmp2D.x +100;
		this.tmp2D.y := this.tmp2D.y +100;
		
		
	
	END_IF
	
	this.timeoutTrigger();
END_ACTION
