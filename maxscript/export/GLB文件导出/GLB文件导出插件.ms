try(DestroyDialog glb_Export) catch()

rollout glb_Export "GLB文件导出" width:300
(
	editText edt1 "路径" 
	radiobuttons rdo1 "动画是否导出"  labels:#( "none","anim") across:2
	button btn1 "Button"	
	on btn1 pressed do 
	(
		filePath = edt1.text +"\\*.max"
		files = getFiles filePath recurse:true	
		for f in files do
		(
			loadMaxFile f quiet:true
			max unhide all
			objArray = for obj in geometry where obj.modifiers[#skin] !=undefined collect obj 
			boneArray = $root/.../* 
			
			if rdo1.state == 1 then 
			(
				for i = 1 to objArray.count do 
				(
					Object_Name = objArray[i].name
					Output_Path = edt1.text + "\\glb\\" + Object_Name + ".glb"
					Assembly = dotNetClass "System.Reflection.Assembly"
					--UPDATE YOUR PATH TO BABYLON DLL
						
					Assembly.loadfrom "D:\Program Files\Autodesk\3ds Max 2019\bin\assemblies\Max2Babylon.dll"
					maxScriptManager = dotNetObject "Max2Babylon.MaxScriptManager"

					-- OUTPUT PATH
					param = maxScriptManager.InitParameters Output_Path
					select boneArray
					selectMore objArray[i]
					param.exportOnlySelected = true
					param.exportMaterials = true
					param.autoSaveSceneFile = false
					param.outputFormat = "glb"
					param.txtQuality = 100
					param.exportAnimations = false
					maxScriptManager.Export param --true – <-- Uncomment to enable logging
				)
			)
			else
			(
				for i = 1 to objArray.count do 
				(
					Object_Name = getFilenameFile f
					Output_Path = edt1.text + "\\glb\\" + Object_Name + ".glb"
					Assembly = dotNetClass "System.Reflection.Assembly"
					--UPDATE YOUR PATH TO BABYLON DLL
						
					Assembly.loadfrom "D:\Program Files\Autodesk\3ds Max 2019\bin\assemblies\Max2Babylon.dll"
					maxScriptManager = dotNetObject "Max2Babylon.MaxScriptManager"

					-- OUTPUT PATH
					param = maxScriptManager.InitParameters Output_Path
					param.exportOnlySelected = false
					param.exportMaterials = true
					param.autoSaveSceneFile = false
					param.outputFormat = "glb"
					param.txtQuality = 100
					param.exportAnimations = false
					maxScriptManager.Export param --true – <-- Uncomment to enable logging
				)
			
			)
			
		)
	)
	
)
CreateDialog glb_Export