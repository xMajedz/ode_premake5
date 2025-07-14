project "tests"
	kind     "ConsoleApp"
	location "ode/tests" 

	includedirs { 
		_OPTIONS["ode-path"] .. "/ou/include",
		_OPTIONS["ode-path"] .. "/tests/UnitTest++/src",
	}
	
	files { 
		_OPTIONS["ode-path"] .. "/tests/*.cpp", 
		_OPTIONS["ode-path"] .. "/tests/joints/*.cpp", 
		_OPTIONS["ode-path"] .. "/tests/UnitTest++/src/*", 
	}
	
	links { "ode" }
	
	filter "system:windows"
		files { _OPTIONS["ode-path"] .. "/tests/UnitTest++/src/Win32/*" }
	
	filter "not system:windows"
		files { _OPTIONS["ode-path"] .. "/tests/UnitTest++/src/Posix/*" }
