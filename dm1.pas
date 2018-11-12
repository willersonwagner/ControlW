unit dm1;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBDatabase;

type
  TdmSmall = class(TDataModule)
    BdSmall: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBQuerySmall: TIBQuery;
    IBQueryPagto: TIBQuery;
    IBQuery2: TIBQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmSmall: TdmSmall;

implementation

{$R *.dfm}

end.
