// Use RegExp Library
{$DEFINE REGEXPR}

{$DEFINE  VER130 }

{$DEFINE SCRIPTLET_CAST_FIX}
// Delphi 5 *************************************
{$IFDEF VER130}
        {$DEFINE SCRIPTLET_CAST_FIX}
{$ELSE}
       // Delphi 6 *************************************
       {$IF CompilerVersion >= 14}
            {$DEFINE VARIANTS}
            {$DEFINE D6UP}
       {$IFEND}

       // Delphi 7 *************************************
       {$IF CompilerVersion >= 15}
            {$DEFINE XPSTYLE}
       {$IFEND}

       {$IF CompilerVersion < 23} // Which Delphi versions exactly?
            {$DEFINE SCRIPTLET_CAST_FIX}
       {$IFEND}
{$ENDIF}
