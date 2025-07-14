newoption {
	trigger = "ode-path",
	description = "path to ode distribution.",
	default = ".",
}

newoption {
	trigger = "static",
	description = "build static lib.",
}

newoption {
	trigger = "shared",
	description = "build shared lib.",
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

if _ACTION and not _ACTION == "clean" then
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
