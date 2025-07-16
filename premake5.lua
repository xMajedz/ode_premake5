newoption {
	trigger = "ode-path",
	description = "path to ode distribution.",
	default = ".",
}

newoption {
	trigger     = "with-demos",
	description = "Builds the demo applications and DrawStuff library"
}

newoption {
	trigger     = "with-tests",
	description = "Builds the unit test application"
}

newoption {
	trigger     = "with-gimpact",
	description = "Use GIMPACT for trimesh collisions (experimental)"
}

newoption {
	trigger     = "all-collis-libs",
	description = "Include sources of all collision libraries into the project"
}

newoption {
	trigger     = "with-libccd",
	description = "Uses libccd for handling some collision tests absent in ODE."
}

newoption {
	trigger     = "no-dif",
	description = "Exclude DIF (Dynamics Interchange Format) exports"
}

newoption {
	trigger     = "no-trimesh",
	description = "Exclude trimesh collision geometry"
}

newoption {
	trigger     = "with-ou",
	description = "Use TLS for global caches (allows threaded collision checks for separated spaces)"
}

newoption {
	trigger     = "no-builtin-threading-impl",
	description = "Disable built-in multithreaded threading implementation"
}

newoption {
	trigger     = "no-threading-intf",
	description = "Disable threading interface support (external implementations cannot be assigned)"
}

newoption {
	trigger     = "16bit-indices",
	description = "Use 16-bit indices for trimeshes (default is 32-bit)"
}

newoption {
	trigger     = "old-trimesh",
	description = "Use old OPCODE trimesh-trimesh collider"
}

newoption {
	trigger     = "only-shared",
	description = "Only build shared (DLL) version of the library"
}

newoption {
	trigger     = "only-static",
	description = "Only build static versions of the library"
}

newoption {
	trigger     = "only-single",
	description = "Only use single-precision math"
}

newoption {
	trigger     = "only-double",
	description = "Only use double-precision math"
}

newoption {
	trigger     = "no-sse2",
	description = "Disable SSE2 use for x86 targets in favor to FPU"
}

newaction {
	trigger = "clean",
	description = "clean build files.",
	onStart = function()
		os.rmdir(_OPTIONS["ode-path"] .. "/build/lib")
		os.rmdir(_OPTIONS["ode-path"] .. "/build/demos")
		os.rmdir(_OPTIONS["ode-path"] .. "/build/tests")
		os.remove(_OPTIONS["ode-path"] .. "/ode/src/config.h")
		os.remove(_OPTIONS["ode-path"] .. "/include/ode/version.h")
		os.remove(_OPTIONS["ode-path"] .. "/include/ode/precision.h")
		os.remove(_OPTIONS["ode-path"] .. "/libccd/src/ccd/precision.h")
	end,
}

local ode = { version = "0.16" }

