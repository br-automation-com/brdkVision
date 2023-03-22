PROGRAM _INIT
	(* Insert code here *)
	mpRecipe.Enable := TRUE;
	IF DiagCpuIsSimulated() THEN
		mpRecipe.DeviceName := ADR('SIM');
	ELSE
		mpRecipe.DeviceName := ADR('RECIPE');
	END_IF
	mpRecipe.FileName := ADR('recipe');
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
		brdkViMapp_getVfDataSet('BLOBCam',1,ADR(recipe.VF.params),ADR(recipe.VF.ROI),ADR(recipe.VF.widgetModels),ADR(recipe.VF.models),SIZEOF(recipe.VF.ROI),ADR(error));
		// Allow MpRecipe to save recipe to file
		mpRecipeRegPar.ConfirmSave := TRUE;
	END_IF
	
	// wait for Mapp Recipe update notification
	IF mpRecipeRegPar.UpdateNotification THEN
		// Set VF info into AR config system
		brdkViMapp_setVfDataSet('BLOBCam',1,ADR(recipe.VF.params),ADR(recipe.VF.ROI),ADR(recipe.VF.widgetModels),0, ADR(error));
		//Trigger a Load of the VA from AS config system down to the camera
		viLoadVA := 1;
	END_IF
	
	IF TEST THEN
		brdkViMapp_getCompilerOption('BLOBCam', ADR(this.compilerOptions), ADR(error));
		brdkViMapp_getTriggerMode('BLOBCam', ADR(this.triggerMode), ADR(error));
		brdkViMapp_getFlipImgHorizontal('BLOBCam', ADR(this.flipHorizontal), ADR(error));
		brdkViMapp_getFlipImgVertical('BLOBCam', ADR(this.flipVertical), ADR(error));
	
	
		IF recipe.compilerOptions <> this.compilerOptions THEN
			brdkViMapp_setCompilerOption('BLOBCam', recipe.compilerOptions, ADR(error));
			viLoadVA := 1;
		END_IF
	
		IF recipe.triggerMode <> this.triggerMode THEN
			brdkViMapp_setTriggerMode('BLOBCam', recipe.triggerMode, ADR(error));
			viLoadVA := 1;
		END_IF
	
		IF recipe.flipHorizontal <> this.flipHorizontal THEN
			brdkViMapp_setFlipImgHorizontal('BLOBCam', recipe.flipHorizontal, ADR(error));
			viLoadVA := 1;
		END_IF
	
		IF recipe.flipVertical <> this.flipVertical THEN
			brdkViMapp_setFlipImgVertical('BLOBCam', recipe.flipVertical, ADR(error));
			viLoadVA := 1;
		END_IF
		TEST := FALSE;
	END_IF
	
	

	
	IF viLoadVA = 1 THEN
		loadVA.MpLink := ADR(gBlobCamera);
		loadVA.Execute := TRUE;
		loadVA.Name := ADR('BLOBCam');
		viLoadVA := FALSE;
	END_IF
	loadVA();
	
	IF loadVA.Done THEN
		loadVA.Execute := FALSE;
	END_IF
	
	// FB calls
	mpRecipe();
	mpRecipeUI();
	mpRecipeRegPar();
		
		END_PROGRAM

PROGRAM _EXIT
		(* Insert code here *)
	mpRecipe(Enable := FALSE);
	mpRecipeUI(Enable := FALSE);
	mpRecipeRegPar(Enable := FALSE);
	
	
		END_PROGRAM

