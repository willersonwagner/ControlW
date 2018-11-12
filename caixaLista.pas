unit caixaLista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm39 = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    //PadraoSeNaoExistir : TStringList;
    procedure buscaListaBox(nome: String);

    { Private declarations }
  public
    conf : integer;
    padraoSeNaoExistir : string;
    teclas, substitui : TStringList;

    { Public declarations }
  end;

var
  Form39: TForm39;

implementation

uses func, principal, Math, StrUtils;

{$R *.dfm}

procedure TForm39.ListBox1KeyPress(Sender: TObject; var Key: Char);
var
 temp2 : TStringList;
 acc, TMP : string;
 CORES : TColorDialog;
begin
  //conf = 2 então é cconfiguração do terminal
  if conf = 2 then begin
    if key=#27 then close;
    if key=#13 then begin
      if substitui.Strings[ListBox1.itemindex] = 'M' then begin
        //acc := funcoes.dialogo('normal',300,teclas.Strings[ListBox1.itemindex],300,false,substitui.Strings[ListBox1.itemindex],Application.Title,ListBox1.Items.Strings[ListBox1.itemindex], funcoes.LerConfig(padraoSeNaoExistir, ListBox1.ItemIndex));
        acc := funcoes.LerConfig(padraoSeNaoExistir, ListBox1.ItemIndex);
        if ((Contido('.'+IntToStr(ListBox1.itemindex)+ '.', '.10.11.12.')) and (acc <>'*')) then begin
            try
              CORES := TColorDialog.Create(SELF);
              cores.CustomColors.add(acc);

              cores.Execute;
              //if not cores.Execute then acc := '';
              ACC := ColorToString(CORES.Color);
              cores.free;

              TMP := padraoSeNaoExistir;
              padraoSeNaoExistir := GravarConfig(padraoSeNaoExistir, acc, ListBox1.itemindex);
              //ShowMessage('padraoSeNaoExistir=' + padraoSeNaoExistir + #13 +
              //'TMP=' + TMP);
              EXIT;
            except
              MessageDlg('Cor Inválida!', mtError, [mbOK], 1);
              acc := '*';
            end;
        end
        else begin
          acc := funcoes.dialogo('normal',300,teclas.Strings[ListBox1.itemindex],300,false,substitui.Strings[ListBox1.itemindex],Application.Title,ListBox1.Items.Strings[ListBox1.itemindex], funcoes.LerConfig(padraoSeNaoExistir, ListBox1.ItemIndex));
          if acc = '*' then exit;          
        end;
        //     funcoes.dialogo('generico',0,teclas.Strings[ListBox1.itemindex],30,false,'S',Application.Title,ListBox1.Items.Strings[ListBox1.itemindex],funcoes.LerConfig(padraoSeNaoExistir,ListBox1.ItemIndex))

        padraoSeNaoExistir := GravarConfig(padraoSeNaoExistir,acc, ListBox1.itemindex);

      end
      else begin
        acc := funcoes.dialogo('generico',0,teclas.Strings[ListBox1.itemindex],30,false,substitui.Strings[ListBox1.itemindex],Application.Title,ListBox1.Items.Strings[ListBox1.itemindex], funcoes.LerConfig(padraoSeNaoExistir, ListBox1.ItemIndex));
        //     funcoes.dialogo('generico',0,teclas.Strings[ListBox1.itemindex],30,false,'S',Application.Title,ListBox1.Items.Strings[ListBox1.itemindex],funcoes.LerConfig(padraoSeNaoExistir,ListBox1.ItemIndex))
        if acc <>'*' then
          begin
            padraoSeNaoExistir := GravarConfig(padraoSeNaoExistir,acc, ListBox1.itemindex);
          end;
      end;
    end;
  end
  else begin
    if key= #27 then
      begin
        funcoes.lista1 := '*';
        close;
      end;
    if key=#13 then
      begin
        acc := ListBox1.Items[ListBox1.ItemIndex];
        acc := trim(acc);
        funcoes.lista1 := trim(LeftStr(acc,pos('-',acc) -1));
        funcoes.lista1 := trim(funcoes.lista1);

        //funcoes.lista1 := ListBox1.Items.Strings[ListBox1.ItemIndex];
        //funcoes.lista1 := copy(funcoes.lista1,1,pos('-',funcoes.lista1)-1);
        if conf = 1 then funcoes.lista1 := IntToStr(ListBox1.ItemIndex);
        close;
      end;
  end;
end;

procedure TForm39.FormShow(Sender: TObject);
var
  temp : TStringList;
  i : integer;
begin
  if conf=3 then begin
    buscaListaBox(padraoSeNaoExistir);
    exit;
  end;

if conf=2 then
begin
  //self.BorderStyle := bsNone;
  //self.WindowState := wsMaximized;
  if form22.Pgerais.Values['conf_ter']='' then
    begin
      padraoSeNaoExistir := '-0- '+ form22.Pgerais.Values['nota'] + ' -1- 1 -2- 2 -3- -4- -5- -6- -7- -8- -9- -10- -11- -12- -13- -14- -15- -16- -17- -18- -19- -20-';
      form22.Pgerais.Values['conf_ter'] := padraoSeNaoExistir;
    end
  else padraoSeNaoExistir := form22.Pgerais.Values['conf_ter'];
end;

if ((conf <> 1) or (conf <> 2)) then
  begin
    ListBox1.Selected[0] := true;
  end;
end;

procedure TForm39.FormClose(Sender: TObject; var Action: TCloseAction);
var temp2 : tstringlist;
begin
if conf=2 then
 begin
   if padraoSeNaoExistir <> form22.Pgerais.Values['conf_ter'] then
     begin
      If funcoes.dialogo('generico',1,'SN',20,false,'S','','Deseja Salvar (S/N)?','S') = 'S' then
       begin
         funcoes.gravaConfigTerminal(padraoSeNaoExistir);
         form22.Pgerais.Values['conf_ter'] := padraoSeNaoExistir;
       end;
     end;
 end;
end;

procedure TForm39.buscaListaBox(nome: String);
var
  i   : integer;
  cod : string;
begin
  for i := 0 to ListBox1.Count -1 do begin
    cod := ListBox1.Items[i];
    cod := copy(cod, 1, pos('-', cod) -1);
    cod := trim(cod);
    if UpperCase(nome) = UpperCase(cod) then begin
      ListBox1.Selected[i] := true;
      exit;
    end;
  end;
end;

end.
