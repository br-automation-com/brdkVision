/* Automation Studio generated header file */
/* Do not edit ! */
/* brdkViMapp 1.00.0 */

#ifndef _BRDKVIMAPP_
#define _BRDKVIMAPP_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _brdkViMapp_VERSION
#define _brdkViMapp_VERSION 1.00.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
typedef struct brdkViMapp_VF_typ
{	plcstring widgetModels[150001];
	plcstring ROI[150001];
	plcstring params[1001];
} brdkViMapp_VF_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC plcbit brdkViMapp_getVfDataSet(plcstring* VaName, unsigned char VFidx, unsigned long pParam, unsigned long pROI, unsigned long pWidgetModels, unsigned long maxLen, unsigned long pError);
_BUR_PUBLIC plcbit brdkViMapp_setVfDataSet(plcstring* VaName, unsigned char VFidx, unsigned long pParam, unsigned long pROI, unsigned long pWidgetModels, unsigned long pError);


#ifdef __cplusplus
};
#endif
#endif /* _BRDKVIMAPP_ */

