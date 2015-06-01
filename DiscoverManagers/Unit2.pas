unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  IPPeerServer, System.Tether.Manager, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  System.Tether.AppProfile;

type
  TForm2 = class(TForm)
    TetheringManager1: TTetheringManager;
    ToolBar1: TToolBar;
    ListBox1: TListBox;
    Button1: TButton;
    TetheringAppProfile1: TTetheringAppProfile;
    procedure TetheringManager1RequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure Button1Click(Sender: TObject);
    procedure TetheringManager1EndManagersDiscovery(const Sender: TObject;
      const ARemoteManagers: TTetheringManagerInfoList);
    procedure TetheringManager1EndProfilesDiscovery(const Sender: TObject;
      const ARemoteProfiles: TTetheringProfileInfoList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
begin
  Listbox1.Items.Add('TetheringManager.DiscoverManagers');
  TetheringManager1.DiscoverManagers;
end;

procedure TForm2.TetheringManager1EndManagersDiscovery(const Sender: TObject;
  const ARemoteManagers: TTetheringManagerInfoList);
var
  LRemoteManager : TTetheringManagerInfo;
begin
  Listbox1.Items.Add('TetheringManager.OnEndManagersDiscovery');
  Listbox1.Items.Add(Format('  %d Managers Discovered', [ARemoteManagers.Count]));
  for LRemoteManager in ARemoteManagers do
    TetheringManager1.PairManager(LRemoteManager);
end;

procedure TForm2.TetheringManager1EndProfilesDiscovery(const Sender: TObject;
  const ARemoteProfiles: TTetheringProfileInfoList);
var
  LRemoteProfile: TTetheringProfileInfo;
begin
  Listbox1.Items.Add('TetheringManager.OnEndProfilesDiscovery');
  Listbox1.Items.Add(Format('  %d profiles discovered', [ARemoteProfiles.Count]));
  for LRemoteProfile in ARemoteProfiles do
    if LRemoteProfile.ProfileGroup = TetheringAppProfile1.Group then
    begin
      Listbox1.Items.Add('  Profile found in same group. Pairing.');
      TetheringAppProfile1.Connect(LRemoteProfile);
    end;
end;

procedure TForm2.TetheringManager1RequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Listbox1.Items.Add('TetheringManager.OnPasswordRequested');
  Password := 'foobar';
end;

end.
