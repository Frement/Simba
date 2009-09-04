unit TestUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Client, MufasaTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

type
    TMyThread = class(TThread)
    private
    protected
      procedure Execute; override;
    public
      Constructor Create(CreateSuspended : boolean);
    end;

  constructor TMyThread.Create(CreateSuspended : boolean);
  begin
    FreeOnTerminate := True;
    inherited Create(CreateSuspended);
  end;

procedure TMyThread.Execute;
Var
   Client: TClient;
   w,h, x, y, xx, yy, i:integer;
   bmp: TBitmap;
   ReturnData : TRetData;
   arr: Array Of Integer;
   LoopY,LoopX : integer;

begin
  while (not Terminated)  do
  begin

  Writeln('Creating the client');
  Client := TClient.Create;
  Writeln('Getting the dimensions');
  Client.MWindow.GetDimensions(w, h);
  writeln(inttostr(w) + ' , ' + inttostr(h));
  Writeln('Setting target');
//  Client.MWindow.SetTarget(67232,w_window);

{  SetLength(Arr, 9);
  for i := 0 to high(arr) do
    arr[i] := $FFFFFF;

  Client.MWIndow.SetTarget(PRGB32(@Arr[0]), Point(3, 3));    }

//  Client.MWindow.ActivateClient;
  Client.MWindow.GetDimensions(w, h);
  Writeln('Copying BMP');
  bmp := Client.MWindow.CopyClientToBitmap(0, 0, w, h);

  {$IFDEF WINDOWS}
  bmp.SaveToFile('c:\test1.bmp');
  {$ENDIF}
  {$IFDEF LINUX}
  bmp.SaveToFile('/tmp/test1.bmp');
  {$ENDIF}
//  bmp.Free;

 //Sleep(1000);
  Client.MInput.GetMousePos(x, y);
  writeln(inttostr(x) + ' , ' + inttostr(y));

  Client.MInput.SetMousePos(50, 50);
  Client.MInput.GetMousePos(x, y);
  writeln(inttostr(x) + ' , ' + inttostr(y));

  Client.MInput.ClickMouse(60, 60, mouse_Right);
  LoopX:= w div 2;
  LoopY:= h div 2;
  bmp.SetSize(Loopx + 1, Loopy + 1);
  ReturnData := Client.MWindow.ReturnData(0, 0, Loopx + 1, Loopy + 1);
  SetLength(Arr,(Loopy + 1) * (Loopx + 1));
  for yy := 0 to Loopy do
  begin;
    for xx := 0 to Loopx do
    begin
      { Do comparison here }
      Arr[yy * (loopx + 1) + xx] :=RGBToColor(ReturnData.Ptr^.B,ReturnData.Ptr^.G,ReturnData.Ptr^.R);
      Bmp.Canvas.Pixels[xx,yy] := clwhite xor RGBToColor(ReturnData.Ptr^.R,ReturnData.Ptr^.G,ReturnData.Ptr^.B);
      inc(ReturnData.Ptr);
    end;
    Inc(ReturnData.Ptr,ReturnData.IncPtrWith);
  end;
  {$IFDEF WINDOWS}
  bmp.SaveToFile('c:\test2.bmp');
  {$ENDIF}
  {$IFDEF LINUX}
  bmp.SaveToFile('/tmp/test2.bmp');
  {$ENDIF}
  Bmp.free;
//  Client.MWIndow.SetTarget(PRGB32(@Arr[0]), Point(Loopx + 1, Loopy + 1));
  Client.MWindow.FreeReturnData;

  Client.MInput.IsMouseButtonDown(mouse_Left);
  Sleep(1000);
  if Client.MInput.IsMouseButtonDown(mouse_Left) then
    writeln('Left mouse is down!');
  if Client.MInput.IsMouseButtonDown(mouse_Right) then
    writeln('Right mouse is down!');
  if Client.MInput.IsMouseButtonDown(mouse_Middle) then
    writeln('Middle mouse is down!');
  Client.Destroy;
  writeln('Test completed successfully');
  break;
  end;
end;


{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
Var
   MyThread: TMyThread;

begin
  MyThread := TMyThread.Create(True);
  MyThread.Resume;
end;

initialization
  {$I testunit.lrs}

end.

