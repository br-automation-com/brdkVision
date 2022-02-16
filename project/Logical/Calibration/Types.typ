
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
	cam_in_match_typ : 	STRUCT 
		numRes : USINT;
		res : ARRAY[0..19]OF match_res_typ;
	END_STRUCT;
	cam_in_typ : 	STRUCT 
		imgTime : DINT;
		ready : BOOL;
		va : va_res_typ;
		nettime : DINT;
		VA_match : cam_in_match_typ;
	END_STRUCT;
	cam_out_match_typ : 	STRUCT 
		maxNum : USINT;
		enable : BOOL;
		timeout : UINT;
		maxOverlap : USINT;
		minScore : USINT;
	END_STRUCT;
	cam_out_typ : 	STRUCT 
		expTime : UDINT := 400;
		ledSegment : USINT := 15;
		ledColor : USINT := 100;
		focus : UINT := 150;
		enable : BOOL := TRUE;
		enableEnhanced : BOOL := TRUE;
		numMax : USINT := 4;
		trigger : BOOL;
		irFilter : BOOL;
		delayNettime : DINT;
		useRegionFeat : BOOL;
		VA_match : cam_out_match_typ;
	END_STRUCT;
	cam_typ : 	STRUCT 
		out : cam_out_typ;
		in : cam_in_typ;
	END_STRUCT;
	hmi_in_cmd_typ : 	STRUCT 
		trigger : BOOL;
		calibrate : BOOL;
		elemId : STRING[80];
		y : REAL;
		x : REAL;
		click : BOOL;
	END_STRUCT;
	hmi_in_typ : 	STRUCT 
		cmd : hmi_in_cmd_typ;
		par : recipe_typ;
	END_STRUCT;
	hmi_out_typ : 	STRUCT 
		overlay : STRING[20000];
		svg : STRING[6000000];
		realPos : brdkViBase_3d_typ;
	END_STRUCT;
	hmi_typ : 	STRUCT 
		in : hmi_in_typ;
		out : hmi_out_typ;
	END_STRUCT;
	hw_typ : 	STRUCT 
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
		mappView : brdkViImg_mappView;
		imgArr : brdkVIImg_imageArray_typ;
		svgOverlay : STRING[5000];
		timeoutTrigger : TON;
		matchRes : ARRAY[0..19]OF pnp_vision_result_typ;
		rotPoint : brdkViBase_2d_typ;
		shapesPx : recipe_shapes_typ;
		getPicks : BOOL;
		mpRecipeRegPar : MpRecipeRegParSync;
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
	END_STRUCT;
	va_res_typ : 	STRUCT 
		numRes : USINT;
		res : ARRAY[0..19]OF blob_res_typ;
	END_STRUCT;
END_TYPE
