// Use RegExp Library
{$DEFINE REGEXPR}

// Delphi 7 *************************************
{$IFDEF VER150}
        {$DEFINE SCRIPTLET_CAST_FIX}
        {$DEFINE XPSTYLE}
        {$DEFINE VER_D7H}
        {$DEFINE TDATETIME_FIX}
{$ELSE}
       // Delphi 6 *************************************
       {$IF CompilerVersion >= 14}
            {$DEFINE VARIANTS}
            {$DEFINE VER_D6H}
       {$IFEND}

       // Delphi 7 *************************************
       {$IF CompilerVersion >= 15}
            {$DEFINE XPSTYLE}
            {$DEFINE VER_D7H}
       {$IFEND}

       // Delphi XE *************************************
       {$IF CompilerVersion >= 22}
            {$DEFINE VER_XEH}
       {$IFEND}

       {$IF CompilerVersion < 22}
            {$DEFINE SCRIPTLET_CAST_FIX} // Which Delphi versions exactly?
            {$DEFINE TDATETIME_FIX}      // Which Delphi versions exactly?
       {$IFEND}
{$ENDIF}
