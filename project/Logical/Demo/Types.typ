
TYPE
	match_res_typ : 	STRUCT 
		score : USINT;
		angle : INT;
		posY : DINT;
		posX : DINT;
	END_STRUCT;
	blob_res_typ : 	STRUCT 
		width : UDINT;
		maxX : DINT;
		minX : DINT;
		length : UDINT;
		posY : DINT;
		posX : DINT;
	END_STRUCT;
END_TYPE

(*Insert your comment here.*)

TYPE
	hmi_in_cmd_typ : 	STRUCT 
		trigger : BOOL;
		calibrate : BOOL;
		elemId : STRING[80];
		y : REAL;
		x : REAL;
		click : BOOL;
		mode : USINT;
		useOPCua : BOOL := TRUE;
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		cmd : hmi_in_cmd_typ;
		par : recipe_typ;
	END_STRUCT;
	hmi_out_color_typ : 	STRUCT 
		red : STRING[6000000];
		green : STRING[6000000];
		blue : STRING[6000000];
	END_STRUCT;
	hmi_out_typ : 	STRUCT 
		overlay : STRING[20000];
		svg : STRING[6000000];
		realPos : brdkViBase_3d_typ;
		pxColor : USINT;
		color : hmi_out_color_typ;
	END_STRUCT;
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
	END_STRUCT;
	hw_io_input_typ : 	STRUCT 
		nettime : DINT;
	END_STRUCT;
	hw_io_typ : 	STRUCT 
		input : hw_io_input_typ;
	END_STRUCT;
	hw_typ : 	STRUCT 
		io : hw_io_typ;
		cam : brdkViBase_cam_hw_typ;
		backLight : ARRAY[0..0]OF brdkViBase_light_hw_typ;
		blob : brdkViBase_hw_blob_50_typ;
	END_STRUCT;
	local_tcpServer_typ : 	STRUCT 
		clientIp : STRING[20];
		tcpSend : TcpSend;
	END_STRUCT;
	local_typ : 	STRUCT 
		realPos : ARRAY[0..3]OF brdkViBase_3d_typ;
		imgPos : ARRAY[0..3]OF brdkViBase_2d_typ;
		invP : ARRAY[0..2,0..2]OF LREAL;
		imgCenter : brdkViBase_2d_typ;
		tmp2D1 : brdkViBase_2d_typ;
		tmp2D : brdkViBase_2d_typ;
		tmp3D : brdkViBase_3d_typ;
		tmpLREAL : LREAL;
		imgHeight : LREAL := 1024;
		imgWidth : LREAL := 1250;
		calcCalibrate : BOOL;
		oldTime : DINT;
		getImage : brdkViImg_getImage;
		mappView : brdkViImg_mappView;
		imgArr : brdkVIImg_imageArray_typ;
		svgOverlay : STRING[5000];
		timeoutTrigger : TON;
		matchRes : ARRAY[0..19]OF pnp_vision_result_typ;
		rotPoint : brdkViBase_2d_typ;
		shapesPx : recipe_shapes_typ;
		getPicks : BOOL;
		mpRecipeRegPar : MpRecipeRegParSync;
		simFileDevice : STRING[10] := 'SIM';
		simFilename : STRING[100] := 'test';
		text : STRING[200] := 'this is a great test$NWith both new lines$N       and many white spaces';
		url : STRING[200] := 'Media/crossAir.png ';
		imgTrig : brdkViBase_imgTrigger;
		isCalibration : BOOL;
		cycleCnt : UDINT;
		sendBufLen : UDINT;
		tcpServer : local_tcpServer_typ;
		sendBuf : ARRAY[0..5000000]OF USINT;
		recvBuf : ARRAY[0..9999]OF USINT;
		wsRecData : ARRAY[0..BRDKVIIMG_WS_MAX_NUM_CLIENTS,0..199]OF USINT;
		wsChannels : ARRAY[0..BRDKVIIMG_WS_MAX_NUM_CLIENTS]OF brdkViImg_WsChannel;
		wsServer : brdkViImg_WsServer;
		wsSvg : STRING[6000000];
	END_STRUCT;
	pnp_vision_results_shapeP_typ : 	STRUCT 
		reference : ARRAY[0..MAX_SHAPE_POINTS]OF brdkViBase_2d_typ;
		clearenceStart : ARRAY[0..MAX_SHAPE_POINTS]OF brdkViBase_2d_typ;
		clearenceEnd : ARRAY[0..MAX_SHAPE_POINTS]OF brdkViBase_2d_typ;
	END_STRUCT;
	pnp_vision_result_typ : 	STRUCT 
		pickPos : brdkViBase_3d_typ;
		imgPos : brdkViBase_2d_typ;
		ok : BOOL;
		angle : LREAL;
		shapePoints : pnp_vision_results_shapeP_typ;
	END_STRUCT;
	recipe_shapes_typ : 	STRUCT 
		reference : brdkViGeom_shape_typ;
		clearenceStart : brdkViGeom_shape_typ;
		clearenceEnd : brdkViGeom_shape_typ;
	END_STRUCT;
	recipe_typ : 	STRUCT 
		LEDsegment : USINT;
		focus : UINT; (*250*)
		expTime : DINT; (*50*)
		LED : USINT; (*1*)
		offset : brdkViBase_3d_typ;
		shapes : USINT;
		P : ARRAY[0..2,0..3]OF LREAL;
		imgQuality : USINT := 30;
		imgFormat : BRDKVIIMG_IMG_TYPE := BRDKVIIMG_IMG_TYPE_JPEG;
		wsPort : UINT := 18000;
	END_STRUCT;
	va_res_typ : 	STRUCT 
		numRes : USINT;
		res : ARRAY[0..19]OF blob_res_typ;
	END_STRUCT;
END_TYPE
