unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, lcltype,
  ExtCtrls, Menus, UniqueInstance, FileUtil, Windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    ImageList1: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    TrayIcon2: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    F: TextFile;
    pass: string;
    bCreationFinished: boolean;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.WindowState := wsMinimized;
  bCreationFinished := False;

  AssignFile(F, 'AutoLoginOrion.cfg');
  Reset(F);
  Read(F, pass);
  CloseFile(F);

  ImageList1.GetIcon(0, TrayIcon1.Icon);

  Timer1.Enabled := True;

  Hide;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if (Sender as TCheckBox).Checked then
    Timer1.Enabled := True
  else
    Timer1.Enabled := False;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if not bCreationFinished then
  begin
    bCreationFinished := True;
    Application.Minimize;
  end;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if WindowState = wsMinimized then
  begin
    Hide;
    TrayIcon1.Visible := True;
  end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);  //ON
begin
  Timer1.Enabled := True;
  PopupMenu1.Items[0].Enabled := False;
  PopupMenu1.Items[1].Enabled := True;
  ImageList1.GetIcon(0, TrayIcon1.Icon);
  CheckBox1.Checked := True;

  AssignFile(F, 'AutoLoginOrion.cfg');
  Reset(F);
  Read(F, pass);
  CloseFile(F);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);  //OFF
begin
  Timer1.Enabled := False;
  PopupMenu1.Items[0].Enabled := True;
  PopupMenu1.Items[1].Enabled := False;
  ImageList1.GetIcon(1, TrayIcon1.Icon);
  CheckBox1.Checked := False;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Application.Terminate;
end;


procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  //  TrayIcon1.Visible := False;
  //  WindowState := wsNormal;
  //  Show;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  wnd, edit, panel: HWND;
begin
  wnd := FindWindow('TfrmSetMark', nil);
  if not IsWindowVisible(wnd) then
    exit;
  if wnd <> 0 then
  begin
    panel := FindWindowEx(wnd, 0, 'TPanel', nil);
    if panel <> 0 then
    begin
      edit := FindWindowEx(panel, 0, 'TEdit', nil);
      if edit <> 0 then
      begin
        SendMessage(edit, WM_SETTEXT, 0, lparam(PChar(Self.pass)));
        PostMessage(edit, WM_KEYDOWN, VK_RETURN, 0);
      end;
    end;
  end;
end;

end.
