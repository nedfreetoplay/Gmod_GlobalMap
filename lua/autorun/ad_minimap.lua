--   Copyright 2017 JustNeed
--
--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at
--
--       http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.

AddCSLuaFile()

require( "minimap" )

hook.Add( "KeyPress", "keypress_minimap", function( ply, key )
	if SERVER then return end

	if key == IN_RELOAD then
		OpenMap( 20, LoadSettings() )
	end
end )

concommand.Add( "openmap", function( ply, cmd, args )
	if SERVER then return end

	OpenMap( 20, LoadSettings() )
end )

--[[local pos = GetPlayersPos()
for k,v in pairs(pos) do
	ply..k = DrawPlayer( map, v, 10, 15216 )
	function ply..k:DoClick()

	end
end]]
--OpenMap( 20, LoadSettings() )

--SaveSettings( LoadSettings() )