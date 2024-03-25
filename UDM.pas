unit UDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, IniFiles, FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDm = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDQuery1: TFDQuery;
    FDQueryBanco: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LerEConectar(var ArquivoINI: TIniFile);
    procedure IniciaArquivoINI;
    procedure GetTabelasBase;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Principal;
{$R *.dfm}

procedure TDm.DataModuleCreate(Sender: TObject);
begin
  IniciaArquivoINI;

end;

procedure TDm.LerEConectar(var ArquivoINI: TIniFile);
begin
  try
    ArquivoINI := TIniFile.Create(ExtractFileDir(GetCurrentDir) +
      '\ConfiguracaoBD.ini');
    with Dm.FDConnection1 do
    begin
      Params.Clear;
      Params.Values['DriverID'] := 'FB';
      Params.Values['Server'] := ArquivoINI.ReadString('BANCO', 'Servidor', '');
      Params.Values['Database'] := ArquivoINI.ReadString('BANCO',
        'BancoDados', '');
      Params.Values['User_name'] := ArquivoINI.ReadString('BANCO',
        'Usuario', '');
      Params.Values['Password'] := ArquivoINI.ReadString('BANCO', 'Senha', '');
      Connected := True;
    end;
  finally
    frmPrincipal.EditServer.Text := ArquivoINI.ReadString('BANCO',
      'Servidor', '');
    frmPrincipal.EditCaminhoDb.Text := ArquivoINI.ReadString('BANCO',
      'BancoDados', '');
  end;

end;

procedure TDm.GetTabelasBase;
begin
  FDQueryBanco.Close;
  FDQueryBanco.Open();
end;

procedure TDm.IniciaArquivoINI;
var
  ACaminhoINI: string;
  ArquivoINI: TIniFile;
begin
  ACaminhoINI := ExtractFileDir(GetCurrentDir) + '\ConfiguracaoBD.ini';
  try
    if FileExists(ACaminhoINI) then
    begin
      LerEConectar(ArquivoINI);
    end;
  finally
    ArquivoINI.Free;
  end;
end;

end.
