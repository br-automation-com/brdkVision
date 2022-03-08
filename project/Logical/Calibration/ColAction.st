
ACTION ColAction:
	
	CASE state OF 
		0:
			IF NOT hw.out.trigger  AND (hw.in.ready[0] OR DiagCpuIsSimulated()) THEN
				IF hmi.in.cmd.trigger THEN
					state := 10;
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
			hw.out.ledColor[0] 	:= 1;
			hw.out.ledSegment 	:= hmi.in.par.LEDsegment;
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
				
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				
				state := 30;
			ELSIF this.timeoutTrigger.Q THEN
				state := 0;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
		
		30:
			IF (hw.in.ready[0] AND hw.in.ready[1] AND hw.in.ready[2] AND hw.in.ready[3]) THEN
				state := 40;
			END_IF
				
		40:
			// trigger image with nettime
			hw.out.trigger := TRUE;
			
			hw.out.enable := FALSE;
			hw.out.useRegionFeat := FALSE;
			
			hw.out.delayNettime := hw.in.nettime+ 20000;
			this.timeoutTrigger.PT := T#2000ms;
			this.timeoutTrigger.IN := TRUE;
			
			// Camera light only
			hw.out.ledColor[0] 	:= 2;
			hw.out.ledSegment 	:= hmi.in.par.LEDsegment;
			hw.out.expTime[0] 	:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			hw.out.ledColor[3] 	:= 0;
			hw.out.expTime[3] 	:= 0;

			hw.out.ledColor[2] 	:= 0;
			hw.out.expTime[2] 	:= 0;

			hw.out.ledColor[1] 	:= 0;
			hw.out.expTime[1]	:= 0;
			
			state := 50;
		
		50:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				
				state := 60;
			ELSIF this.timeoutTrigger.Q THEN
				state := 0;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
		60:
			IF (hw.in.ready[0] AND hw.in.ready[1] AND hw.in.ready[2] AND hw.in.ready[3]) THEN
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
			
			// Camera light only
			hw.out.ledColor[0] 	:= 3;
			hw.out.ledSegment 	:= hmi.in.par.LEDsegment;
			hw.out.expTime[0] 	:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			hw.out.ledColor[3] 	:= 0;
			hw.out.expTime[3] 	:= 0;

			hw.out.ledColor[2] 	:= 0;
			hw.out.expTime[2] 	:= 0;

			hw.out.ledColor[1] 	:= 0;
			hw.out.expTime[1]	:= 0;
			
			state := 80;
		80:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				
				state := 90;
			ELSIF this.timeoutTrigger.Q THEN
				state := 0;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
		90:
			IF (hw.in.ready[0] AND hw.in.ready[1] AND hw.in.ready[2] AND hw.in.ready[3]) THEN
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
			
			// Camera light only
			hw.out.ledColor[0] 	:= 4;
			hw.out.ledSegment 	:= hmi.in.par.LEDsegment;
			hw.out.expTime[0] 	:= hmi.in.par.expTime[0];
		
			hw.out.irFilter 	:= hw.out.ledColor[0] = 100;

			hw.out.ledColor[3] 	:= 0;
			hw.out.expTime[3] 	:= 0;

			hw.out.ledColor[2] 	:= 0;
			hw.out.expTime[2] 	:= 0;

			hw.out.ledColor[1] 	:= 0;
			hw.out.expTime[1]	:= 0;
			
			state := 110;
		110:
			// check if a new image is done
			IF hw.in.imgTime <> this.oldTime OR DiagCpuIsSimulated() THEN
				this.oldTime := hw.in.imgTime;
				this.mappView.updateImage := TRUE;
				
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
				
				state := 0;
			ELSIF this.timeoutTrigger.Q THEN
				state := 0;
				this.timeoutTrigger.IN := hw.out.trigger := FALSE;
				hmi.in.cmd.trigger := FALSE;
				hw.out.trigger := FALSE;
			END_IF
	END_CASE
	this.timeoutTrigger();

END_ACTION
