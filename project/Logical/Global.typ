
TYPE
	gVisionCtrl_type : STRUCT
		Cmd : gVisionCtrlPar_type;
		Parameters : gVisionCtrlPar_type;
		Status : gVisionCtrlStatus_type;
	END_STRUCT;
	gVisionCtrlCmd_type : STRUCT
		ImageAcquisition : BOOL;
		ImageProcessingActive : BOOL;
		SearchAcquisitionSettings : BOOL;
		Enable : BOOL;
	END_STRUCT;
	gVisionCtrlPar_type : STRUCT
		FlashColor : USINT;
		FlashSegment : USINT;
		SetFocus : UINT;
		ExposureTime : UDINT;
		NumSearchMax : USINT;
		Nettime : DINT;
		DelayNettime : DINT;
	END_STRUCT;
	gVisionCtrlStatus_type : STRUCT 
		Status : USINT;
		CameraStatus : UDINT;
	END_STRUCT;
END_TYPE
