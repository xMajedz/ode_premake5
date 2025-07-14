include "ode_opts_premake5.lua"

workspace "ode"
	language "C++"
	location "ode"
	
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

--[[
  if _ACTION and _ACTION ~= "clean" then
    local infile = io.open("config-default.h", "r")
    local text = infile:read("*a")

    if _OPTIONS["no-trimesh"] then
      text = string.gsub(text, "#define dTRIMESH_ENABLED 1", "/* #define dTRIMESH_ENABLED 1 */")
      text = string.gsub(text, "#define dTRIMESH_OPCODE 1", "/* #define dTRIMESH_OPCODE 1 */")
    elseif (_OPTIONS["with-gimpact"]) then
      text = string.gsub(text, "#define dTRIMESH_OPCODE 1", "#define dTRIMESH_GIMPACT 1")
    end

    text = string.gsub(text, "/%* #define dOU_ENABLED 1 %*/", "#define dOU_ENABLED 1")
    if _OPTIONS["with-ou"] or not _OPTIONS["no-threading-intf"] then
      text = string.gsub(text, "/%* #define dATOMICS_ENABLED 1 %*/", "#define dATOMICS_ENABLED 1")
    end

    if _OPTIONS["with-ou"] then
      text = string.gsub(text, "/%* #define dTLS_ENABLED 1 %*/", "#define dTLS_ENABLED 1")
    end

    if _OPTIONS["no-threading-intf"] then
      text = string.gsub(text, "/%* #define dTHREADING_INTF_DISABLED 1 %*/", "#define dTHREADING_INTF_DISABLED 1")
    elseif not _OPTIONS["no-builtin-threading-impl"] then
      text = string.gsub(text, "/%* #define dBUILTIN_THREADING_IMPL_ENABLED 1 %*/", "#define dBUILTIN_THREADING_IMPL_ENABLED 1")
    end

    if _OPTIONS["16bit-indices"] then
      text = string.gsub(text, "#define dTRIMESH_16BIT_INDICES 0", "#define dTRIMESH_16BIT_INDICES 1")
    end
  
    if _OPTIONS["old-trimesh"] then
      text = string.gsub(text, "#define dTRIMESH_OPCODE_USE_OLD_TRIMESH_TRIMESH_COLLIDER 0", "#define dTRIMESH_OPCODE_USE_OLD_TRIMESH_TRIMESH_COLLIDER 1")
    end
    
    local outfile = io.open("../ode/src/config.h", "w")
    outfile:write(text)
    outfile:close()
  end
]]
--[[
    function generate(precstr)
      generateheader(_OPTIONS["ode-path"] .. "/include/ode/precision.h", "@ODE_PRECISION@", "d" .. precstr)
      generateheader(_OPTIONS["ode-path"] .. "/libccd/src/ccd/precision.h", "@CCD_PRECISION@", "CCD_" .. precstr)
    end
    
    if _OPTIONS["only-single"] then
      generate("SINGLE")
    elseif _OPTIONS["only-double"] then
      generate("DOUBLE")
    else 
      generate("UNDEFINEDPRECISION")
    end

    local ode_version = "0.16"
    generateheader(_OPTIONS["ode-path"] .. "/include/ode/version.h", "@ODE_VERSION@", ode_version)
]]
