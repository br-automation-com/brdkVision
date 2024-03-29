/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViVF 1.00.2 */

#ifndef _BRDKVIVF_
#define _BRDKVIVF_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViVF_VERSION
#define _brdkViVF_VERSION 1.00.2
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
#ifdef _SG3
		#include "brdkViBase.h"
		#include "brdkViCal.h"
		#include "brdkViGeom.h"
		#include "brdkViImg.h"
#endif
#ifdef _SG4
		#include "brdkViBase.h"
		#include "brdkViCal.h"
		#include "brdkViGeom.h"
		#include "brdkViImg.h"
#endif
#ifdef _SGC
		#include "brdkViBase.h"
		#include "brdkViCal.h"
		#include "brdkViGeom.h"
		#include "brdkViImg.h"
#endif


/* Datatypes and datatypes of function blocks */
typedef struct brdkViVF_blobInfo_typ
{	unsigned long histColor[256];
	unsigned long colorSum;
	unsigned char meanColor;
	unsigned char maxColor;
	unsigned char minColor;
	unsigned long area;
} brdkViVF_blobInfo_typ;

typedef struct brdkViVF_bloblist_typ
{	unsigned long pBlobs;
	unsigned long cnt;
} brdkViVF_bloblist_typ;

typedef struct brdkViVF_blob_typ
{	unsigned long pPx;
	unsigned long cnt;
} brdkViVF_blob_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC plcbit brdkViVF_shapeBlob(signed short imgWidth, signed short imgHeight, unsigned char* pImg1, unsigned char* pImg2, struct brdkViBase_2d_typ* center, struct brdkViGeom_shape_typ* outerShape, struct brdkViGeom_shape_typ* innerShape, double orientation, signed short minDiff, signed short stepSize, struct brdkViVF_blobInfo_typ* blob);
_BUR_PUBLIC plcbit brdkViVF_threshold(struct brdkViImg_imageArray_typ* input, unsigned char min, unsigned char max, unsigned char fill, struct brdkViImg_imageArray_typ* output);
_BUR_PUBLIC plcbit brdkViVF_dilate(struct brdkViImg_imageArray_typ* input, unsigned char iterations, struct brdkViImg_imageArray_typ* output);
_BUR_PUBLIC plcbit brdkViVF_absDiff(struct brdkViImg_imageArray_typ* inputA, struct brdkViImg_imageArray_typ* inputB, float Gain, struct brdkViImg_imageArray_typ* output);
_BUR_PUBLIC plcbit brdkViVF_opening(struct brdkViImg_imageArray_typ* input, unsigned char iterations, struct brdkViImg_imageArray_typ* output);
_BUR_PUBLIC plcbit brdkViVF_closing(struct brdkViImg_imageArray_typ* input, unsigned char iterations, struct brdkViImg_imageArray_typ* output);
_BUR_PUBLIC plcbit brdkViVF_erode(struct brdkViImg_imageArray_typ* input, unsigned char iterations, struct brdkViImg_imageArray_typ* output);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVIVF_ */

