
PROGRAM _INIT
	(* Insert code here *)
	// Init camera settings
	hmi.in.par.expTime := 700;
	hmi.in.par.focus := 411;
	hmi.in.par.LED := 1;
	hmi.in.par.LEDsegment := 15;
	
	this.mpRecipeRegPar.MpLink := ADR(gRecipeCsv);
	this.mpRecipeRegPar.PVName := ADR('::Demo:hmi.in.par');
	
END_PROGRAM

PROGRAM _CYCLIC
	

	CASE hmi.in.cmd.mode OF
		0: // Simple mode 
			mainSimpleAction;
		1: // calibration Example
			mainCalibrationAction;
		
		2: 
			mainColorAction;
	END_CASE
	
	this.viBaseSave(MpLink := ADR(gBlobCamera));
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	this.mappView(enable := FALSE);
	this.getImage(enable := FALSE);
	this.mpRecipeRegPar(Enable := FALSE);
	
	IF this.wsServer.enable THEN
		FOR i := 0 TO UDINT_TO_USINT(BRDKVIIMG_WS_MAX_NUM_CLIENTS) BY 1 DO
			IF this.wsChannels[i].enable THEN
				this.wsChannels[i](enable 			:=  FALSE);
			END_IF
		END_FOR
		this.wsServer(enable := FALSE);

	END_IF
	
	
END_PROGRAM

