extends TileMap

var tiledata
var random = RandomNumberGenerator.new()
var exposed = []
var matched = []
var failed_match
var h = 4
var w = 6
var atlas_info = [
	[[Vector2i(0,0),Vector2i(0,1)]],
	[[Vector2i(1,0),Vector2i(1,1)]],
	[[Vector2i(2,0),Vector2i(2,1)]],
	[[Vector2i(3,0),Vector2i(3,1)]],
	[[Vector2i(4,0),Vector2i(4,1)]],
	[[Vector2i(5,0),Vector2i(5,1)]],
	[[Vector2i(6,0),Vector2i(6,1)]],
	
	[[Vector2i(0,2),Vector2i(0,3)]],
	[[Vector2i(1,2),Vector2i(1,3)]],
	[[Vector2i(2,2),Vector2i(2,3)],[Vector2i(3,2),Vector2i(3,3)],[Vector2i(4,2),Vector2i(4,3)]],
	[[Vector2i(5,2),Vector2i(5,3)]],
	[[Vector2i(6,2),Vector2i(6,3)]],
]
	
	
func start():

	tiledata = []
	for y in range(h):
		tiledata.append([])
		for x in range(w):
			tiledata[-1].append({"Exists":false})
	var tracker = w*h
	var matchindex = 0
	while tracker!=0:
		var pair = atlas_info[matchindex].pick_random()
		var poses = []
		var breakout = 0
		for a in range(2):
			var pos = Vector2i(random.randi_range(0,w-1),random.randi_range(0,h-1))
			breakout = 0
			while pos in poses or tiledata[pos[1]][pos[0]]["Exists"]:
				pos = Vector2i(random.randi_range(0,w-1),random.randi_range(0,h-1))
				if breakout>1000:
					break
				breakout+=1
			poses.append(pos)
		if breakout>1000: break
		tiledata[poses[0][1]][poses[0][0]] = {"Pair":poses[1],"Tile":pair[0],"Pos":poses[0],"Exposed":false,"Exists":true,"Matched":false}
		tiledata[poses[1][1]][poses[1][0]] = {"Pair":poses[0],"Tile":pair[1],"Pos":poses[1],"Exposed":false,"Exists":true,"Matched":false}
		
		tracker-=2
		matchindex+=1
	
	refresh_tilemap()
	$"Block Clicking".start()

func _process(delta):
	
	var presspos = local_to_map(to_local(get_global_mouse_position()))
	if Input.is_action_just_pressed("Click"):
		var tile = tiledata[presspos[1]][presspos[0]]
		if not tile["Exposed"] and $"Fail to match".time_left==0 and $"Block Clicking".time_left == 0:
			tile["Exposed"] = true
			
			if len(exposed) == 1:
				if exposed[0] == tile["Pair"]:
					tiledata[tile["Pair"][1]][tile["Pair"][0]]["Matched"] = true
					tile["Matched"] = true
				else:
					$"Fail to match".start()
					failed_match = [tile,tiledata[exposed[0][1]][exposed[0][0]]]
			refresh_tilemap()

func refresh_tilemap():
	exposed = []
	matched = []
	for y in range(tiledata.size()):
		for x in range(tiledata[y].size()):
			set_cell(1,tiledata[y][x]["Pos"],0,Vector2i(-1,-1))
			if tiledata[y][x]["Exposed"]:
				if tiledata[y][x]["Matched"]:
					matched.append(Vector2i(x,y))
					set_cell(1,tiledata[y][x]["Pos"],0,Vector2i(7,2))
				else:
					exposed.append(Vector2i(x,y))
				set_cell(0,tiledata[y][x]["Pos"],0,tiledata[y][x]["Tile"])
			else:
				set_cell(0,tiledata[y][x]["Pos"],0,Vector2i(7,1))
	
	if len(matched) == w*h:
		$"..".end_game()
	


func _on_fail_to_match_timeout():
	for f in failed_match:
		f["Exposed"] = false
	refresh_tilemap()
