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

for _, name in ipairs(demos) do
	project ( "demo_" .. name )
	if name ~= "ode" then
		kind      "WindowedApp"
	else
		kind      "ConsoleApp"
	end
		location "ode/demos"
		files { _OPTIONS["ode-path"] .. "/ode/demo/demo_" .. name .. ".*" }
		links { "ode", "drawstuff" }        
	
		filter "system:windows"
			files { _OPTIONS["ode-path"] .. "/drawstuff/src/resources.rc" }
			links   { "user32", "winmm", "gdi32", "opengl32", "glu32" }
	
		filter "system:macos"
			linkoptions { "-framework Carbon -framework OpenGL -framework AGL" }
	
		filter { "not system:windows", "not system:macos" }
			links   { "X11", "GL", "GLU" }
end
