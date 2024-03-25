object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 509
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 433
    Height = 169
    Caption = 'Conex'#227'o Banco de dados'
    TabOrder = 0
    object EditCaminhoDb: TEdit
      Left = 16
      Top = 69
      Width = 288
      Height = 23
      TabOrder = 0
      Text = 'Caminho BD'
    end
    object EditUsuario: TEdit
      Left = 16
      Top = 99
      Width = 288
      Height = 23
      TabOrder = 1
      Text = 'SYSDBA'
    end
    object btnBanco: TButton
      Left = 310
      Top = 39
      Width = 85
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
      Text = 'masterkey'
    end
    object EditServer: TEdit
      Left = 16
      Top = 40
      Width = 288
      Height = 23
      TabOrder = 4
      Text = 'LocalHost'
    end
    object BtnSalvar: TButton
      Left = 310
      Top = 70
      Width = 85
      Height = 26
      Caption = 'Salvar Config.'
      TabOrder = 5
      OnClick = BtnSalvarClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 191
    Width = 433
    Height = 102
    Caption = 'CSV'
    TabOrder = 1
    object bntLerArquivo: TButton
      Left = 310
      Top = 24
      Width = 85
      Height = 26
      Caption = 'Ler arquivo'
      TabOrder = 0
      OnClick = bntLerArquivoClick
    end
    object EditCaminho: TEdit
      Left = 16
      Top = 26
      Width = 273
      Height = 23
      TabOrder = 1
      Text = 'Caminho do Arquivo'
    end
    object btnImportar: TButton
      Left = 310
      Top = 55
      Width = 85
      Height = 26
      Caption = 'Importar BD'
      TabOrder = 2
    end
    object EditNomeTabela: TEdit
      Left = 16
      Top = 55
      Width = 273
      Height = 23
      TabOrder = 3
      Text = 'Nome da Tabela'
    end
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 299
    Width = 441
    Height = 202
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object OpenDialog1: TOpenDialog
    Filter = 'CSV|*.CSV'
    InitialDir = 'c:\'
    Left = 416
    Top = 216
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
