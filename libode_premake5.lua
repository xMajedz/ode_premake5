print(_OPTIONS["ode-path"])
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
