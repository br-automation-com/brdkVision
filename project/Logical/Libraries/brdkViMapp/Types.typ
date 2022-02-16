
TYPE
	brdkViMapp_VF_typ : 	STRUCT  (*mappView vision function type.*)
		widgetModels : STRING[150000]; (*Models of widgets in vision function.*)
		ROI : STRING[150000]; (*Region of Interest.*)
		params : STRING[1000]; (*Parameters of vision function.*)
	END_STRUCT;
END_TYPE
