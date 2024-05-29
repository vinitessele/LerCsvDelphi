unit UTipoDados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TFTipoDados = class(TForm)
    GroupBox1: TGroupBox;
    ComboBoxTipoDados: TComboBox;
    GroupBox2: TGroupBox;
    EditDefinicao: TEdit;
    Label1: TLabel;
    btnConfirma: TBitBtn;
    EditCampo: TEdit;
    CheckBoxPK: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnConfirmaClick(Sender: TObject);
    procedure ComboBoxTipoDadosChange(Sender: TObject);
  private
    { Private declarations }
    procedure TentaIdentificarTipoDado(_ACampo: string);
  public
    Dados: string;
    { Public declarations }
  end;

var
  FTipoDados: TFTipoDados;

implementation

{$R *.dfm}

uses Principal;

procedure TFTipoDados.btnConfirmaClick(Sender: TObject);
var
  APk: string;
begin

  if ((ComboBoxTipoDados.ItemIndex = 0) or (ComboBoxTipoDados.ItemIndex = 4))
    and (EditDefinicao.Text = EmptyStr) then
  begin
    ShowMessage('O campo deve ter uma definição');
    EditDefinicao.SetFocus;
    Exit;
  end;

  if CheckBoxPK.Checked then
    APk := 'primary key'
  else
    APk := EmptyStr;

  frmPrincipal.TipoDados := EditCampo.Text + ' ' + ComboBoxTipoDados.Text +
    EditDefinicao.Text + ' ' + APk;
  CheckBoxPK.Checked := False;

  close;
  ComboBoxTipoDados.ItemIndex := -1;
  EditDefinicao.Text := EmptyStr;
end;

procedure TFTipoDados.ComboBoxTipoDadosChange(Sender: TObject);
begin
  if (ComboBoxTipoDados.ItemIndex = 0) and (EditDefinicao.Text = EmptyStr) then
    EditDefinicao.Text := '(1000)';
  if (ComboBoxTipoDados.ItemIndex = 4) and (EditDefinicao.Text = EmptyStr) then
    EditDefinicao.Text := '(8,2)';
end;

procedure TFTipoDados.FormShow(Sender: TObject);
begin
  EditCampo.Text := Dados;
  TentaIdentificarTipoDado(EditCampo.Text);
end;

procedure TFTipoDados.TentaIdentificarTipoDado(_ACampo: string);
var
  i: Integer;
  AVarchar: TStringlist;
  AInteger: TStringlist;
  ADater: TStringlist;
begin
  AVarchar := TStringlist.Create;
  AInteger := TStringlist.Create;
  ADater := TStringlist.Create;

  AVarchar.Add('nome');
  AVarchar.Add('name');
  AVarchar.Add('email');
  AVarchar.Add('complement');
  AVarchar.Add('complemento');

  AInteger.Add('pk');
  AInteger.Add('id');

  ADater.Add('date');
  ADater.Add('data');

  for var Inteiro in AInteger do
  begin
    if _ACampo.Contains(Inteiro) then
    begin
      for i := 0 to ComboBoxTipoDados.Items.Count - 1 do
      begin
        if Pos('Integer', ComboBoxTipoDados.Items[i]) > 0 then
        begin
          if Inteiro = 'pk' then
            CheckBoxPK.Checked := True;

          ComboBoxTipoDados.ItemIndex := i;
          EditDefinicao.Text := EmptyStr;
          Break;
        end;
      end;
    end;
  end;

  for var Data in ADater do
  begin
    if _ACampo.Contains(Data) then
    begin
      for i := 0 to ComboBoxTipoDados.Items.Count - 1 do
      begin
        if Pos('Date', ComboBoxTipoDados.Items[i]) > 0 then
        begin
          ComboBoxTipoDados.ItemIndex := i;
          EditDefinicao.Text := EmptyStr;
          CheckBoxPK.Checked := False;
          Break;
        end;
      end;
    end;
  end;

  for var V in AVarchar do
  begin
    if _ACampo.Contains(V) then
    begin
      for i := 0 to ComboBoxTipoDados.Items.Count - 1 do
      begin
        if Pos('Varchar', ComboBoxTipoDados.Items[i]) > 0 then
        begin
          ComboBoxTipoDados.ItemIndex := i;
          EditDefinicao.Text := '(1000)';
          CheckBoxPK.Checked := False;
          Break;
        end;
      end;
    end;
  end;

  if ComboBoxTipoDados.ItemIndex = -1 then
  begin
    ComboBoxTipoDados.ItemIndex := 0;
    EditDefinicao.Text := '(1000)';
  end;

end;

end.
