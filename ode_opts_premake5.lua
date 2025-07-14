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

