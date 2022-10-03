
PROGRAM _INIT
	(* Insert code here *)
	mpRecipe.Enable := TRUE;
	mpRecipe.DeviceName := ADR('RECIPE');
	mpRecipe.FileName := ADR('reicpe.csv');
	mpRecipe.MpLink := ADR(gRecipeCsv);
	mpRecipe();
	
	mpRecipeUI.Enable := TRUE;
	mpRecipeUI.MpLink := ADR(gRecipeCsv);
	mpRecipeUI.UIConnect := ADR(mpRecipeUIStruct);
	mpRecipeUI();
	
	mpRecipeRegPar.Enable := TRUE;
	mpRecipeRegPar.MpLink := ADR(gRecipeCsv);
	mpRecipeRegPar.PVName := ADR('::Recipe:recipe');
	mpRecipeRegPar();
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)

	// Perhaps not the best way to detect if a new recipe is loaded but it works as long as its not the same recipe :)
	mpRecipe.UpdateNotification := mpRecipe.Info.LastLoadedRecipe <> oldLoadedRecipe;
	oldLoadedRecipe := mpRecipe.Info.LastLoadedRecipe;
		
	// wait for Mapp Recipe save notification
	IF mpRecipeRegPar.SaveNotification THEN
		// Get VF information from AR config system
		brdkViMapp_getVfDataSet('BLOBCam',1,ADR(recipe.VF.params),ADR(recipe.VF.ROI),ADR(recipe.VF.widgetModels),SIZEOF(recipe.VF.ROI),0,ADR(error));
		// Allow MpRecipe to save recipe to file
		mpRecipeRegPar.ConfirmSave := TRUE;
	END_IF
	
	// wait for Mapp Recipe update notification
	IF mpRecipeRegPar.UpdateNotification THEN
		// Set VF info into AR config system
		brdkViMapp_setVfDataSet('BLOBCam',1,ADR(recipe.VF.params),ADR(recipe.VF.ROI),ADR(recipe.VF.widgetModels),0,ADR(error));
		//Trigger a Load of the VA from AS config system down to the camera		
		viBaseLoadVa.Execute := TRUE;
		viBaseLoadVa.MpLink := ADR(gBlobCamera);
		viBaseLoadVa.Name := ADR('BLOBCam');
	END_IF
	
	// Check if load of VA to camera is done
	IF viBaseLoadVa.Done OR viBaseLoadVa.Error THEN
		viBaseLoadVa.Execute := FALSE;
	END_IF
	
	// FB calls
	mpRecipe();
	mpRecipeUI();
	mpRecipeRegPar();
	viBaseLoadVa();	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	mpRecipe(Enable := FALSE);
	mpRecipeUI(Enable := FALSE);
	mpRecipeRegPar(Enable := FALSE);
	
	
END_PROGRAM

