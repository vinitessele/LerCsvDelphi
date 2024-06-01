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
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LerArquivoMontarCreate(_ACaminho: string);
    function MontarCreate(_ALinha: string): string;
    function MontarInsert(_ALinha: string): string;
    function IsNumeric(const Value: string): Boolean;
  public
    { Public declarations }
    TipoDados: string;
    Procedure Geralog(_AOrigem, _AMensagem: string);
  end;

var
  frmPrincipal: TfrmPrincipal;
  ASQLInsert: string;
  ATabelaExistente: Boolean;

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
  OriginalString, SubStringToFind, SubStringToReplace: string;
  I: Integer;
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

    if ATabelaExistente then
    begin
      linha := EmptyStr;
      DM.FDQueryColunas.Close;
      DM.FDQueryColunas.ParamByName('pTabela').AsString := EditNomeTabela.text;
      DM.FDQueryColunas.Open;

      DM.FDQueryColunas.First;
      while DM.FDQueryColunas.Eof do
      begin
        if I < DM.FDQueryColunas.RecordCount - 1 then
          linha := linha + DM.FDQueryColunas.FieldByName('RDB$RELATION_FIELD')
            .AsString + ','
        else
          linha := linha + DM.FDQueryColunas.FieldByName
            ('RDB$RELATION_FIELD').AsString;
        inc(I);
      end;

    end;
    OriginalString := linha;
    SubStringToFind := 'date,';
    SubStringToReplace := 'data,';
    OriginalString := StringReplace(OriginalString, SubStringToFind,
      SubStringToReplace, [rfReplaceAll, rfIgnoreCase]);

    ASQLInsert := 'insert into ' + EditNomeTabela.text + '(' + OriginalString;
    while not Eof(arquivoCSV) do
    begin
      Readln(arquivoCSV, linha);
      MontarInsert(linha);
    end;
    CloseFile(arquivoCSV);
  Except
    on E: Exception do
    begin
      Geralog('btnImportarClick', E.Message);
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
  ATabelaExistente := True;
end;

procedure TfrmPrincipal.EditNomeTabelaExit(Sender: TObject);
begin
  if EditNomeTabela.text <> EmptyStr then
  begin
    btnLerArquivo.Enabled := True;
    btnImportar.Enabled := True;
  end;

end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  ATabelaExistente := False;
end;

procedure TfrmPrincipal.Geralog(_AOrigem, _AMensagem: string);
var
  ACaminho: string;
  APath: string;
  arq: TextFile;
begin
  ACaminho := ExtractFileDir(GetCurrentDir);
  APath := ACaminho + '\arquivo.log';

  AssignFile(arq, APath);
  if not FileExists(APath) then
    Rewrite(arq, APath);
  Append(arq);

  Writeln(arq, _AOrigem + '-' + _AMensagem);
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
    Geralog('MontarCreate', ASQLCreate);
    DM.FDQueryMontarSQL.Close;
    DM.FDQueryMontarSQL.SQL.Add(ASQLCreate);
    DM.FDQueryMontarSQL.ExecSQL;
    ShowMessage('Sucesso na criação da tabela ' + EditNomeTabela.text);
  Except
    on E: Exception do
    begin
      Geralog('MontarCreate', E.Message);
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
  ASQLInsert := ASQLInsert + ') values (';
  ExtractStrings([','], [], PChar(_ALinha), Asaida);

  for I := 0 to Asaida.Count - 1 do
  begin
    if Asaida.Count >= 1 then
    begin
      if not IsNumeric(Asaida[I]) then
        Asaida[I] := QuotedStr(Asaida[I]);

      if I < Asaida.Count - 1 then
        ASQLInsert := ASQLInsert + Asaida[I] + ', '
      else
        ASQLInsert := ASQLInsert + Asaida[I] + ') ';
    end;
  end;
  try
    Geralog('MontarInsert', ASQLInsert);
    DM.FDQueryMontarSQL.Close;
    DM.FDQueryMontarSQL.SQL.Add(ASQLInsert);
    DM.FDQueryMontarSQL.ExecSQL;

  Except
    on E: Exception do
    begin
      Geralog('MontarInsert', E.Message);
      ShowMessage('Erro ao executar comando de insert da tabela ' + E.Message);
      Close;
    end;
  end;

end;

function TfrmPrincipal.IsNumeric(const Value: string): Boolean;
var
  IntValue: Integer;
begin
  Result := TryStrToInt(Value, IntValue);
end;

end.
