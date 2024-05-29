object Dm: TDm
  OnCreate = DataModuleCreate
  Height = 229
  Width = 293
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=D:\Users\Vinicius\Documents\Embarcadero\Studio\Projects' +
        '\LerCSV\bd\BD.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Connected = True
    Left = 56
    Top = 32
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 
      'D:\Users\Vinicius\Documents\Embarcadero\Studio\Projects\LerCSV\W' +
      'in32\Debug\fbclient.dll'
    Left = 48
    Top = 112
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 200
    Top = 24
  end
  object FDQueryBanco: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      
        'SELECT RDB$RELATION_NAME FROM RDB$RELATIONS WHERE RDB$VIEW_BLR I' +
        'S NULL AND (RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL)'
      '')
    Left = 200
    Top = 120
    object FDQueryBancoRDBRELATION_NAME: TWideStringField
      FieldName = 'RDB$RELATION_NAME'
      Origin = 'RDB$RELATION_NAME'
      FixedChar = True
      Size = 31
    end
  end
end
