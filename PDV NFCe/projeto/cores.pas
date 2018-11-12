unit cores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, JsBotao1, func,jpeg;

type
  TForm11 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ColorDialog1: TColorDialog;
    JsBotao1: JsBotao;
    Image1: TImage;
    SpeedButton3: TSpeedButton;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure JsBotao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

uses untDtmMain;

{$R *.dfm}

procedure TForm11.SpeedButton1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    begin
      Label1.Font.Color := ColorDialog1.Color;
      Label2.Font.Color := ColorDialog1.Color;
      Edit1.Text := ColorToString(ColorDialog1.Color);
    end;
end;

procedure TForm11.SpeedButton2Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    begin
      Panel1.Color := ColorDialog1.Color;
      Edit2.Text := ColorToString(ColorDialog1.Color);
    end;
end;

procedure TForm11.JsBotao1Click(Sender: TObject);
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'update or insert into CONFIG_TEMA(top, nome) values(1, :nome) matching (top)';
  dtmMain.IBQuery1.ParamByName('nome').AsString := '-1- ' + Edit1.Text + ' -2- ' + Edit2.Text + ' -';
  dtmMain.IBQuery1.ExecSQL;
  dtmMain.IBQuery1.Transaction.Commit;
  ShowMessage('Dados Gravados com Sucesso');
end;

procedure TForm11.FormShow(Sender: TObject);
var
  cor : String;
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'select nome from config_tema where top = 1';
  dtmMain.IBQuery1.Open;

  if dtmMain.IBQuery1.IsEmpty then
    begin
      dtmMain.IBQuery1.Close;
      exit;
    end;

  cor := dtmMain.IBQuery1.fieldbyname('nome').AsString;
  if cor = '' then
    begin
      dtmMain.IBQuery1.Close;
      exit;
    end;
  dtmMain.IBQuery1.Close;

  edit2.Text := LerConfig(cor, 2); //painel
  edit1.Text := LerConfig(cor, 1); //fonte
  Panel1.Color := StringToColor(edit2.Text);

  Label1.Font.Color := StringToColor(edit1.Text);
  Label2.Font.Color := StringToColor(edit1.Text);
  Label1.Color := StringToColor(edit1.Text);
  Label2.Color := StringToColor(edit1.Text);

  Panel1.Repaint;
end;

procedure TForm11.SpeedButton3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      //ShowMessage(OpenDialog1.FileName);
      //Image1.Picture.
      //Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    end;
  if OpenDialog1.FileName <> '' then Image1.Picture.LoadFromFile(OpenDialog1.FileName);  
end;

procedure TForm11.Button1Click(Sender: TObject);
begin
  dtmMain.IBQuery1.Close;
  dtmMain.IBQuery1.SQL.Text := 'update or insert into CONFIG_TEMA(top, nome) values(1, null) matching (top)';
  //dtmMain.IBQuery1.ParamByName('nome').AsString := ;
  dtmMain.IBQuery1.ExecSQL;
  dtmMain.IBQuery1.Transaction.Commit;
  ShowMessage('Dados Gravados com Sucesso');
end;

end.
