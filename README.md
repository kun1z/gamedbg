# gamedbg

Direct3D9 DLL Injection

This is a personal _unreleased_ tool I have used for hacking games and dumping/ripping game content such as textures, 3D models, shaders, and animations. Although it is specific to D3D9 Interfaces, the patterns can be updated to support newer Interfaces of DirectX.

This tool can launch games with the hooks pre-installed **or** attach to already-running games and infect the vector tables as they are called in real time. The former is useful for simple games, and the latter is useful for games with anti-cheat detection as the anti-cheat can be disabled first, and then this tool injected afterwards. Easy!

There are no instructions on how to use this tool, but it's pretty straight forward if you're familiar with hooking.