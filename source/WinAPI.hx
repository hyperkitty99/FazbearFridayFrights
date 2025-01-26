package;

@:buildXml('
<target id="haxe">
<lib name="dwmapi.lib"/>
</target>')

@:cppFileCode('
#include <Windows.h>
#include <dwmapi.h>')

class WinAPI {
    @:functionCode('
        int darkMode = enable ? 1 : 0;
        HWND window = GetActiveWindow();
        if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));')
    public static function setDarkMode(enable:Bool) {}
}