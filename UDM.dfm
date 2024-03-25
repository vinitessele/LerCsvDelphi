object Dm: TDm
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=D:\Users\Vinicius\Documents\Embarcadero\Studio\Projects' +
        '\LerCSV\bd\BANCODADOS.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Left = 56
    Top = 32
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
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
        'S NULL;'
      '')
    Left = 200
    Top = 120
  end
end
