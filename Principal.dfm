object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 509
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 494
    Height = 169
    Caption = 'Conex'#227'o Banco de dados'
    TabOrder = 0
    object EditCaminhoDb: TEdit
      Left = 16
      Top = 69
      Width = 288
      Height = 23
      TabOrder = 0
      TextHint = 'Caminho BD'
    end
    object EditUsuario: TEdit
      Left = 16
      Top = 99
      Width = 288
      Height = 23
      TabOrder = 1
      TextHint = 'Sysdba'
    end
    object btnBanco: TButton
      Left = 310
      Top = 39
      Width = 150
      Height = 26
      Caption = 'Conectar DB'
      TabOrder = 2
      OnClick = btnBancoClick
    end
    object EditSenha: TEdit
      Left = 16
      Top = 128
      Width = 288
      Height = 23
      PasswordChar = '*'
      TabOrder = 3
      TextHint = 'masterkey'
    end
    object EditServer: TEdit
      Left = 16
      Top = 40
      Width = 288
      Height = 23
      TabOrder = 4
      TextHint = 'LocalHost'
    end
    object btnSalvar: TButton
      Left = 310
      Top = 70
      Width = 150
      Height = 26
      Caption = 'Salvar Config.'
      TabOrder = 5
      OnClick = btnSalvarClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 191
    Width = 494
    Height = 123
    Caption = 'CSV'
    TabOrder = 1
    object btnLerArquivo: TButton
      Left = 310
      Top = 46
      Width = 150
      Height = 29
      Caption = 'Criar Tabela no Banco'
      Enabled = False
      TabOrder = 0
      OnClick = btnLerArquivoClick
    end
    object EditCaminho: TEdit
      Left = 16
      Top = 26
      Width = 273
      Height = 23
      TabOrder = 1
      TextHint = 'Caminho do Arquivo'
    end
    object btnImportar: TButton
      Left = 310
      Top = 81
      Width = 150
      Height = 26
      Caption = 'Importar BD'
      Enabled = False
      TabOrder = 2
      OnClick = btnImportarClick
    end
    object EditNomeTabela: TEdit
      Left = 16
      Top = 55
      Width = 273
      Height = 23
      TabOrder = 3
      TextHint = 'Nome do tabela'
      OnExit = EditNomeTabelaExit
    end
    object btnProcurarArquivo: TButton
      Left = 310
      Top = 14
      Width = 150
      Height = 26
      Caption = 'Procurar Arquivo'
      TabOrder = 4
      OnClick = btnProcurarArquivoClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 320
    Width = 494
    Height = 178
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'CSV|*.CSV'
    InitialDir = 'c:\'
    Left = 440
    Top = 328
  end
  object OpenDialog2: TOpenDialog
    Filter = 'FDB|*.FDB'
    InitialDir = 'C:\'
    Left = 432
    Top = 24
  end
  object DataSource1: TDataSource
    DataSet = Dm.FDQueryBanco
    Left = 288
    Top = 336
  end
end
