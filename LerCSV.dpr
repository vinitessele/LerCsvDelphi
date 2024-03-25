program LerCSV;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {frmPrincipal},
  UTipoDados in 'UTipoDados.pas' {FTipoDados},
  UDM in 'UDM.pas' {Dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDm, Dm);
  Application.CreateForm(TFTipoDados, FTipoDados);
  Application.Run;
end.
