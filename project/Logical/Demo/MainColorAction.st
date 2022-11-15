ACTION mainColorAction:
	// always update pointers in case of copy download without execution of init/exit
	this.imgTrig.pCameraHw := ADR(hw.cam);
	this.imgTrig.pLightHw := 0;
	this.imgTrig.numLights := 0;
	this.getImage.timeout := t#1s;
	// trigger image
	hw.cam.out.par.flashSegment	:= hmi.in.par.LEDsegment;
	hw.cam.out.par.focus 		:= hmi.in.par.focus;
	hw.cam.out.par.IRFilter 	:= hw.cam.out.par.flashColor = BRDKVIBASE_CAM_LED_IR;

	// handles triggering af images 
	this.imgTrig.pLightHw := ADR(hw.backLight); // pointer to light structure or light structure array if more than one
	this.imgTrig.numLights := 1; //Number of lights
	this.imgTrig.useCamColorForLight := TRUE; // set Lights to same color as Camera 
	this.imgTrig.useCamExpTimeForLight := TRUE; // Set light exposure time to same as camera
	this.imgTrig();
					
	// Check for new image result
	IF this.imgTrig.newImage OR (this.imgTrig.trigger AND DiagCpuIsSimulated()) THEN
		this.getImage.getImage := TRUE; // Trigger an update of the image on HMI
	END_IF
	
	
	IF state > 0 AND state < 120  THEN
		this.cycleCnt := this.cycleCnt+1;
	END_IF
	
	CASE state OF
		0:
			
			IF ((this.imgTrig.ready AND NOT this.imgTrig.busy) OR DiagCpuIsSimulated()) AND hmi.in.cmd.trigger THEN // camera is ready for new trigger
				this.cycleCnt := 0;
				hmi.in.cmd.trigger 			:= FALSE;
				this.imgTrig.trigger 		:= TRUE;
				hw.cam.out.par.flashColor 	:= BRDKVIBASE_CAM_LED_RED;
				hw.cam.out.par.exposureTime	:= REAL_TO_UDINT(UDINT_TO_REAL(brdkViBase_LEDIntensity(2, hmi.in.par.focus, hmi.in.par.expTime,BRDKVIBASE_CAM_LED_RED,BRDKVIBASE_CAM_LED_RED))*correcColor[0]); //;
				this.imgTrig.delayNettime 	:= hw.io.input.nettime + 8000; // add 50ms
				state := 10;
			
			END_IF
		
		10:
			IF this.getImage.getImage THEN // image have been caputured and download has begun
				
				state := 20;
			END_IF
			
		20:
			IF this.getImage.status = ERR_OK THEN // Image download from camera has finished
				this.sendBufLen := 0; // Clear frame for new
				brdkViImg_WsMakeFrame(ADR('RED'),3,ADR(this.sendBuf),ADR(this.sendBufLen),TRUE);
				brdkViImg_WsMakeFrame(this.getImage.pDest,this.getImage.destLen ,ADR(this.sendBuf),ADR(this.sendBufLen),FALSE);	
				state := 100;
			ELSIF this.getImage.status = ERR_NO_IMAGE THEN
				this.imgTrig.trigger 		:= TRUE;
				hw.cam.out.par.flashColor 	:= BRDKVIBASE_CAM_LED_RED;
				hw.cam.out.par.exposureTime	:= REAL_TO_UDINT(UDINT_TO_REAL(brdkViBase_LEDIntensity(2, hmi.in.par.focus, hmi.in.par.expTime,BRDKVIBASE_CAM_LED_RED,BRDKVIBASE_CAM_LED_RED))*correcColor[0]); //;
				this.imgTrig.delayNettime 	:= hw.io.input.nettime + 8000; // add 50ms
				
				state := 10;
			END_IF
		100:
	
			IF ((this.imgTrig.ready AND NOT this.imgTrig.busy) OR DiagCpuIsSimulated()) THEN
				hmi.in.cmd.trigger 			:= FALSE;
				this.imgTrig.trigger 		:= TRUE;
				hw.cam.out.par.exposureTime	:= REAL_TO_UDINT(UDINT_TO_REAL(brdkViBase_LEDIntensity(2, hmi.in.par.focus, hmi.in.par.expTime,BRDKVIBASE_CAM_LED_RED,BRDKVIBASE_CAM_LED_GREEN))*correcColor[1]); 
				hw.cam.out.par.flashColor 	:= BRDKVIBASE_CAM_LED_GREEN;
				this.imgTrig.delayNettime 	:= hw.io.input.nettime + 8000; // add 50ms
				state := 110;
			END_IF
		
		110:
			IF this.getImage.getImage THEN
				state := 115;
			END_IF
		115:
	
			IF this.getImage.status = ERR_OK THEN
			
				
				brdkViImg_WsMakeFrame(ADR('Green'),5,ADR(this.sendBuf),ADR(this.sendBufLen),TRUE);
				brdkViImg_WsMakeFrame(this.getImage.pDest,this.getImage.destLen ,ADR(this.sendBuf),ADR(this.sendBufLen),FALSE);
			
				state := 120;
