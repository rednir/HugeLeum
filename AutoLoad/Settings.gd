extends Node


var FORCE_TOUCH_CONTROLS = OS.get_name() == "Android" or OS.get_name() == "iOS"
var show_touch_controls = FORCE_TOUCH_CONTROLS
var touch_controls_scale = 1.0