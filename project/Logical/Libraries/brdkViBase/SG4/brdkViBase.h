/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViBase 1.00.0 */

#ifndef _BRDKVIBASE_
#define _BRDKVIBASE_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViBase_VERSION
#define _brdkViBase_VERSION 1.00.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "astime.h"
#endif
#ifdef _SG4
		#include "astime.h"
#endif
#ifdef _SGC
		#include "astime.h"
#endif


/* Datatypes and datatypes of function blocks */
typedef enum brdkViBase_angle_enum
{	BRDKVIBASE_ANGLE_X,
	BRDKVIBASE_ANGLE_Y,
	BRDKVIBASE_ANGLE_Z
} brdkViBase_angle_enum;

typedef struct brdkViBase_2d_typ
{	double y;
	double x;
} brdkViBase_2d_typ;

typedef struct brdkViBase_3d_typ
{	double y;
	double z;
	double x;
} brdkViBase_3d_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC double brdkViBase_distance(double x1, double y1, double x2, double y2);
_BUR_PUBLIC signed short brdkViBase_random(signed short min, signed short max);
_BUR_PUBLIC plcbit brdkViBase_initRand(unsigned long seed);
_BUR_PUBLIC double brdkViBase_deg2rad(double deg);
_BUR_PUBLIC double brdkViBase_rad2deg(double rad);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVIBASE_ */