//				IF this.getImage.getImage THEN
//					state := 220;
//				ELSE
//					state := 200;			
//				END_IF
			ELSIF this.getImage.status = ERR_NO_IMAGE THEN
				this.imgTrig.trigger 		:= TRUE;
				hw.cam.out.par.exposureTime	:= REAL_TO_UDINT(UDINT_TO_REAL(brdkViBase_LEDIntensity(2, hmi.in.par.focus, hmi.in.par.expTime,BRDKVIBASE_CAM_LED_RED,BRDKVIBASE_CAM_LED_GREEN))*correcColor[1]); 
				hw.cam.out.par.flashColor 	:= BRDKVIBASE_CAM_LED_GREEN;
				this.imgTrig.delayNettime 	:= hw.io.input.nettime + 8000; // add 50ms
				
				state := 100;
			END_IF
		120:
			IF ((this.imgTrig.ready AND NOT this.imgTrig.busy) OR DiagCpuIsSimulated()) THEN
				hmi.in.cmd.trigger 			:= FALSE;
				this.imgTrig.trigger 		:= TRUE;
				hw.cam.out.par.exposureTime	:= REAL_TO_UDINT(UDINT_TO_REAL(brdkViBase_LEDIntensity(2, hmi.in.par.focus, hmi.in.par.expTime,BRDKVIBASE_CAM_LED_RED,BRDKVIBASE_CAM_LED_BLUE))*correcColor[2]);
				hw.cam.out.par.flashColor 	:= BRDKVIBASE_CAM_LED_BLUE;
				this.imgTrig.delayNettime 	:= hw.io.input.nettime + 8000; // add 50ms
				state := 200;
			END_IF
		
			
			
		200:
			IF this.getImage.getImage THEN
				state := 220;
			END_IF
			
			
		220:
			IF this.getImage.status = ERR_OK AND NOT this.tcpServer.tcpSend.enable THEN
					state := 0;
				
					brdkViImg_WsMakeFrame(ADR('BLUE'),4,ADR(this.sendBuf),ADR(this.sendBufLen),TRUE);
					brdkViImg_WsMakeFrame(this.getImage.pDest,this.getImage.destLen ,ADR(this.sendBuf),ADR(this.sendBufLen),FALSE);
					brdkViImg_WsMakeFrame(ADR('Done'),4,ADR(this.sendBuf),ADR(this.sendBufLen),TRUE);
					
					FOR i :=0 TO UDINT_TO_USINT(BRDKVIIMG_WS_MAX_NUM_CLIENTS) BY 1 DO
						IF this.wsChannels[i].enable THEN
							this.wsChannels[i].pSendData 	:= ADR(this.sendBuf);
							this.wsChannels[i].sendLen 		:= this.sendBufLen;
							this.wsChannels[i].doSend 		:= TRUE;
							END_IF
					END_FOR
						
						
			
				
			
			ELSIF this.getImage.status = ERR_NO_IMAGE THEN
				
				this.imgTrig.trigger 		:= TRUE;
				hw.cam.out.par.exposureTime	:= REAL_TO_UDINT(UDINT_TO_REAL(brdkViBase_LEDIntensity(2, hmi.in.par.focus, hmi.in.par.expTime,BRDKVIBASE_CAM_LED_RED,BRDKVIBASE_CAM_LED_BLUE))*correcColor[2]);
				hw.cam.out.par.flashColor 	:= BRDKVIBASE_CAM_LED_BLUE;
				this.imgTrig.delayNettime 	:= hw.io.input.nettime + 8000; // add 50ms
				state := 200;
			
			END_IF			
	END_CASE
	//	
	
	this.wsServer.enable := TRUE;
	this.wsServer.pIfAddr := 0;
	this.wsServer.port := 18070;
	this.wsServer();
	
	IF this.wsServer.enable THEN
		FOR i := 0 TO UDINT_TO_USINT(BRDKVIIMG_WS_MAX_NUM_CLIENTS) BY 1 DO
			IF this.wsServer.clients[i] <> 0 THEN
				this.wsChannels[i].enable 			:=  TRUE;
				this.wsChannels[i].ident 			:= this.wsServer.clients[i];
				this.wsChannels[i].bufferSize 		:= BRDKVIIMG_WS_BUFFER_SIZE;
				this.wsChannels[i].parentServer 	:= ADR(this.wsServer);
				this.wsChannels[i].pRecvData 		:= ADR(this.wsRecData[i,0]);
			ELSE
				this.wsChannels[i].enable 			:=  FALSE;
			END_IF
			this.wsChannels[i]();
			
		END_FOR
	END_IF
	

	// Function to retrieve image from camera to show on HMI
	this.getImage.enable := TRUE;
	this.getImage.pMappLink := ADR(gBlobCamera);
	this.getImage.imageFormat 	:= hmi.in.par.imgFormat;
	this.getImage.jpegQuality 	:= hmi.in.par.imgQuality;
	this.getImage.simulateConfig.activate := DiagCpuIsSimulated(); // true if PLC is simulated
	this.getImage.simulateConfig.appendNumber := TRUE; // If true number is appended to file name
	this.getImage.simulateConfig.minNumber := 1; // Min number to append
	this.getImage.simulateConfig.maxNumber := 3; // Max number to append
	this.getImage.simulateConfig.autoIncrementNumber := TRUE; // Automatically Increment number
	this.getImage.simulateConfig.pDevice := ADR(this.simFileDevice); // Pointer to file device name where simulation images are located
	this.getImage.simulateConfig.pFile := ADR(this.simFilename); // pointer to filename string (with out file extension, which come from seleted image type Jpeg or BMP) where number is appended to
	this.getImage();
	
	this.mappView(enable := FALSE); // Do not use as we get the images with getImage and send them as binary with wsServer and brdkViImg_WsMakeFrame
	
	// recipe
	this.mpRecipeRegPar.ConfirmSave := this.mpRecipeRegPar.SaveNotification;
	this.mpRecipeRegPar(Enable := TRUE);
	
END_ACTION

