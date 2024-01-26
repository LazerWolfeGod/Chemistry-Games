extends Label

var time = 0.0

func process(delta):
	time+=delta
	text = time_to_str(time)

func start():
	show()
	time = 0.0
	text = time_to_str(time)
	
func time_to_str(sec,dp=1):
	var ms = fmod(sec,1)
	var se = str(int(fmod(sec,60)))
	var min = int(sec)/60
	var st
	if len(se) == 1: se = "0"+se
	if dp == 0: st = se
	else: st = se+"."+str(round(ms*(10**dp))/(10**dp)).right(-2)
	if st[-1] == ".": st+="0"
	if min != 0:
		st = str(min)+":"+st
	return st
	
