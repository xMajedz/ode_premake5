include "ode_opts_premake5.lua"

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

if _OPTIONS["with-demos"] then
	include "ode_demos_premake5.lua"
	include "drawstuff_premake5.lua"
end

if _OPTIONS["with-tests"] then
	include "ode_tests_premake5.lua"
end

include "libode_premake5.lua"
