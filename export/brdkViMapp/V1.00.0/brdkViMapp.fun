
FUNCTION brdkViMapp_getVfDataSet : BOOL (*Function to get the vision function data set*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision function name*)
		VFidx : USINT := 1; (*Index of vision function in the vision application file.*)
		pParam : UDINT; (*pointer to string (need to be a very long string)*)
		pROI : UDINT; (*pointer to string (need to be a very long string)*)
		pWidgetModels : UDINT; (*pointer to string (need to be a very long string)*)
		maxLen : UDINT; (*Max length of the strings*)
		pError : UDINT; (*Pointer to error when failing to get parameters of the vision function.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViMapp_setVfDataSet : BOOL (*Function to set the vision function data set*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		VaName : STRING[20]; (*Vision function name*)
		VFidx : USINT := 1; (*Index of vision function in the vision application file.*)
		pParam : UDINT; (*Pointer to string containing parameters of the vision function (need to be a very long string)*)
		pROI : UDINT; (*Pointer to string containing Region of Interest(s) (need to be a very long string)*)
		pWidgetModels : UDINT; (*Pointer to string of Widget Models (need to be a very long string)*)
		pError : UDINT; (*Pointer to error when setting parameters in the VF data set.*)
	END_VAR
END_FUNCTION