function ode.configureheader(header)
	local infile = io.open(header, "r")
	local text = infile:read("*a")

	if _OPTIONS["no-trimesh"] then
		text = text:gsub("#define dTRIMESH_ENABLED 1", "/* #define dTRIMESH_ENABLED 1 */")
		text = text:gsub("#define dTRIMESH_OPCODE 1", "/* #define dTRIMESH_OPCODE 1 */")
	elseif (_OPTIONS["with-gimpact"]) then
		text = text:gsub("#define dTRIMESH_OPCODE 1", "#define dTRIMESH_GIMPACT 1")
	end

	text = text:gsub("/%* #define dOU_ENABLED 1 %*/", "#define dOU_ENABLED 1")

	if _OPTIONS["with-ou"] or not _OPTIONS["no-threading-intf"] then
		text = text:gsub("/%* #define dATOMICS_ENABLED 1 %*/", "#define dATOMICS_ENABLED 1")
	end

	if _OPTIONS["with-ou"] then
		text = text:gsub("/%* #define dTLS_ENABLED 1 %*/", "#define dTLS_ENABLED 1")
	end

	if _OPTIONS["no-threading-intf"] then
		text = text:gsub("/%* #define dTHREADING_INTF_DISABLED 1 %*/", "#define dTHREADING_INTF_DISABLED 1")
	elseif not _OPTIONS["no-builtin-threading-impl"] then
		text = text:gsub("/%* #define dBUILTIN_THREADING_IMPL_ENABLED 1 %*/", "#define dBUILTIN_THREADING_IMPL_ENABLED 1")
	end

	if _OPTIONS["16bit-indices"] then
		text = text:gsub("#define dTRIMESH_16BIT_INDICES 0", "#define dTRIMESH_16BIT_INDICES 1")
	end
	
	if _OPTIONS["old-trimesh"] then
		text = text:gsub("#define dTRIMESH_OPCODE_USE_OLD_TRIMESH_TRIMESH_COLLIDER 0", "#define dTRIMESH_OPCODE_USE_OLD_TRIMESH_TRIMESH_COLLIDER 1")
	end
	
	local outfile = io.open(_OPTIONS["ode-path"] .. "/ode/src/config.h", "w")
	outfile:write(text)
	outfile:close()
end

function ode.generateheader(headerfile, placeholder, precstr)
	local outfile = io.open(headerfile, "w")
	for i in io.lines(headerfile .. ".in") do
		local j ,_ = string.gsub(i, placeholder, precstr)
		outfile:write(j .. "\n")
	end
	outfile:close()
end

function ode.generate(precstr)
	ode.generateheader(_OPTIONS["ode-path"] .. "/include/ode/precision.h", "@ODE_PRECISION@", "d" .. precstr)
	ode.generateheader(_OPTIONS["ode-path"] .. "/libccd/src/ccd/precision.h", "@CCD_PRECISION@", "CCD_" .. precstr)
end

if _ACTION and _ACTION ~= "clean" then
	if _OPTIONS["only-single"] then
		ode.generate("SINGLE")
	elseif _OPTIONS["only-double"] then
		ode.generate("DOUBLE")
	else 
		ode.generate("UNDEFINEDPRECISION")
	end

	ode.configureheader(_OPTIONS["ode-path"] .. "/build/config-default.h");
	ode.generateheader(_OPTIONS["ode-path"] .. "/include/ode/version.h", "@ODE_VERSION@", ode["version"])
end

local demos = {
	"boxstack",
	"buggy",
	"cards",
	"chain1",
	"chain2",
	"collision",
	"convex",
	"crash",
	"cylvssphere",
	"dball",
	"dhinge",
	"feedback",
	"friction",
	"gyroscopic",
	"gyro2",
	"heightfield",
	"hinge",
	"I",
	"jointPR",
	"jointPU",
	"joints",
	"kinematic",
	"motion",
	"motor",
	"ode",
	"piston",
	"plane2d",
	"rfriction",
	"slider",
	"space",
	"space_stress",
	"step",
	"transmission",
}

local trimesh_demos = {
	"basket",
	"cyl",
	"moving_convex",
	"moving_trimesh",
	"tracks",
	"trimesh",
	"trimesh_collision",
}

if not _OPTIONS["no-trimesh"] then
	demos = table.join(demos, trimesh_demos)
end

