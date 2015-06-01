unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  IPPeerServer, System.Tether.Manager, System.Tether.AppProfile, FMX.Layouts,
  FMX.Memo, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, System.Actions,
  FMX.ActnList, FMX.ListBox;

type
  TForm2 = class(TForm)
    TetheringManager1: TTetheringManager;
    TetheringAppProfile1: TTetheringAppProfile;
    Panel1: TPanel;
    Label1: TLabel;
    lblSomeText: TLabel;
    Edit1: TEdit;
    EditButton1: TEditButton;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ImageControl1: TImageControl;
    Label3: TLabel;
    Label4: TLabel;
    ImageControl2: TImageControl;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Button2: TButton;
    ActionList1: TActionList;
    Action1: TAction;
    Button3: TButton;
    Label6: TLabel;
    procedure TetheringAppProfile1Resources0ResourceReceived(
      const Sender: TObject; const AResource: TRemoteResource);
    procedure EditButton1Click(Sender: TObject);
    procedure TetheringAppProfile1Resources1ResourceReceived(
      const Sender: TObject; const AResource: TRemoteResource);
    procedure ImageControl2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}
{$R *.Macintosh.fmx _MACOS}

procedure TForm2.Button3Click(Sender: TObject);
begin
  TetheringAppProfile1.RunRemoteAction(TetheringManager1.RemoteProfiles.First,
                                       'actToggleChecked' );
end;

procedure TForm2.EditButton1Click(Sender: TObject);
begin
  TetheringAppProfile1.SendString(TetheringManager1.RemoteProfiles.First,
                                  'ReplyText',
                                  Edit1.Text);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Caption := TetheringManager1.Identifier;
end;

procedure TForm2.ImageControl2Click(Sender: TObject);
var
  LStream : TMemoryStream;
begin
  if OpenDialog1.Execute then
  begin
    ImageControl2.LoadFromFile(OpenDialog1.FileName);

    Lstream := TMemoryStream.Create;
    ImageControl2.Bitmap.SaveToStream(LStream);
    LStream.Position := 0;
    TetheringAppProfile1.SendStream(TetheringManager1.RemoteProfiles.First,
                                    'ReplyImage',
                                    LStream);
  end;
end;

procedure TForm2.TetheringAppProfile1Resources0ResourceReceived(
  const Sender: TObject; const AResource: TRemoteResource);
begin
  lblSomeText.Text := AResource.Value.AsString;
end;

procedure TForm2.TetheringAppProfile1Resources1ResourceReceived(
  const Sender: TObject; const AResource: TRemoteResource);
begin
  Aresource.Value.AsStream.Position := 0;
  ImageControl1.Bitmap.LoadFromStream(Aresource.Value.AsStream);
end;

end.
