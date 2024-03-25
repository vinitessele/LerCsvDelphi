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
  private
    { Private declarations }
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
  if CheckBoxPK.Checked then
    APk := 'primary key'
  else
    APk := EmptyStr;

  frmPrincipal.TipoDados := EditCampo.Text + ' ' + ComboBoxTipoDados.Text +
    EditDefinicao.Text + ' ' + APk;
  CheckBoxPK.Checked := False;
  close;
end;

procedure TFTipoDados.FormShow(Sender: TObject);
begin
  EditCampo.Text := Dados;
end;

end.
