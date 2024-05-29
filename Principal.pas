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
    btnLerArquivo: TButton;
    EditCaminho: TEdit;
    btnImportar: TButton;
    EditCaminhoDb: TEdit;
    EditUsuario: TEdit;
    EditNomeTabela: TEdit;
    btnBanco: TButton;
    EditSenha: TEdit;
    OpenDialog2: TOpenDialog;
    EditServer: TEdit;
    btnSalvar: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    btnProcurarArquivo: TButton;
    procedure btnBancoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure EditNomeTabelaExit(Sender: TObject);
    procedure btnProcurarArquivoClick(Sender: TObject);
    procedure btnLerArquivoClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure LerArquivoMontarCreate(_ACaminho: string);
    function MontarCreate(_ALinha: string): string;
    function MontarInsert(_ALinha: string): string;
  public
    { Public declarations }
    TipoDados: string;
    Procedure Geralog(Sender: TObject;_AMensagem: string);
  end;

var
  frmPrincipal: TfrmPrincipal;
  ASQLInsert: string;

implementation

{$R *.dfm}

uses UDM, UTipoDados;

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

procedure TfrmPrincipal.btnImportarClick(Sender: TObject);
var
  arquivoCSV: TextFile;
  linha: string;
begin
  try
  if EditCaminho.text = EmptyStr then
  begin
    ShowMessage('Aquivo CSV não encontrado');
    Exit;
  end;
    AssignFile(arquivoCSV, EditCaminho.text);
    Reset(arquivoCSV);
    Readln(arquivoCSV, linha);
    ASQLInsert := 'insert table ' + EditNomeTabela.text + '(' + linha;
    while not Eof(arquivoCSV) do
    begin
      Readln(arquivoCSV, linha);
      MontarInsert(linha);
    end;
    CloseFile(arquivoCSV);
  Except
    on E: Exception do
    begin
      Geralog(Sender, E.Message);
      ShowMessage('Erro ao executar comando de creação da tabela ' + E.Message);
      Close;
    end;

  end;
end;

procedure TfrmPrincipal.btnLerArquivoClick(Sender: TObject);
begin
  if ((EditCaminho.text <> EmptyStr) and (EditNomeTabela.text <> EmptyStr)) then
    LerArquivoMontarCreate(EditCaminho.text)
  else
  begin
    EditNomeTabela.text := EmptyStr;
    EditNomeTabela.SetFocus;
  end;
end;

procedure TfrmPrincipal.btnProcurarArquivoClick(Sender: TObject);
begin
  if OpenDialog1.execute then
    EditCaminho.text := OpenDialog1.filename;
end;

procedure TfrmPrincipal.btnSalvarClick(Sender: TObject);
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

procedure TfrmPrincipal.DBGrid1DblClick(Sender: TObject);
begin
  EditNomeTabela.text := DM.FDQueryBancoRDBRELATION_NAME.AsString;
  btnImportar.Enabled := True;
end;

procedure TfrmPrincipal.EditNomeTabelaExit(Sender: TObject);
begin
  if EditNomeTabela.text <> EmptyStr then
  begin
    btnLerArquivo.Enabled := True;
    btnImportar.Enabled := True;
  end;

end;

procedure TfrmPrincipal.Geralog(Sender: TObject;_AMensagem: string);
var
  ACaminho: string;
  APath: string;
  arq: TextFile;
  ClassRef: TComponent;
begin
  ClassRef := TComponent(Sender).Components[0].Owner;
  ACaminho := ExtractFileDir(GetCurrentDir);
  APath := ACaminho + '\arquivo.log';

  AssignFile(arq, APath);
  if not FileExists(APath) then
    Rewrite(arq, APath);
  Append(arq);

  Writeln(arq,ClassRef.ToString +'-'+ _AMensagem);
  Writeln(arq, '');
  CloseFile(arq);
end;

procedure TfrmPrincipal.LerArquivoMontarCreate(_ACaminho: string);
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
      if Asaida[I] = 'date' then
        Asaida[I] := 'data';
      FTipoDados.Dados := Asaida[I];
      FTipoDados.ShowModal;
      if I < Asaida.Count - 1 then
        ASQLCreate := ASQLCreate + ' ' + TipoDados + ', '
      else
        ASQLCreate := ASQLCreate + ' ' + TipoDados + ') ';
    end;
  end;
  try
    Geralog(nil, ASQLCreate);
    DM.FDQuery1.Close;
    DM.FDQuery1.SQL.Add(ASQLCreate);
    DM.FDQuery1.ExecSQL;
    ShowMessage('Sucesso na criação da tabela ' + EditNomeTabela.text);
  Except
    on E: Exception do
    begin
      Geralog(nil, E.Message);
      ShowMessage('Erro ao executar comando de creação da tabela ' + E.Message);
      Close;
    end;
  end;
end;

function TfrmPrincipal.MontarInsert(_ALinha: string): string;
var
  Asaida: TStrings;
  I: Integer;
begin
  Asaida := TStringList.Create;
  ASQLInsert := ASQLInsert + 'values(';
  ExtractStrings([','], [], PChar(_ALinha), Asaida);

  for I := 0 to Asaida.Count - 1 do
  begin
    if Asaida.Count >= 1 then
    begin
      if I < Asaida.Count - 1 then
        ASQLInsert := ASQLInsert + Asaida[I] + ', '
      else
        ASQLInsert := ASQLInsert + Asaida[I] + ') ';
    end;
  end;
  try
    Geralog(nil, ASQLInsert);
    DM.FDQuery1.Close;
    DM.FDQuery1.SQL.Add(ASQLInsert);
    DM.FDQuery1.ExecSQL;

  Except
    on E: Exception do
    begin
      Geralog(nil, E.Message);
      ShowMessage('Erro ao executar comando de insert da tabela ' + E.Message);
      Close;
    end;
  end;

end;

end.
