unit lpClassHelper;

{$mode objfpc}{$H+}
{$I Simba.inc}

interface

uses
  Classes, SysUtils, lpcompiler, lptypes, lpvartypes;

type
  TLapeCompilerHelper = class helper for TLapeCompiler
  public
    procedure addClass(const Name: string; const Parent: string = 'TObject');
    procedure addClassVar(const Obj, Item, Typ: string; const Read: Pointer; const Write: Pointer = nil; const Arr: boolean = False; const ArrType: string = 'UInt32');
  end;

implementation

procedure TLapeCompilerHelper.addClass(const Name: string; const Parent: string = 'TObject');
begin
  addGlobalType(Format('type %s', [Parent]), Name);
end;

procedure TLapeCompilerHelper.addClassVar(const Obj, Item, Typ: string; const Read: Pointer; const Write: Pointer = nil; const Arr: boolean = False; const ArrType: string = 'UInt32');
var
  Param: string;
begin
  Param := '';
  if Arr then
    Param := 'const Index: ' + ArrType;

  if (Assigned(Read)) then
    addGlobalFunc(Format('function %s.get%s(%s): %s;', [Obj, Item, Param, Typ]), Read);

  if Arr then
    Param += '; ';

  if (Assigned(Write)) then
    addGlobalFunc(Format('procedure %s.set%s(%sconst Value: %s);', [Obj, Item, Param, Typ]), Write);
end;

end.

