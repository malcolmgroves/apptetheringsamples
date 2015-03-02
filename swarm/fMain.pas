unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  IPPeerServer, System.Tether.Manager, System.Tether.AppProfile, FMX.Layouts,
  FMX.ListBox, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    TetheringManager1: TTetheringManager;
    TetheringAppProfile1: TTetheringAppProfile;
    ListBox1: TListBox;
    procedure TetheringManager1RequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure TetheringManager1NewManager(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1PairedToRemote(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1PairedFromLocal(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1RemoteManagerShutdown(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure TetheringManager1UnPairManager(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSwarmList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := TetheringManager1.Identifier;
end;

procedure TForm1.LoadSwarmList;
begin
  TThread.Synchronize(nil, procedure
                           var
                             LPairedManager: TTetheringManagerInfo;
                           begin
                            ListBox1.Clear;
                            for LPairedManager in TetheringManager1.PairedManagers do
                            begin
                              ListBox1.Items.Add(Format('%s %s', [LPairedManager.ManagerIdentifier, LPairedManager.ConnectionString]));
                            end;
                           end);
end;

procedure TForm1.TetheringManager1NewManager(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  if not TetheringManager1.PairedManagers.Contains(AManagerInfo) then
  begin
    TetheringManager1.PairManager(AManagerInfo);
    LoadSwarmList;
  end;
end;

procedure TForm1.TetheringManager1PairedFromLocal(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  LoadSwarmList;
end;

procedure TForm1.TetheringManager1PairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  LoadSwarmList;
end;

procedure TForm1.TetheringManager1RemoteManagerShutdown(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  LoadSwarmList;
end;

procedure TForm1.TetheringManager1RequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Password := 'bzzzbzzz';
end;

procedure TForm1.TetheringManager1UnPairManager(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  LoadSwarmList;
end;

end.
