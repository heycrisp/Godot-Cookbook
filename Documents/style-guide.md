```python
func _do_thing() -> void: # private function, prepended with _
	if something:
		_do_blah() # Add a blank line at the end of an indented block

	if something_else:
		_do_bleh()		
	elif this_other_thing:
		_do_blaoab()
	else:
		_do_babaloo() # Train Principle: if->engine, elif->train cars, else->caboose. 

	var some_val = _foo()
	var some_other_val = _bar()
	
	if do_not_do_this: # Insert a blank line before an engine
		_leave_room_for_jesus()

func poke() -> void: # public function
	_do_thing()
```