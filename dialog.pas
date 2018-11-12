unit dialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JsEdit1, mask, JsEditNumero1, JsEditData1, ExtCtrls,
  ComCtrls, Gauges;

type
  Tpergunta1 = class(TForm)
    Timer1: TTimer;
    //Gauge1: TGauge;
    Label1: TLabel;
    Gauge1: TGauge;
    //sSkinManager1: TsSkinManager;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MeuKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MeuKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure MeuKeyPressGen2(Sender: TObject; var Key: Char);
    procedure MeuKeyPressSN(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    botao : tButton;
    { Private declarations }
  public
    valorTecla:string;
    valorPadrao:string;
    valorLabel:string;
    valoredit:string;
    tempo:boolean;
    tipo:string;
    obrigatorio:boolean;
    jsedit1: TEdit;
    jsnumero1: JsEditNumero;
    jsdata : TMaskEdit;
    botoes:string;
    tamanhoEdit,decimais,maxlengt, option : integer;
    memo1 : TMemo;
    procedure DefineEdit;
    function RetornaValorEdit : string;
    procedure freecomponentes;
    procedure setButton(botao1 : TButton);


  end;

var
  pergunta1: Tpergunta1;



  implementation

uses func, StrUtils, Unit1;

{$R *.dfm}

procedure Tpergunta1.setButton(botao1 : TButton);
begin
  botao := botao1;
end;

function Tpergunta1.RetornaValorEdit : string;
begin
  try
    if jsedit1.Text<>'' then result := jsedit1.Text
    else if jsnumero1.Text<>'' then result := jsnumero1.Text
    else if jsdata<>nil then result := jsdata.Text;
  finally

  end;
end;

procedure Tpergunta1.DefineEdit;
begin
  if tipo='normal' then
  begin
    jsedit1:=TEdit.Create(self);
    with jsedit1 do
      begin
       OnKeyDown:=MeuKeyUp;
       if botoes='S' then OnKeyPress := MeuKeyPressSN
         else OnKeyPress := MeuKeyPressGen2;

       if botoes = 'X' then CharCase := ecUpperCase;

       if tamanhoEdit < 100 then Width  := 400
         else Width := tamanhoEdit;

       Parent:=self;
       Text:=valorPadrao;
       CharCase:=ecUpperCase;
       Enabled:=true;
       top:=Label1.Top-4;
       left:=Label1.Left+Label1.Width+10;
       pergunta1.Width:=Label1.Left+Label1.Width+20+jsedit1.Width+20;
       pergunta1.Height:=Label1.Top+label1.Height+ 50;
       SetFocus;
       SelectAll;
       if not obrigatorio then if MaxLengt <> 0 then MaxLength := maxlengt;
      end;
  end;

  if tipo = 'not' then
  begin
    jsedit1 := TEdit.Create(self);
    with jsedit1 do
      begin
       OnKeyDown := MeuKeyUp;
       if botoes='S' then OnKeyPress := MeuKeyPressSN
         else OnKeyPress := MeuKeyPress;
       Parent := self;
       Text := valorPadrao;
       Enabled := true;
       CharCase := ecUpperCase;
       top := Label1.Top-4;
       left := Label1.Left+Label1.Width+10;

       if tamanhoEdit > 0 then jsedit1.Width := tamanhoEdit;
       pergunta1.Width := Label1.Left+Label1.Width+20+jsedit1.Width+20;
       pergunta1.Height := Label1.Top+label1.Height+ 50;
       SetFocus;

       if not obrigatorio then
         begin
           if MaxLengt <> 0 then MaxLength := maxlengt
         end
       else CharCase := ecUpperCase;
      SelectAll;
      end;
  end;

  if tipo = 'noteditavel' then
  begin
    jsedit1 := TEdit.Create(self);
    with jsedit1 do
      begin
       OnKeyDown := MeuKeyUp;
       if botoes='S' then OnKeyPress := MeuKeyPressSN
         else OnKeyPress := MeuKeyPress;
       Parent := self;
       Text := valorPadrao;
       Enabled := true;
       top := Label1.Top-4;
       left := Label1.Left+Label1.Width+10;
       pergunta1.Width := Label1.Left+Label1.Width+20+jsedit1.Width+20;
       pergunta1.Height := Label1.Top+label1.Height+ 50;
       SetFocus;
       if not obrigatorio then
         begin
           if MaxLengt <> 0 then MaxLength := maxlengt
         end
       else CharCase := ecUpperCase;
      SelectAll;
      end;
  end;


  if tipo='generico' then
  begin
    jsedit1:=TEdit.Create(self);
    with jsedit1 do
      begin
       if botoes = 'S' then OnKeyPress := MeuKeyPressSN
         else OnKeyPress := MeuKeyPress;
       OnKeyDown := MeuKeyUp;
       CharCase := ecUpperCase;
       Parent:=self;
       Enabled:=true;
       if tamanhoEdit=0 then Width:=25
         else Width:=tamanhoEdit;
       top:=Label1.Top-4;
       left:=Label1.Left+Label1.Width+10;
       pergunta1.Width:=Label1.Left+Label1.Width+20+jsedit1.Width+20;
       SetFocus;
       Text:=valorPadrao;
       SelectAll;
      end;
  end;

  if tipo='data' then
  begin
    jsdata := TMaskEdit.Create(self);
    with jsdata do
      begin
       OnKeyPress := MeuKeyPressGen2;
       Parent:=self;
       Enabled:=true;
       EditMask := '!90/90/00;1;_';
       SetFocus;
       top:=Label1.Top-4;
       left:=Label1.Left+Label1.Width+10;
       Width := 80;
       pergunta1.Width:=Label1.Left+Label1.Width+jsdata.Width + 20;

       Text:=valorPadrao;
      end;
  end;

  if tipo='mask' then
  begin
    jsdata := TMaskEdit.Create(self);
    with jsdata do
      begin
       OnKeyPress := MeuKeyPressGen2;
       Parent:=self;
       Enabled:=true;
       EditMask := valorTecla;
       SetFocus;
       top:=Label1.Top-4;
       left:=Label1.Left+Label1.Width+10;
       pergunta1.Width:=Label1.Left+Label1.Width+jsdata.Width-25;
       Width := tamanhoEdit;
       pergunta1.Width := Label1.Left+Label1.Width+20+jsdata.Width+20;
       Text:=valorPadrao;
      end;
  end;

  if tipo='numero' then
  begin
    jsnumero1 := JsEditNumero.Create(self);
    jsnumero1.func := false;
    with jsnumero1 do
      begin
       EscreveNumero(tamanhoEdit);
       Text := GeraCompleto(tamanhoEdit); //
      // decimal := tamanhoEdit;
       func := false;
       OnKeyPress := MeuKeyPressGen2;
       OnKeyDown := MeuKeyUp;
       Parent:=self;
       //MaxLength:=8;
       Enabled:=true;
       top:=Label1.Top-4;
       left:=Label1.Left+Label1.Width+10;
       pergunta1.Width:=Label1.Left+Label1.Width+20+jsnumero1.Width+20;
       SetFocus;
       Text:=valorPadrao;
       SelectAll;
       ColorOnEnter := clWhite;
       Update;
      end;
  end;

  end;

procedure Tpergunta1.MeuKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
  if tipo = 'not' then
    begin
      if (key = 13)  then
        begin
          if (tedit(sender).Text = '') then
            begin
              key := 0;
              exit;
            end;
        end;
    end
   else if tipo = 'generico' then
     begin
       if obrigatorio then
         begin
           if key = 13 then
             begin
               if (tedit(sender).Text = '') then
                 begin
                   key := 0;
                   exit;
                 end;
             end;
         end;
     end;

  if key = 13 then
    begin
      key := 0;
      close;
    end;
    if key = 27 then
      begin
        freecomponentes;
        funcoes.valordg := '*' ;
        close;
      end;
end;

procedure Tpergunta1.MeuKeyPressGen2(Sender: TObject; var Key: Char);
begin

 if self.tipo = 'numero'  then
    begin
      if obrigatorio then
        begin
          if (key = #13) then
            begin
              if (StrToCurr(funcoes.ConverteNumerico(tedit(sender).Text)) = 0 ) then key := #0
               else begin

                 close;
               end;
            end;
        end
      else
        begin
          if (key = #13) then close;
        end;
      if key=#27 then
             begin
               freecomponentes;
               funcoes.valordg := '*';
               close;
             end;
    end
  else if tipo = 'data' then
    begin
      if obrigatorio then
        begin
          if key = #13 then
            begin
              if (StrToFloat(funcoes.ContaChar(tedit(sender).Text,'_')) > 0) and (key = #13)  then key := #0;
              if key=#13 then close;
            end;
         if key=#27 then
           begin
             freecomponentes;
             funcoes.valordg:='*';
             close;
           end;
        end
      else
        begin
          if key = #13 then
            begin
              if length(strnum(tedit(sender).Text)) <> 6 then
                begin
                  key := #0;
                  close;
                end;

              if key=#13 then close;
            end;
         if key=#27 then
           begin
             freecomponentes;
             funcoes.valordg:='*';
             close;
           end;
        end;
    end
  else if tipo = 'numero' then
    begin
      IF obrigatorio then
        begin
          if (key = #13) and (StrToCurr(funcoes.ConverteNumerico(tedit(sender).Text)) = 0) then key := #0 ;
        end;
    end
  else if tipo = 'normal' then
    begin
      IF obrigatorio then
        begin
          if (key = #13) and (Length(tedit(sender).Text) >= maxlengt) then key := #0 ;
        end;
    end
  else if tipo = 'generico' then
    begin
      IF obrigatorio then
        begin
          if (key = #13) and (tedit(sender).Text = '') then
            begin
              key := #0 ;
              exit;
            end;
        end;
    end
  else
    begin
      if key=#27 then
        begin
          freecomponentes;
          funcoes.valordg:='*';
          close;
        end;
      if key=#13 then close;
    end;

 { else
    begin
      if not(obrigatorio) then
        begin
         if key=#27 then
           begin
             freecomponentes;
             funcoes.valordg:='*';
             close;
           end;
         if key=#13 then close;
        end
      else if (key=#13) and (tedit(sender as sender.ClassType).Text<>'') then close;
    end;  }
end;

procedure Tpergunta1.MeuKeyPressSN(Sender: TObject; var Key: Char);
begin
  KEY := UpCase(KEY);
  IF (NOT funcoes.Contido(KEY,valorTecla)) and ((key <> #27) or (key <> #32) or (key <> #13)) then key:=#0
    else (sender as TEdit).Text := '';

 if self.tipo = 'generico' then
    begin
      IF obrigatorio then
        begin
          if (key = #13) then
            begin
              if tedit(sender).Text = '' then key := #0 ;
              exit;
            end;
        end;
    end;


end;

procedure Tpergunta1.MeuKeyPress(Sender: TObject; var Key: Char);
begin
  if tipo = 'noteditavel' then
    begin
      if key = #27 then
        begin
          freecomponentes;
          funcoes.valordg:='*';
          close;
        end;
      if key <> #13 then key := #0;
      exit;
    end;

  if self.tipo = 'not' then
    begin
      IF obrigatorio then
        begin
          if (key = #13) then
            begin
              if (tedit(sender).Text = '') then  key := #0
                else begin
                  funcoes.valordg := tedit(sender).Text;
                  close;
                end;
            end;

          if (valorTecla <> '') and (key<> #27) then
            begin
              IF NOT(funcoes.Contido(KEY,valorTecla)) then key:=#0;
            end;
        end
      else
        begin
          if key = #13 then begin
            funcoes.valordg := tedit(sender).Text;
            close;
          end;
        end;
      if key = #27 then
            begin
              freecomponentes;
              funcoes.valordg:='*';
              close;
            end;
    end
  else
   begin
     if (valorTecla <> '') and (key<> #27) then
       begin
         IF NOT(funcoes.Contido(KEY,valorTecla)) then key:=#0;
       end;
     if key = #13 then begin
      funcoes.valordg := tedit(sender).Text;
      close;
     end;
     if key = #27 then
       begin
         freecomponentes;
         funcoes.valordg:='*';
         close;
       end;
   end;

end;

procedure Tpergunta1.FormShow(Sender: TObject);
var botao : TButton;
begin
  JsEdit.SetTabelaDoBd(self, 'teste', dm.ibquery1);
  FUNCOES.valordg := '';

  if option = 1 then
    begin
      Label1.Caption := valorLabel;
      DefineEdit;
    end
  else
    begin
      cont := 0;
    end;
  //option 3 = sem gauge
  //option = 4 sem gauge com botao ok
  {if (option = 3)
    begin
      Gauge1.Enabled := false;
      Gauge1.Visible := false;
      funcoes.CentralizaNoFormulario(twincontrol(Label1),tform(self));
      self.Update;
    end;
  if option = 4 then
    begin
      botao := TButton.Create(self);
      botao.Parent := self;
      botao.Caption := 'Ok';
      botao.OnClick := Button1Click;
      botao.Width := 60;
      botao.Height := 30;
      funcoes.CentralizaNoFormulario(twincontrol(botao),tform(self));
      botao.Top := self.Height - botao.Height -50;
    end;    }

//    if botao <> nil then botao.OnClick := sButton1Click;
end;

procedure Tpergunta1.freecomponentes;
begin

if jsedit1.Text<>'' then jsedit1.Text:=''
  else if jsnumero1.Text <> '' then
   begin
    //jsedit.LiberaMemoria(self);
   end
  else if jsdata<>nil then jsdata.Text:='';
botoes:='';
end;

procedure Tpergunta1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := caFree;
  try
    JsEdit.LiberaMemoria(self);
  finally

  end;
  if option = 1 then
    begin
      botoes := '';
      if not (funcoes.valordg = '*') then begin
        funcoes.valordg := RetornaValorEdit;
      end;
      TRY
        botao := nil;
      FINALLY

      END;

    end
  else if option = 2 then
    begin
      //(memo1.Text);
      //exit;
    end
  else
    begin
      if tipo = 'texto' then
        begin
          funcoes.valordg := memo1.Lines.GetText;
          TRY
            memo1.Free;
          FINALLY

          END;
        end;
    end;
end;

procedure Tpergunta1.Button2Click(Sender: TObject);
begin
 freecomponentes;
 close;
end;

procedure Tpergunta1.Button1Click(Sender: TObject);
begin
  close;
end;

procedure Tpergunta1.Timer1Timer(Sender: TObject);
begin
   if Gauge1.Progress = 100 then Gauge1.Progress := 0;
   Gauge1.Progress := Gauge1.Progress + 3;
   Gauge1.Update;
end;

procedure Tpergunta1.sButton1Click(Sender: TObject);
begin
  close;
end;

procedure Tpergunta1.FormKeyPress(Sender: TObject; var Key: Char);
var
 x, y : string;
begin
  {if key = 'j' then
    begin
      x := InputBox('','','');
      self.ScaleBy(StrToInt(x), 100);
    end;}
end;

procedure Tpergunta1.FormCreate(Sender: TObject);
begin
  funcoes.AjustaForm(self);
end;

end.
     