workspace "ode"
	language "C++"
	location (_OPTIONS["ode-path"] .. "/build")
	
	includedirs {
		_OPTIONS["ode-path"] .. "/include",
		_OPTIONS["ode-path"] .. "/ode/src",
	}
	
	defines { "_MT" }

	configurations {"Debug", "Release"}

	platforms {
		"SingleStatic",
		"SingleShared",
		"DoubleStatic",
		"DoubleShared",
	}
	
	filter {"configurations:Debug"}
		defines { "_DEBUG" }
		symbols "On"
	
	filter {"configurations:Release"}
		defines { "NDEBUG", "dNODEBUG" }
		optimize "On"
		omitframepointer "On"
	
	filter {"not options:no-sse2"}
		vectorextensions "SSE"
	
	filter { "platforms:Single*" }
		defines { "dIDESINGLE", "CCD_IDESINGLE" }
	
	filter { "platforms:Double*" }
		defines { "dIDEDOUBLE", "CCD_IDEDOUBLE" }
	
	filter { "system:windows" }
		defines { "WIN32" }
	
	filter { "system:macos" }
		linkoptions { "-framework Carbon" }
	
	filter { "action:vs*" }
		defines { "_CRT_SECURE_NO_DEPRECATE", "_SCL_SECURE_NO_WARNINGS" }
	
	filter { "action:vs*" }
		defines { "_USE_MATH_DEFINES" }
	
	filter { "action:vs2002 or action:vs2003" }
		staticruntime "On"

for _, name in ipairs(demos) do
project ( "demo_" .. name )
if name ~= "ode" then
	kind "WindowedApp"
else
	kind "ConsoleApp"
end
	location (_OPTIONS["ode-path"] .. "/build/demos")
	files { _OPTIONS["ode-path"] .. "/ode/demo/demo_" .. name .. ".*" }
	links { "ode", "drawstuff" }        

	filter "system:Windows"
	files { _OPTIONS["ode-path"] .. "/drawstuff/src/resources.rc" }
	links   { "user32", "winmm", "gdi32", "opengl32", "glu32" }

	filter "system:MacOSX"
	linkoptions { "-framework Carbon", "-framework OpenGL", "-framework AGL" }

	filter { "not system:Windows", "not system:MacOSX" }
	links   { "X11", "GL", "GLU" }

	filter "not options:with-demos"
	kind "None"
end

project "drawstuff"
	location (_OPTIONS["ode-path"] .. "/build/demos")

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
	linkoptions { "-framework Carbon",  "-framework OpenGL",  "-framework AGL" }
	
	filter {"not system:windows", "not system:macos"}
	files   { _OPTIONS["ode-path"] .. "/drawstuff/src/x11.cpp" }
	links   { "X11", "GL", "GLU" }

	filter "platforms:*Static"
	kind    "StaticLib"
	defines { "DS_LIB" }
	
	filter "platforms:*Shared"
	kind    "SharedLib"
	defines { "DS_DLL", "USRDLL" }

	filter "not options:with-demos"
	kind "None"

project "tests"
	kind     "ConsoleApp"
	location (_OPTIONS["ode-path"] .. "/build/tests")

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

	filter "not options:with-tests"
	kind "None"

