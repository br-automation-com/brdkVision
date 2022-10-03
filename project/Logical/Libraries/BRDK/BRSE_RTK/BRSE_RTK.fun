(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: BRSE_RTK
 * File: BRSE_RTK.fun
 * Author: XPMUser
 * Created: September 13, 2013
 ********************************************************************
 * Functions and function blocks of library BRSE_RTK
 ********************************************************************)

FUNCTION BRSE_RTK_EnterCriticalSection : UINT
	VAR_INPUT
		ID : USINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_LeaveCriticalSection : UINT
	VAR_INPUT
		ID : USINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_CreateTask : UINT
	VAR_INPUT
		pTaskNameStr : STRING[BRSE_RTK_MAX_STR_LEN];
		pTaskFunction : UDINT;
		taskFunctionArgument : UDINT;
		taskPriority : USINT;
	END_VAR
	VAR_IN_OUT
		pTaskIdent : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_DeleteTask : UINT
	VAR_INPUT
		taskIdent : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_SleepTaskUsec : UINT
	VAR_INPUT
		sleepTimeUsec : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_malloc : UDINT
	VAR_INPUT
		size : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_free : UINT
	VAR_INPUT
		pMem : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_realloc : UDINT
	VAR_INPUT
		pMem : UDINT;
		size : UDINT;
	END_VAR
END_FUNCTION

FUNCTION BRSE_RTK_calloc : UDINT
	VAR_INPUT
		nbrElem : UDINT;
		elemSize : UDINT;
	END_VAR
END_FUNCTION
