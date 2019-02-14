unit UCWinRestore;

{ Component to set forms position and measures to values
  when form closed last time.
  Simply set "RegKey" value to the registry key in which the settings
  shall be stored.
  Tested with Delphi 5 but it should also work with D3 and D4.
  Freeware by UCSoft <info@ucsoft.de>
  http://www.ucsoft.de
  }

interface

uses
  Windows, Messages, SysUtils, Classes,
  vcl.Graphics, vcl.Forms, vcl.Dialogs;
//  vcl.Controls ;

type
  TUCWinRestore = class(TComponent)
  private
    { Private-Deklarationen }
    FRegKey : string;
    FRegValueName : string;
    FOwner : TForm;
    procedure SetRegKey(NewKey : string);
    procedure SaveWinCoordinates;
    procedure LoadWinCoordinates;
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    //    procedure BeforeDestruction; override;
  published
    { Published-Deklarationen }
    property RegKey : string read FRegKey write SetRegKey;
  end;

procedure Register;

implementation
uses Registry;


{$R *.RES}

constructor TUCWinRestore.Create(AOwner : TComponent);
  const
  ValueExt = '_WinCoordinates';
  basekey = 'Software\WWD\App\';

begin
  inherited Create(AOwner);
  FRegKey:=basekey;
  FRegValueName:=Owner.Name+ValueExt;
  FOwner:=(Owner as TForm);
end;

procedure TUCWinRestore.Loaded;
begin
  LoadWinCoordinates;
end;

destructor TUCWinRestore.Destroy;
begin
  SaveWinCoordinates;
  inherited Destroy;
end;

procedure TUCWinRestore.SetRegKey(NewKey : string);
begin
  if NewKey<>FRegKey then
    FRegKey:=NewKey;
end;

procedure TUCWinRestore.SaveWinCoordinates;
  var
  r : TRect;
  Reg : TRegistry;

begin
  r.Left:=FOwner.Left;
  r.Top:=FOwner.Top;
  r.Right:=FOwner.Width;
  r.Bottom:=FOwner.Height;
  Reg:=TRegistry.Create;
  Reg.Openkey(FRegKey,true);
  Reg.WriteBinaryData(FRegValueName,r,SizeOf(TRect));
  Reg.Free;
end;

procedure TUCWinRestore.LoadWinCoordinates;
  var
  r : TRect;
  Reg : TRegistry;

begin
  Reg:=TRegistry.Create;
  Reg.Openkey(FRegKey,false);
  if Reg.ValueExists(FRegValueName) then
  begin
    Reg.ReadBinaryData(FregValueName,r,Sizeof(TRect));
    FOwner.Left:=r.Left;
    FOwner.Top:=r.Top;
    FOwner.Width:=r.Right;
    FOwner.Height:=r.Bottom;
  end;
  Reg.Free;
end;

procedure Register;
begin
  RegisterComponents('UCSoft', [TUCWinRestore]);
end;

end.

