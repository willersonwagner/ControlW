unit impriNovo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls;

type
  TForm50 = class(TForm)
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Lanamentos1: TMenuItem;
    Consultas1: TMenuItem;
    Relatrios1: TMenuItem;
    OrdemdeServio1: TMenuItem;
    Cancelamentos1: TMenuItem;
    Peas1: TMenuItem;
    RelatrioPendentes1: TMenuItem;
    Encerrados1: TMenuItem;
    PorSitouDiag1: TMenuItem;
    PorCliente1: TMenuItem;
    Reimpresso1: TMenuItem;
    OrdemdeServio2: TMenuItem;
    Encerradas1: TMenuItem;
    Oramento1: TMenuItem;
    Sada1: TMenuItem;
    SepararPeas1: TMenuItem;
    Label2: TLabel;
    procedure OrdemdeServio1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OrdemdeServio2Click(Sender: TObject);
  private
    { Private declarations }
  public
    codOrdem : String;
    { Public declarations }
  end;

var
  Form50: TForm50;

implementation

uses CadServ, consultaOrdem;

{$R *.dfm}

procedure TForm50.OrdemdeServio1Click(Sender: TObject);
begin
  form51 := tform51.Create(self);
  form51.ShowModal;
  form51.Free;
end;

procedure TForm50.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

procedure TForm50.OrdemdeServio2Click(Sender: TObject);
begin
  form55 := tform55.create(self);
  form55.showmodal;
  form55.Free;
end;

end.
