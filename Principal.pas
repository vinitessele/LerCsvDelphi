unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.IniFiles,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Datasnap.DBClient;

type
  TfrmPrincipal = class(TForm)
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    bntLerArquivo: TButton;
    EditCaminho: TEdit;
    btnImportar: TButton;
    EditCaminhoDb: TEdit;
    EditUsuario: TEdit;
    EditNomeTabela: TEdit;
    btnBanco: TButton;
    EditSenha: TEdit;
    OpenDialog2: TOpenDialog;
    EditServer: TEdit;
    BtnSalvar: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure bntLerArquivoClick(Sender: TObject);
    procedure btnBancoClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);

  private
    { Private declarations }
    Procedure Geralog(_AMensagem: string);
    procedure LerArquivo(_ACaminho: string);
    function MontarCreate(_ALinha: string): string;
  public
    { Public declarations }
    TipoDados: string;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses UDM, UTipoDados;

procedure TfrmPrincipal.bntLerArquivoClick(Sender: TObject);
begin
  if OpenDialog1.execute then
    EditCaminho.text := OpenDialog1.filename;

  if ((EditCaminho.text <> EmptyStr) and
    (EditNomeTabela.text <> 'Nome da Tabela')) then
    LerArquivo(EditCaminho.text)
  else
    ShowMessage
      ('Adicione o caminho do arquivo e o nome da tabela que deseja criar')

end;

procedure TfrmPrincipal.btnBancoClick(Sender: TObject);
begin
  if OpenDialog2.execute then
    EditCaminhoDb.text := OpenDialog2.filename;

  try
    with DM.FDConnection1 do
    begin
      Params.Clear;
      Params.Values['DriverID'] := 'FB';
      Params.Values['Server'] := EditServer.text;
      Params.Values['Database'] := EditCaminhoDb.text;
      Params.Values['User_name'] := EditUsuario.text;
      Params.Values['Password'] := EditSenha.text;
      Connected := True;
      ShowMessage('Banco Conectado com sucesso');
    end;
  except
    ShowMessage('Ocorreu uma Falha na configuração no Banco Firebird!');
    EditNomeTabela.SetFocus;
  end;

end;

procedure TfrmPrincipal.BtnSalvarClick(Sender: TObject);
var
  ArquivoINI: TIniFile;
  ACaminhoINI: string;
  APath: string;
begin
  ACaminhoINI := ExtractFileDir(GetCurrentDir);
  APath := ACaminhoINI + '\ConfiguracaoBD.INI';
  ArquivoINI := TIniFile.Create(APath);
  try
    ArquivoINI.WriteString('BANCO', 'Servidor', EditServer.text);
    ArquivoINI.WriteString('BANCO', 'BancoDados', EditCaminhoDb.text);
    ArquivoINI.WriteString('BANCO', 'Usuario', EditUsuario.text);
    ArquivoINI.WriteString('BANCO', 'Senha', EditSenha.text);
  finally
    ArquivoINI.Free;
  end;
end;

procedure TfrmPrincipal.Geralog(_AMensagem: string);
var
  ACaminho: string;
  APath: string;
  Arq: TextFile;
begin
  ACaminho := ExtractFileDir(GetCurrentDir);
  APath := ACaminho + '\arquivo.log';

  AssignFile(Arq, APath);
  if not FileExists(APath) then
    Rewrite(Arq, APath);
  Append(Arq);

  Writeln(Arq, _AMensagem);
  Writeln(Arq, '');
  CloseFile(Arq);
end;

procedure TfrmPrincipal.LerArquivo(_ACaminho: string);
var
  arquivoCSV: TextFile;
  linha: string;
begin

  AssignFile(arquivoCSV, _ACaminho);
  Reset(arquivoCSV);
  Readln(arquivoCSV, linha);
  MontarCreate(linha);

end;

function TfrmPrincipal.MontarCreate(_ALinha: string): string;
var
  Asaida: TStrings;
  ASQLCreate: string;
  I: Integer;
begin
  Asaida := TStringList.Create;

  ASQLCreate := 'Create table ' + EditNomeTabela.text + '(';
  ExtractStrings([','], [], PChar(_ALinha), Asaida);

  for I := 0 to Asaida.Count - 1 do
  begin
    if Asaida.Count >= 1 then
    begin
      FTipoDados.Dados := Asaida[I];
      FTipoDados.ShowModal;
      if I < Asaida.Count - 1 then
        ASQLCreate := ASQLCreate + ' ' + TipoDados + ', '
      else
        ASQLCreate := ASQLCreate + ' ' + TipoDados + ') ';
    end;
  end;
  try
    Geralog(ASQLCreate);
    DM.FDQuery1.Close;
    DM.FDQuery1.SQL.Add(ASQLCreate);
    DM.FDQuery1.ExecSQL;
    ShowMessage('Sucesso na criação da tabela ' + EditNomeTabela.text);
  Except
    on E: Exception do
    begin
      Geralog(E.Message);
      ShowMessage('Erro ao executar comando de creação da tabela ' + E.Message);
      Close;
    end;
  end;
end;

end.
