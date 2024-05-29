object FTipoDados: TFTipoDados
  Left = 0
  Top = 0
  Caption = 'Tipo de dados'
  ClientHeight = 350
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 24
    Width = 265
    Height = 105
    Caption = 'Tipo Dados'
    TabOrder = 0
    object ComboBoxTipoDados: TComboBox
      Left = 16
      Top = 72
      Width = 225
      Height = 23
      TabOrder = 0
      Text = 'Tipo Dados'
      OnChange = ComboBoxTipoDadosChange
      Items.Strings = (
        'Varchar'
        'Integer'
        'SmallInt'
        'Float'
        'Numeric'
        'Date'
        'Boolean'
        'Blob'
        'Char')
    end
    object EditCampo: TEdit
      Left = 16
      Top = 32
      Width = 225
      Height = 23
      Enabled = False
      TabOrder = 1
      Text = 'Campo'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 135
    Width = 265
    Height = 202
    Caption = 'Defini'#231#227'o'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 225
      Height = 45
      Caption = 
        'Use a Defini'#231#227'o para complementar o tipo de dado Ex: Tipo Varcha' +
        'r Defini'#231#227'o (50), Numeric, Defini'#231#227'o(5,2)'
      WordWrap = True
    end
    object EditDefinicao: TEdit
      Left = 16
      Top = 88
      Width = 225
      Height = 23
      TabOrder = 0
    end
    object btnConfirma: TBitBtn
      Left = 80
      Top = 152
      Width = 75
      Height = 25
      Caption = 'Confirma'
      TabOrder = 1
      OnClick = btnConfirmaClick
    end
    object CheckBoxPK: TCheckBox
      Left = 16
      Top = 129
      Width = 97
      Height = 17
      Caption = 'PK'
      TabOrder = 2
    end
  end
end
