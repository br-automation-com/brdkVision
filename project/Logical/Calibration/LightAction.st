
ACTION LightAction: 

	 hw.out.angle[0]	:= REAL_TO_UINT(LIMIT(0,hmi.in.par.angle,135));
	hw.out.angle[1]		:= REAL_TO_UINT(LIMIT(0,180-hmi.in.par.angle,135));
 	
	CASE state OF 
		0:
			hmi.out.overlay1 := '';
			hmi.out.overlay2 := '';
			hmi.out.overlay3 := '';
			hmi.out.overlay4 := '';
			hmi.out.svg1 := '';
			hmi.out.svg2 := '';
			hmi.out.svg3 := '';
			hmi.out.svg4 := '';
			hmi.out.text1 := 'Front light';
			hmi.out.text2 := 'Backlight';
			
			state := 5;
		5:
			IF NOT hw.out.trigger  AND ((hw.in.ready[0] AND hw.in.ready[1] AND hw.in.ready[2] AND hw.in.ready[3]) OR DiagCpuIsSimulated()) AND this.mappView.status = ERR_OK THEN
				IF hmi.in.cmd.trigger THEN
					hmi.in.cmd.trigger := FALSE;
					state := 10;
					this.oldTime := hw.in.imgTime;
				END_IF
			END_IF
			
		10:
			// trigger image with nettime
			hw.out.trigger := TRUE;
			
			hw.out.enable := FALSE;
			hw.out.useRegionFeat := FALSE;
			
			hw.out.delayNettime := hw.in.nettime+ 20000;
			this.timeoutTrigger.PT := T#2000ms;
			this.timeoutTrigger.IN := TRUE;
			
			// Camera light only
			CASE hmi.in.par.LED[0] OF
				// 0 = none, 1= red, 2= green, 3= blue, 4=Lime, 5=White(99), 6=IR(100),7=UV(210)
				5:
					hw.out.ledColor[0] 	:= 99;
				6: 
					hw.out.ledColor[0] 	:= 100;
				7: 
					hw.out.ledColor[0] 	:= 210;
				ELSE
				hw.out.ledColor[0] 	:= hmi.in.par.LED[0];
			END_CASE
			
			hw.out.ledSegment 	:= 15;
			hw.out.expTime[0] 	:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			hw.out.ledColor[3] 	:= 0;
			hw.out.expTime[3] 	:= 0;

			hw.out.ledColor[2] 	:= 0;
			hw.out.expTime[2] 	:= 0;

			hw.out.ledColor[1] 	:= 0;
			hw.out.expTime[1]	:= 0;
			
			state := 20;
		
		20:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				this.mappView.pSvgImage 	:= ADR(hmi.out.svg1);
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				this.timeoutTrigger.IN := FALSE;
			
				state := 30;
			ELSIF this.timeoutTrigger.Q THEN
				state := 5;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
		
			
		30:
			this.TON_delay(IN := this.mappView.status = ERR_OK);
			
			IF (hw.in.ready[0] AND hw.in.ready[1] AND hw.in.ready[2] AND hw.in.ready[3]) AND this.TON_delay.Q THEN
				state := 40;
				this.TON_delay(IN := FALSE);
			END_IF
				
		40:
			// trigger image with nettime
			hw.out.trigger := TRUE;
			
			hw.out.enable := FALSE;
			hw.out.useRegionFeat := FALSE;
			
			hw.out.delayNettime := hw.in.nettime+ 20000;
			this.timeoutTrigger.PT := T#2000ms;
			this.timeoutTrigger.IN := TRUE;
			
			// Backlight only
			hw.out.ledColor[0] 	:= 0;
			hw.out.ledSegment 	:= 0;
			hw.out.expTime[0] 	:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			hw.out.ledColor[3] 	:= 0;
			hw.out.expTime[3] 	:= 0;
			
			hw.out.ledColor[2] 	:= 0;
			hw.out.expTime[2] 	:= 0;

			// Camera light only
			CASE hmi.in.par.LED[1] OF
				// 0 = none, 1= red, 2= green, 3= blue, 4=Lime, 5=White(99), 6=IR(100),7=UV(210)
				5:
					hw.out.ledColor[1] 	:= 99;
				6: 
					hw.out.ledColor[1] 	:= 100;
				7: 
					hw.out.ledColor[1] 	:= 210;
				ELSE
						hw.out.ledColor[1] 	:= hmi.in.par.LED[1];
			END_CASE
			
	
			hw.out.expTime[1]	:= hmi.in.par.expTime[1];
			
			state := 50;
		
		50:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				this.mappView.pSvgImage 	:= ADR(hmi.out.svg2);
				this.timeoutTrigger.IN := FALSE;
			
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				
				state := 60;
			ELSIF this.timeoutTrigger.Q THEN
				state := 5;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
		60:
			IF (hw.in.ready[0] AND hw.in.ready[1] AND hw.in.ready[2] AND hw.in.ready[3]) AND this.mappView.status = ERR_OK THEN
				state := 70;
			END_IF
				
		70:
			// trigger image with nettime
			hw.out.trigger := TRUE;
			
			hw.out.enable := FALSE;
			hw.out.useRegionFeat := FALSE;
			
			hw.out.delayNettime := hw.in.nettime+ 20000;
			this.timeoutTrigger.PT := T#2000ms;
			this.timeoutTrigger.IN := TRUE;
			
			// Barlights only
			hw.out.ledColor[0] 	:= 0;
			hw.out.ledSegment 	:= 0;
			hw.out.expTime[0] 	:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			hw.out.ledColor[1] 	:= 0;
			hw.out.expTime[1]	:= 0;
			
			CASE hmi.in.par.LED[2] OF
				// 0 = none, 1= red, 2= green, 3= blue, 4=Lime, 5=White(99), 6=IR(100),7=UV(210)
				5:
					hw.out.ledColor[2] 	:= 99;
				6: 
					hw.out.ledColor[2] 	:= 100;
				7: 
					hw.out.ledColor[2] 	:= 210;
				ELSE
						hw.out.ledColor[2] 	:= hmi.in.par.LED[2];
			END_CASE
		
			hw.out.expTime[3] := hw.out.expTime[2] 	:= hmi.in.par.expTime[2];
			hw.out.ledColor[3] 	:=hw.out.ledColor[2];

	
			
			state := 80;
		80:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				this.mappView.pSvgImage 	:= ADR(hmi.out.svg3);
				this.timeoutTrigger.IN := FALSE;
			
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				
				state := 90;
			ELSIF this.timeoutTrigger.Q THEN
				state := 5;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
		90:
			IF (hw.in.ready[0] AND hw.in.ready[1] AND hw.in.ready[2] AND hw.in.ready[3]) AND this.mappView.status = ERR_OK THEN
				state := 100;
			END_IF
				
		100:
			// trigger image with nettime
			hw.out.trigger := TRUE;
			
			hw.out.enable := FALSE;
			hw.out.useRegionFeat := FALSE;
			
			hw.out.delayNettime := hw.in.nettime+ 20000;
			this.timeoutTrigger.PT := T#2000ms;
			this.timeoutTrigger.IN := TRUE;
			
			// Backlight + barlights
			hw.out.ledColor[0] 	:= 0;
			hw.out.ledSegment 	:= 0;
			hw.out.expTime[0] 	:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			CASE hmi.in.par.LED[1] OF
				// 0 = none, 1= red, 2= green, 3= blue, 4=Lime, 5=White(99), 6=IR(100),7=UV(210)
				5:
					hw.out.ledColor[1] 	:= 99;
				6: 
					hw.out.ledColor[1] 	:= 100;
				7: 
					hw.out.ledColor[1] 	:= 210;
				ELSE
						hw.out.ledColor[1] 	:= hmi.in.par.LED[1];
			END_CASE
			hw.out.expTime[1]	:= hmi.in.par.expTime[1];
			
			CASE hmi.in.par.LED[2] OF
				// 0 = none, 1= red, 2= green, 3= blue, 4=Lime, 5=White(99), 6=IR(100),7=UV(210)
				5:
					hw.out.ledColor[2] 	:= 99;
				6: 
					hw.out.ledColor[2] 	:= 100;
				7: 
					hw.out.ledColor[2] 	:= 210;
				ELSE
						hw.out.ledColor[2] 	:= hmi.in.par.LED[2];
			END_CASE
		
			hw.out.expTime[3] := hw.out.expTime[2] 	:= hmi.in.par.expTime[2];
			hw.out.ledColor[3] 	:=hw.out.ledColor[2];
			 
			
			
			state := 110;
		110:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				this.mappView.pSvgImage 	:= ADR(hmi.out.svg4);
				this.timeoutTrigger.IN := FALSE;
			
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				
				state := 5;
			ELSIF this.timeoutTrigger.Q THEN
				state := 5;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
	END_CASE
	this.timeoutTrigger();
END_ACTION
