workspace "AppCore"
	location "_projects"
	architecture "x64"

	configurations {
		"Debug",
		"Release",
		"Distribution"
	}

	startproject "Game1"

outputdir = "%{cfg.system}/%{cfg.buildcfg}"
build_dir = "bin/builds/" ..outputdir.. "/%{prj.name}"
intermediates_dir = "bin/intermediates/" ..outputdir.. "/%{prj.name}"
distributions_dir= "bin/distribution/"

IncludeDirectories = {}
IncludeDirectories["GLFW"] = "_projects/AppCore/vendor/GLFW/include"
IncludeDirectories["SPDLOG"] = "_projects/AppCore/vendor/SPDLOG/include"

include "_projects/AppCore/vendor/GLFW"
include "_projects/AppCore/vendor/SPDLOG"

-- ApplicationCoreDLL
project "AppCore"
	location "_projects/AppCore" -- Create project inside this folder
	kind "SharedLib" -- DLL
	language "C++"
	staticruntime "Off"

	targetdir(build_dir) -- builds dir
	objdir(intermediates_dir) -- obj dir

	pchheader "sbxpch.h"
	pchsource "sbxpch.cpp"

	files {
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.hpp",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/src/**.c",
	}

	includedirs {
		"AppCore/src",
		"%{IncludeDirectories.GLFW}",
		"%{IncludeDirectories.SPDLOG}"
	}

	links {
		"GLFW",
		"SPDLOG"
	}

	cppdialect "C++20" -- C++ Version
	systemversion "latest" -- OS Version

	defines {
		"SBX_BUILD_DLL"
	}	
		
	filter "configurations:Debug" 
		defines "SBX_DEBUG"
		runtime "Debug"
		symbols "On"	

	filter "configurations:Release" 
		defines "SBX_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Distribution" 
		defines "SBX_DISTRIBUTION"
		runtime "Release"
		optimize "On"

-- Game1
project "Game1"
	location "_projects/Games/Game1" -- Create project inside this folder
	kind "ConsoleApp" -- Executable
	language "C++"
	staticruntime "Off"

	targetdir(build_dir) -- builds dir
	objdir(intermediates_dir) -- obj dir

	files {
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.hpp",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/src/**.c",
	}

	cppdialect "C++20" -- C++ Version
	systemversion "latest" -- OS Version
	
	filter "configurations:Debug" 
		defines "SBX_DEBUG"
		runtime "Debug"
		symbols "On"	

	filter "configurations:Release" 
		defines "SBX_RELEASE"
		runtime "Release"
		optimize "On"

	filter "configurations:Distribution" 
		defines "SBX_DISTRIBUTION"
		runtime "Release"
		optimize "On"