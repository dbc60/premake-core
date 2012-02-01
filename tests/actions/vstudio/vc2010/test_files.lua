--
-- tests/actions/vstudio/vc2010/test_files.lua
-- Validate generation of files block in Visual Studio 2010 C/C++ projects.
-- Copyright (c) 2011-2012 Jason Perkins and the Premake project
--

	T.vstudio_vs2010_files = { }
	local suite = T.vstudio_vs2010_files
	local vc2010 = premake.vstudio.vc2010


--
-- Setup 
--

	local sln, prj
	
	function suite.setup()
		sln = test.createsolution()
	end
	
	local function prepare()
		prj = premake.solution.getproject_ng(sln, 1)
		vc2010.files_ng(prj)
	end


--
-- Test filtering of source files into the correct categories.
--

	function suite.clInclude_onHFile()
		files { "include/hello.h" }
		prepare()
		test.capture [[
	<ItemGroup>
		<ClInclude Include="include\hello.h" />
	</ItemGroup>
		]]
	end
		
	function suite.clCompile_onCFile()
		files { "hello.c" }
		prepare()
		test.capture [[
	<ItemGroup>
		<ClCompile Include="hello.c">
		</ClCompile>
	</ItemGroup>
		]]
	end
	
	function suite.resourceCompile_onRCFile()
		files { "resources/hello.rc" }
		prepare()
		test.capture [[
	<ItemGroup>
		<ResourceCompile Include="resources\hello.rc" />
	</ItemGroup>
		]]
	end

	function suite.none_onTxtFile()
		files { "docs/hello.txt" }
		prepare()
		test.capture [[
	<ItemGroup>
		<None Include="docs\hello.txt" />
	</ItemGroup>
		]]
	end
	
--
-- If a PCH source is specified, ensure it is included in the file configuration.
--

	function suite.precompiledHeader_onPchSource()
		files { "afxwin.cpp" }
		pchheader "afxwin.h"
		pchsource "afxwin.cpp"
		prepare()
		test.capture [[
	<ItemGroup>
		<ClCompile Include="afxwin.cpp">
			<PrecompiledHeader Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">Create</PrecompiledHeader>
			<PrecompiledHeader Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">Create</PrecompiledHeader>
		</ClCompile>
	</ItemGroup>
		]]
	end
