unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  IPPeerServer, System.Actions, FMX.ActnList, FMX.StdCtrls, FMX.Layouts,
  FMX.Memo, System.Tether.Manager, FMX.Menus, System.Tether.AppProfile,
  FMX.Edit, FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    TetheringManager1: TTetheringManager;
    ToolBar1: TToolBar;
    Button1: TButton;
    ActionList1: TActionList;
    actConnect: TAction;
    actLogLine: TAction;
    actClearLog: TAction;
    TetheringAppProfile1: TTetheringAppProfile;
    Panel1: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    EditButton1: TEditButton;
    Label2: TLabel;
    lblSomeReply: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageControl1: TImageControl;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    ImageControl2: TImageControl;
    Button2: TButton;
    actToggleChecked: TAction;
    GroupBox3: TGroupBox;
    Switch1: TSwitch;
    Label5: TLabel;
    lblStatus: TLabel;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    procedure actConnectUpdate(Sender: TObject);
    procedure actConnectExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TetheringManager1RequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure TetheringManager1PairedToRemote(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringAppProfile1ResourceReceived(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure EditButton1Click(Sender: TObject);
    procedure ImageControl1Click(Sender: TObject);
    procedure actToggleCheckedExecute(Sender: TObject);
    procedure TetheringManager1UnPairManager(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure actToggleCheckedUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  rtti;

{$R *.fmx}

procedure TForm1.actConnectExecute(Sender: TObject);
begin
  if TetheringManager1.PairedManagers.Count > 0 then
  begin
    TetheringManager1.UnPairManager(TetheringManager1.PairedManagers.First);
  end
  else
  begin
    TetheringManager1.AutoConnect;
  end;
end;

procedure TForm1.actConnectUpdate(Sender: TObject);
begin
  if TetheringManager1.PairedManagers.Count > 0 then
  begin
    actConnect.Text := 'Disconnect';
  end
  else
  begin
    actConnect.Text := 'Connect';
    lblStatus.Text := 'Disconnected';
  end;
end;

procedure TForm1.actToggleCheckedExecute(Sender: TObject);
begin
  Switch1.IsChecked := not Switch1.IsChecked;
end;

procedure TForm1.actToggleCheckedUpdate(Sender: TObject);
begin
  actToggleChecked.Enabled := CheckBox1.IsChecked;
end;

procedure TForm1.EditButton1Click(Sender: TObject);
begin
  TetheringAppProfile1.Resources.FindByName('SomeText').Value := Edit1.Text;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := TetheringManager1.Identifier;
end;

procedure TForm1.ImageControl1Click(Sender: TObject);
var
  LStream : TMemoryStream;
begin
  if OpenDialog1.Execute then
  begin
    ImageControl1.LoadFromFile(OpenDialog1.FileName);

    Lstream := TMemoryStream.Create;
    ImageControl1.Bitmap.SaveToStream(LStream);
    LStream.Position := 0;

    TetheringAppProfile1.Resources.FindByName('SomeImage').Value := LStream;
  end;
end;

procedure TForm1.TetheringAppProfile1ResourceReceived(const Sender: TObject;
  const AResource: TRemoteResource);
begin
  if AResource.Hint = 'ReplyText' then
  begin
    TThread.Synchronize(nil, procedure
                             begin
                              lblSomeReply.Text := AResource.Value.AsString;
                             end);
  end
  else if AResource.Hint = 'ReplyImage' then
  begin
    TThread.Synchronize(nil, procedure
                             begin
                              Aresource.Value.AsStream.Position := 0;
                              ImageControl2.Bitmap.LoadFromStream(Aresource.Value.AsStream);
                             end);
  end;
end;

procedure TForm1.TetheringManager1PairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  lblStatus.Text := Format('Connected : %s %s', [AManagerInfo.ManagerIdentifier, AManagerInfo.ManagerName]);
end;

procedure TForm1.TetheringManager1RequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Password := 'foobar';
end;

procedure TForm1.TetheringManager1UnPairManager(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  lblStatus.Text := 'Disconnected';
end;

end.
