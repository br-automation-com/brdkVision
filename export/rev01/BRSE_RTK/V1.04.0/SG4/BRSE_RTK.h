/* Automation Studio generated header file */
/* Do not edit ! */
/* BRSE_RTK 1.04.0 */

#ifndef _BRSE_RTK_
#define _BRSE_RTK_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _BRSE_RTK_VERSION
#define _BRSE_RTK_VERSION 1.04.0
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Constants */
#ifdef _REPLACE_CONST
 #define BRSE_RTK_MAX_ID 29U
 #define BRSE_RTK_MAX_STR_LEN 20U
 #define BRSE_RTK_STACK_SIZE 45056U
 #define BRSE_RTK_ERR_BASE 0U
 #define BRSE_RTK_ERR_ARGUMENT 1U
#else
 _GLOBAL_CONST unsigned char BRSE_RTK_MAX_ID;
 _GLOBAL_CONST unsigned char BRSE_RTK_MAX_STR_LEN;
 _GLOBAL_CONST unsigned short BRSE_RTK_STACK_SIZE;
 _GLOBAL_CONST unsigned short BRSE_RTK_ERR_BASE;
 _GLOBAL_CONST unsigned short BRSE_RTK_ERR_ARGUMENT;
#endif







/* Prototyping of functions and function blocks */
_BUR_PUBLIC unsigned short BRSE_RTK_EnterCriticalSection(unsigned char ID);
_BUR_PUBLIC unsigned short BRSE_RTK_LeaveCriticalSection(unsigned char ID);
_BUR_PUBLIC unsigned short BRSE_RTK_CreateTask(plcstring* pTaskNameStr, unsigned long pTaskFunction, unsigned long taskFunctionArgument, unsigned char taskPriority, unsigned long* pTaskIdent);
_BUR_PUBLIC unsigned short BRSE_RTK_DeleteTask(unsigned long taskIdent);
_BUR_PUBLIC unsigned short BRSE_RTK_SleepTaskUsec(unsigned long sleepTimeUsec);
_BUR_PUBLIC unsigned long BRSE_RTK_malloc(unsigned long size);
_BUR_PUBLIC unsigned short BRSE_RTK_free(unsigned long pMem);
_BUR_PUBLIC unsigned long BRSE_RTK_realloc(unsigned long pMem, unsigned long size);
_BUR_PUBLIC unsigned long BRSE_RTK_calloc(unsigned long nbrElem, unsigned long elemSize);


#ifdef __cplusplus
};
#endif
#endif /* _BRSE_RTK_ */

