object dmSmall: TdmSmall
  OldCreateOrder = False
  Left = 369
  Top = 125
  Height = 150
  Width = 215
  object BdSmall: TIBDatabase
    DatabaseName = 'C:\Arquivos de programas\SmallSoft\Small Commerce\SMALL.GDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=ISO8859_1')
    LoginPrompt = False
    DefaultTransaction = IBTransaction1
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 16
    Top = 16
  end
  object IBTransaction1: TIBTransaction
    Active = False
    DefaultDatabase = BdSmall
    Params.Strings = (
      'concurrency'
      'nowait')
    AutoStopAction = saNone
    Left = 48
    Top = 16
  end
  object IBQuerySmall: TIBQuery
    Database = BdSmall
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      'select * from usuario order by cod asc')
    Left = 80
    Top = 16
  end
  object IBQueryPagto: TIBQuery
    Database = BdSmall
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    SQL.Strings = (
      
        'select valor from pagament where pedido = :numPedido and forma =' +
        ' :pagto')
    Left = 112
    Top = 16
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'numPedido'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'pagto'
        ParamType = ptUnknown
      end>
  end
  object IBQuery2: TIBQuery
    Database = BdSmall
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 144
    Top = 16
  end
end
