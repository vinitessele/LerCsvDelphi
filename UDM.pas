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
    FDQueryBancoRDBRELATION_NAME: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LerEConectar(var ArquivoINI: TIniFile);
    procedure IniciaArquivoINI;
    procedure LerTabelasBD;
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
  LerTabelasBD;
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
    frmPrincipal.EditUsuario.Text := ArquivoINI.ReadString('BANCO',
      'Usuario', '');
    frmPrincipal.EditSenha.Text := ArquivoINI.ReadString('BANCO', 'Senha', '');
  end;

end;

procedure TDm.LerTabelasBD;
var
  APrincipal: TfrmPrincipal;
begin
  try
    FDQueryBanco.Close;
    FDQueryBanco.SQL.Clear;
    FDQueryBanco.SQL.Add('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$VIEW_BLR IS NULL AND (RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL);');
    FDQueryBanco.Open();
  Except
    on E: Exception do
    begin
      APrincipal:= TfrmPrincipal.Create(nil);
      APrincipal.Geralog(E.Message);
    end;
  end;

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