project "ode"
	location (_OPTIONS["ode-path"] .. "/build/lib")
	includedirs {
		_OPTIONS["ode-path"] .. "/ode/src/joints",
		_OPTIONS["ode-path"] .. "/OPCODE",
		_OPTIONS["ode-path"] .. "/GIMPACT/include",
		_OPTIONS["ode-path"] .. "/libccd/src/custom",
		_OPTIONS["ode-path"] .. "/libccd/src",

		_OPTIONS["ode-path"] .. "/ou/include",
	}

	files {
		_OPTIONS["ode-path"] .. "/include/ode/*.h",
		_OPTIONS["ode-path"] .. "/ode/src/joints/*.h", 
		_OPTIONS["ode-path"] .. "/ode/src/joints/*.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/*.h", 
		_OPTIONS["ode-path"] .. "/ode/src/*.c", 
		_OPTIONS["ode-path"] .. "/ode/src/*.cpp",

		_OPTIONS["ode-path"] .. "/ou/include/**.h",
		_OPTIONS["ode-path"] .. "/ou/src/**.h",
		_OPTIONS["ode-path"] .. "/ou/src/**.cpp",
	}

	excludes { _OPTIONS["ode-path"] .. "/ode/src/collision_std.cpp" }

	defines { "_OU_NAMESPACE=odeou" }

	filter "options:with-ou"
	defines { "_OU_FEATURE_SET=_OU_FEATURE_SET_TLS" }

	filter {"not options:with-ou", "options:no-threading-intf"}
	defines { "_OU_FEATURE_SET=_OU_FEATURE_SET_BASICS" }

	filter {"not options:with-ou", "not options:no-threading-intf"}
	defines { "_OU_FEATURE_SET=_OU_FEATURE_SET_ATOMICS" }


	filter {"action:gmake", "system:windows", "options:with-ou or not options:no-threading-intf"}
	buildoptions { "-mthreads" }
	linkoptions { "-mthreads" }
	defines { "HAVE_PTHREAD_ATTR_SETINHERITSCHED=1", "HAVE_PTHREAD_ATTR_SETSTACKLAZY=1" }

	filter {"action:gmake", "not system:windows"}
		buildoptions { "-pthread" }
		linkoptions { "-pthread" }

	filter "options:no-dif"
	excludes { _OPTIONS["ode-path"] .. "/ode/src/export-dif.cpp" }

	filter "options:no-trimesh"
	excludes {
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_colliders.h",
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_contact_export_helper.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_contact_export_helper.h",
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_gim_contact_accessor.h",
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_plane_contact_accessor.h",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_internal.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_opcode.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_gimpact.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_box.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_ccylinder.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_cylinder_trimesh.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_ray.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_sphere.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_trimesh.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_trimesh_old.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_plane.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_convex_trimesh.cpp",
	}

	filter { "not options:no-trimesh", "options:with-gimpact or options:all-collis-libs" }
	files { _OPTIONS["ode-path"] .. "/GIMPACT/**.h", _OPTIONS["ode-path"] .. "/GIMPACT/**.cpp" }
	
	filter { "not options:no-trimesh", "not options:with-gimpact" }
	files   { _OPTIONS["ode-path"] .. "/OPCODE/**.h", _OPTIONS["ode-path"] .. "/OPCODE/**.cpp" }

	filter { "not options:no-trimesh", "not options:all-collis-libs", "options:with-gimpact" }
	excludes { _OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_opcode.cpp" }
	
	filter { "not options:no-trimesh", "not options:all-collis-libs", "not options:with-gimpact" }
	excludes {
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_contact_export_helper.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_contact_export_helper.h",
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_gim_contact_accessor.h",
		_OPTIONS["ode-path"] .. "/ode/src/gimpact_plane_contact_accessor.h",
		_OPTIONS["ode-path"] .. "/ode/src/collision_trimesh_gimpact.cpp",
	}
	
	filter "options:with-libccd"
	files   {
		_OPTIONS["ode-path"] .. "/libccd/src/custom/ccdcustom/*.h",
		_OPTIONS["ode-path"] .. "/libccd/src/ccd/*.h",
		_OPTIONS["ode-path"] .. "/libccd/src/*.c"
	}
	defines {
		"dLIBCCD_ENABLED",
		"dLIBCCD_INTERNAL", 
		"dLIBCCD_BOX_CYL",
		"dLIBCCD_CYL_CYL",
		"dLIBCCD_CAP_CYL",
		"dLIBCCD_CONVEX_BOX",
		"dLIBCCD_CONVEX_CAP",
		"dLIBCCD_CONVEX_CYL",
		"dLIBCCD_CONVEX_SPHERE",
		"dLIBCCD_CONVEX_CONVEX",
	}

	filter "not options:with-libccd"
	excludes {
		_OPTIONS["ode-path"] .. "/ode/src/collision_libccd.cpp",
		_OPTIONS["ode-path"] .. "/ode/src/collision_libccd.h",
	}
	
	filter "system:windows"
	links { "user32" }

	filter "platforms:*Static"
	kind "StaticLib"
	defines "ODE_LIB"

	filter "platforms:*Shared"
	kind "SharedLib"
	defines { "ODE_DLL", "_DLL" }
