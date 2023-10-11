extends Node

var loadingScene = preload("res://scenes/ui/loading.tscn")

const SCENE_LIST = {
	"home_hub": "res://scenes/levels/home_hub.tscn",
	"test": "res://scenes/levels/test.tscn"
}

func loadScene(currentScene, nextScene):
	var loadingSceneInstance = loadingScene.instantiate()
	get_tree().get_root().add_child(loadingSceneInstance)
	
	var loadPath: String
	if SCENE_LIST.has(nextScene):
		loadPath = SCENE_LIST[nextScene]
	else:
		loadPath = nextScene
		
	var resourceLoader
	if ResourceLoader.exists(loadPath):
		resourceLoader = ResourceLoader.load_threaded_request(loadPath)
	
	if resourceLoader == null:
		print("Utils: Provided load path does not exist!")
		return

	await loadingSceneInstance.sceneFadedIn
	currentScene.queue_free()
	
	while true:
		var loadProgress = []
		var loadStatus = ResourceLoader.load_threaded_get_status(loadPath, loadProgress)
		
		match loadStatus:
			0:
				print("Utils: Invalid resource provided")
				return
			1:
				loadingSceneInstance.progress = loadProgress[0]
			2:
				print("Utils: Load failed!")
				return
			3:
				loadingSceneInstance.progress = 100.0
				var nextSceneInstance = ResourceLoader.load_threaded_get(loadPath).instantiate()
				get_tree().get_root().call_deferred("add_child", nextSceneInstance)
				await loadingSceneInstance.sceneFadedOut
				loadingSceneInstance.queue_free()
				return
				
