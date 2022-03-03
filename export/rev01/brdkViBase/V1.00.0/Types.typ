
TYPE
	brdkViBase_2d_typ : 	STRUCT  (*2D vector information.*)
		y : LREAL; (*Y-coordinate.*)
		x : LREAL; (*X-coordinate.*)
	END_STRUCT;
	brdkViBase_3d_typ : 	STRUCT  (*3D vector information.*)
		y : LREAL; (*Y-coordinate.*)
		z : LREAL; (*Z-coordinate.*)
		x : LREAL; (*X-coordinate.*)
	END_STRUCT;
	brdkViBase_angle_enum : 
		( (*Angle enumeration type.*)
		BRDKVIBASE_ANGLE_X, (*X-angle*)
		BRDKVIBASE_ANGLE_Y, (*Y-angle*)
		BRDKVIBASE_ANGLE_Z (*Z-angle*)
		);
END_TYPE
