
FUNCTION brdkViBase_distance : LREAL (*Calculate the distance between two points.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		x1 : LREAL; (*Point 1 x*)
		y1 : LREAL; (*Point 1 y*)
		x2 : LREAL; (*Point 2 x*)
		y2 : LREAL; (*Point 2 y*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_random : INT (*Get a random number between min and max.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		min : INT; (*Min value*)
		max : INT; (*Max value*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_initRand : BOOL (*Initialize rand function.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		seed : UDINT; (*seed*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_deg2rad : LREAL (* Function to convert degrees to radians. Return angle in radians.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		deg : LREAL; (*Input degree.*)
	END_VAR
END_FUNCTION

FUNCTION brdkViBase_rad2deg : LREAL (*Function to convert radian to degree. Return angle in degrees.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		rad : LREAL; (*Input radian.*)
	END_VAR
END_FUNCTION
