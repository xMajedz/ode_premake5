project "drawstuff"
	location "ode/demos" 

	files {
		_OPTIONS["ode-path"] .. "/include/drawstuff/*.h",
		_OPTIONS["ode-path"] .. "/drawstuff/src/internal.h",
		_OPTIONS["ode-path"] .. "/drawstuff/src/drawstuff.cpp"
	}
		
	filter "system:windows"
		files   {
			_OPTIONS["ode-path"] .. "/drawstuff/src/resource.h",
			_OPTIONS["ode-path"] .. "/drawstuff/src/resources.rc",
			_OPTIONS["ode-path"] .. "/drawstuff/src/windows.cpp",
		}
		links   { "user32", "opengl32", "glu32", "winmm", "gdi32" }
	
	filter "system:macos"
		files       { _OPTIONS["ode-path"] .. "/drawstuff/src/osx.cpp" }
		defines     { "HAVE_APPLE_OPENGL_FRAMEWORK" }
		linkoptions { "-framework Carbon -framework OpenGL -framework AGL" }
	
	filter {"not system:windows", "not system:macos"}
		files   { _OPTIONS["ode-path"] .. "/drawstuff/src/x11.cpp" }
		links   { "X11", "GL", "GLU" }

	filter "platforms:*Static"
		kind    "StaticLib"
		defines { "DS_LIB" }
	
	filter "platforms:*Shared"
		kind    "SharedLib"
		defines { "DS_DLL", "USRDLL" }
