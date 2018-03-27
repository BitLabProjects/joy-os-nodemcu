# File structure
Following the modularity principle, the core files are kept to a minimum.

**init.lua** : The startup file launched by NodeMCU. Contains the definition to custom lua loading and execution that compile scripts on the fly and don't crash if they do not exist. It loads *lua_utils.lua* and *joy_os.lua*, then start JoyOS

**joy_os.lua** : JoyOS entry point, where user startup code and wifi connection is handled. Configuration of both wifi and user modules will be moved to a dedicated file in the future, and wifi itself will become a module.

**lua_utils.lua** : Plumbing code for defining classes and generic utilities on top of the lua language