unit getvers;

interface

uses SysUtils;

Type
   TVersionQuad = Array[1..4] of Word;
   TVersionCompare = (vcEqual,
                      vcBuildDiffers,
                      vcMinorDiffers,
                      vcMajorDiffers,
                      vcReleaseDiffers);

Function ExpandVersion(Const S : String) : String;
Function ExtractVersionQuad(S : String; Var Quad : TVersionQuad) : Boolean;
Function VersionQuadToString(Const Quad : TVersionQuad) : String;
Function CompareVersionQuads(Quad1,Quad2 : TVersionQuad) : TVersionCompare;
// Returns true if Q1 is newer as Q2
Function NewerVersion(Q1,Q2 : TVersionQuad) : Boolean;
Function NewerVersion(V1,V2 : String) : Boolean;
Function CompareVersionString(Quad1,Quad2 : TVersionQuad;Const S1,S2 :
String) : String;
Function GetProgramVersion (Var Version : String): Boolean;  overload;
Function GetProgramVersion (Var Version : TVersionQuad) : Boolean; overload;

implementation

uses {$ifdef windows}
        fileinfo;
     {$else}
        resource, elfreader, versiontypes,versionresource;
     {$endif}

{$ifndef windows}

Function GetProgramVersion (Var Version : String): Boolean;

Var
   C : TVersionQuad;

begin
   Result:=GetProgramVersion(C);
   if Result then
     Version:=VersionQuadToString(C);
end;

Function GetProgramVersion (Var Version : TVersionQuad) : Boolean;

Var
   RS : TResources;
   E : TElfResourceReader;
   VR : TVersionResource;
   I : Integer;

begin
   RS:=TResources.Create;
   try
     E:=TElfResourceReader.Create;
     try
       Rs.LoadFromFile(ParamStr(0),E);
     finally
       E.Free;
     end;
     VR:=Nil;
     I:=0;
     While (VR=Nil) and (I<RS.Count) do
       begin
       if RS.Items[i] is TVersionResource then
          VR:=TVersionResource(RS.Items[i]);
       Inc(I);
       end;
     Result:=(VR<>Nil);
     if Result then
       For I:=1 to 4 do
         Version[i]:=VR.FixedInfo.FileVersion[I-1];
   Finally
     RS.FRee;
   end;
end;
{$else linux}

Function GetProgramVersion (Var Version : String) : Boolean;

Var
   V : TFileVersionInfo;

begin
   V:=TFileVersionInfo.Create(Nil);
   With V do
     try
       FileName:=ParamStr(0);
       Version:=V.getVersionSetting('ProductVersion');
       if (Version='') then
         Version:=V.GetVersionSetting('FileVersion');
       Result:=(Version<>'');
     Finally
       Free;
     end;
end;

Function GetProgramVersion (Var Version : TVersionQuad) : Boolean;

Var
   S : String;

begin
   Result:=GetProgramVersion(S);
   If Result then
     Result:=ExtractVersionQuad(S,Version);
end;
{$endif}

Function CompareVersionQuads(Quad1,Quad2 : TVersionQuad) : TVersionCompare;

Const
   EqualResults : Array[1..4] of TVersionCompare =
     (vcReleaseDiffers,vcMajorDiffers,vcMinorDiffers,vcBuildDiffers);

Var
   I : Integer;
begin
   Result:=vcEqual;
   I:=1;
   While (Result=vcEqual) and (I<5) do
     If Quad1[i]<>Quad2[i] then
       Result:=EqualResults[i]
     else
       inc(I);
end;

function ExpandVersion(const S: String): String;

Var
   I,Dots : Integer;

begin
   Dots:=0;
   For i:=1 to length(S) do
     if S[i]='.' then
       Inc(Dots);
   Result:=S;
   while (Dots<3) do
    begin
    Result:=result+'.0';
    Inc(Dots);
    end;
end;

Function ExtractVersionQuad(S : String; Var Quad : TVersionQuad) : Boolean;

Var
   I,P,Dots,Q : Integer;

begin
   Result:=True;
   FillChar(Quad,SizeOf(Quad),0);
   Dots:=0;
   I:=0;
   While Result and (S<>'') and (I<4) do
     begin
     inc(i);
     P:=Pos('.',S);
     If (P=0) then
       P:=Length(S)+1
     else
       inc(Dots);
     Q:=StrToIntDef(Copy(S,1,P-1),-1);
     Delete(S,1,P);
     Result:=Q<>-1;
     If Result then
       Quad[I]:=Q;
     end;
   Result:=(Dots=3);
end;

Resourcestring
   SVersionsequal = 'Versies van %s en %s zijn gelijk.';
   SDiffers = '%s versie nummer van %s (%s) en %s (%s) is verschillend.';
   SBuild   = 'Build';
   SMinor   = 'Minor';
   SMajor   = 'Major';
   SRelease = 'Release';

function NewerVersion(V1, V2: String): Boolean;

Var
   Q1,Q2 : TVersionQuad;

begin
   if ExtractVersionQuad(V1,Q1) and ExtractVersionQuad(V2,Q2) then
     Result:=NewerVersion(Q1,Q2)
   else
     Result:=False;
end;

Function CompareVersionString(Quad1,Quad2 : TVersionQuad;Const S1,S2 :
String) : String;

Var
   Fmt,V1,V2 : String;

begin
   V1:='';
   V2:='';
   Case CompareversionQuads(Quad1,Quad2) of
     vcBuildDiffers : begin

V1:=Format('%d.%d.%d.%d',[Quad1[1],Quad1[2],Quad1[3],Quad1[4]]);

V2:=Format('%d.%d.%d.%d',[Quad2[1],Quad2[2],Quad2[3],Quad2[4]]);
                      Fmt:=SBuild;
                      end;
     vcMinorDiffers : begin
                      V1:=Format('%d.%d.%d',[Quad1[1],Quad1[2],Quad1[3]]);
                      V2:=Format('%d.%d.%d',[Quad2[1],Quad2[2],Quad2[3]]);
                      Fmt:=SMinor;
                      end;
     vcMajorDiffers : begin
                      V1:=Format('%d.%d',[Quad1[1],Quad1[2]]);
                      V2:=Format('%d.%d',[Quad2[1],Quad2[2]]);
                      Fmt:=SMajor;
                      end;
     vcReleaseDiffers : begin
                      V1:=Format('%d',[Quad1[1]]);
                      V2:=Format('%d',[Quad2[1]]);
                      Fmt:=SRelease;
                      end;
   end;
   If (V1='') and (V2='') then
     Result := Format(SVersionsequal,[S1,S2])
   else
     Result := Format(SDiffers,[Fmt,S1,V1,S2,V2]);
end;

Function VersionQuadToString(Const Quad : TVersionQuad) : String;

begin
  Result:=Format('%d.%d.%d.%d',[Quad[1],Quad[2],Quad[3],Quad[4]]);
end;

Function NewerVersion(Q1,Q2 : TVersionQuad) : Boolean;

begin
   Result:=False;
   Case CompareVersionQuads(Q1,Q2) of
     vcEqual        : Result:=False;
     vcBuildDiffers : Result:=Q1[4]>Q2[4];
     vcMinorDiffers : Result:=Q1[3]>Q2[3];
     vcMajorDiffers : Result:=Q1[2]>Q2[2];
     vcReleaseDiffers : Result:=Q1[1]>Q2[1];
   end;
end;

end.
