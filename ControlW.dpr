program ControlW;

uses
  Forms,
  SysUtils,
  Unit2 in 'Unit2.pas' {Form2},
  Unit1 in 'Unit1.pas' {dm: TDataModule},
  CadUsuario in 'CadUsuario.pas' {Form5},
  localizar in 'localizar.pas' {Form7},
  cadfrabricante in 'cadfrabricante.pas' {Form6},
  cadfornecedor in 'cadfornecedor.pas' {Form8},
  cadgrupoprod in 'cadgrupoprod.pas' {Form3},
  cadvendedor in 'cadvendedor.pas' {Form4},
  cadCodOp in 'cadCodOp.pas' {CadCP},
  cadgrupodecaixa in 'cadgrupodecaixa.pas' {Form11},
  cadhiscaixa in 'cadhiscaixa.pas' {Form12},
  cadrota in 'cadrota.pas' {Form13},
  agenda in 'agenda.pas' {Form14},
  cadformpagto in 'cadformpagto.pas' {Form15},
  cadproduto in 'cadproduto.pas' {Form9},
  cadcliente in 'cadcliente.pas' {Form16},
  entrasimples in 'entrasimples.pas' {Form17},
  vendas in 'vendas.pas' {Form20},
  func in 'func.pas' {funcoes},
  prod in 'prod.pas' {Form21},
  dialog in 'dialog.pas' {pergunta1},
  formpagtoformulario in 'formpagtoformulario.pas' {Form18},
  relatorio in 'relatorio.pas' {Form19},
  mensagem in 'mensagem.pas' {Form23},
  principal in 'principal.pas' {form22},
  imprime1 in 'imprime1.pas' {imprime},
  consulta in 'consulta.pas' {Form24},
  subconsulta in 'subconsulta.pas' {Form25},
  tread in 'tread.pas',
  treadproqy in 'treadproqy.pas',
  splash in 'splash.pas' {Form26},
  cpagar in 'cpagar.pas' {Form27},
  minilocalizar in 'minilocalizar.pas' {Form28},
  creceber in 'creceber.pas' {Form29},
  creceberbaixa in 'creceberbaixa.pas' {Form30},
  CpagarBaixa in 'CpagarBaixa.pas' {Form31},
  MovCaixa in 'MovCaixa.pas' {Movcaixalanc},
  movcaixaposicao in 'movcaixaposicao.pas' {Form32},
  buscaSelecao in 'buscaSelecao.pas' {Form33},
  creceberposicao in 'creceberposicao.pas' {Form34},
  registro in 'registro.pas' {Form35},
  bloqusu in 'bloqusu.pas' {Form36},
  acesso in 'acesso.pas' {Form37},
  Unit38 in 'Unit38.pas' {Form38},
  caixaLista in 'caixaLista.pas' {Form39},
  param1 in 'param1.pas' {Form40},
  posiUsu in 'posiUsu.pas' {Form41},
  Unit42 in 'Unit42.pas' {Form42},
  nfe in 'nfe.pas' {NfeVenda},
  aliq in 'aliq.pas' {aliq1},
  Dialogs,
  cadTransp in 'cadTransp.pas' {Form10},
  dadosTransp in 'dadosTransp.pas' {Form43},
  backup in 'backup.pas' {Form44},
  dm1 in 'dm1.pas' {dmSmall: TDataModule},
  funcoesDAV in 'funcoesDAV.pas',
  Unit45 in 'Unit45.pas' {dadosAdicSped},
  sped in 'sped.pas',
  Unit46 in 'Unit46.pas' {Form46},
  spedFiscal in 'spedFiscal.pas',
  unid in 'unid.pas' {Form47},
  Unit48 in 'Unit48.pas' {Form48},
  Unit49 in 'Unit49.pas' {Form49},
  impriNovo in 'impriNovo.pas' {Form50},
  imprNovo in 'imprNovo.pas',
  CadServ in 'CadServ.pas' {Form51},
  configImpressora in 'configImpressora.pas' {Form52},
  login in 'login.pas' {Form53},
  batepapo in 'batepapo.pas' {Form54},
  charprinter in 'charprinter.pas',
  consultaOrdem in 'consultaOrdem.pas' {Form55},
  classes1 in 'classes1.pas',
  untConfiguracoesNFCe in 'PDV NFCe\projeto\untConfiguracoesNFCe.pas' {frmConfiguracoesNFe},
  untNFCe in 'untNFCe.pas',
  untMovto in 'untMovto.pas' {frmConhecimentoFrete},
  cadECF in 'cadECF.pas' {cadECF1},
  cadReducaoZ in 'cadReducaoZ.pas' {cadReducao},
  acerto1 in 'acerto1.pas' {acerto},
  Unit56 in 'Unit56.pas' {Form56},
  Unit57 in 'Unit57.pas' {Form57},
  envicupom in 'envicupom.pas' {Form58},
  Unit59 in 'Unit59.pas' {lancContasPagar},
  cadCli in 'cadCli.pas' {cadCliNFCe},
  cadCli1 in 'cadCli1.pas' {CadClienteSimplificado},
  Unit60 in 'Unit60.pas' {Form60},
  cadCestNCM in 'cadCestNCM.pas' {Form61},
  PROMOC in 'PROMOC.pas' {promocao},
  Unit62 in 'Unit62.pas' {Form62},
  UDownloadXMLNFeDLL in 'UDownloadXMLNFeDLL.pas',
  Unit63 in 'Unit63.pas' {Form63},
  UTDownloadXMLNFeDLL in 'UTDownloadXMLNFeDLL.pas',
  U_Carregando in 'U_Carregando.pas' {F_Carregando},
  Vcl.Themes,
  Vcl.Styles,
  cadNotasFiscais in 'cadNotasFiscais.pas' {CadNotasFiscais1},
  UTraducao in 'UTraducao.pas',
  gifAguarde in 'gifAguarde.pas' {Form65},
  Unit66 in 'Unit66.pas' {TT},
  U_Principal in 'U_Principal.pas' {F_Principal},
  ConsultaCPF in 'ConsultaCPF.pas' {ConsultaCPF1},
  Unit67 in 'Unit67.pas' {Form67},
  Unit68 in 'Unit68.pas' {Form68},
  Unit69 in 'Unit69.pas' {Form69},
  email in 'email.pas' {Form70},
  Unit71 in 'Unit71.pas' {Form71},
  untnfceForm in 'untnfceForm.pas' {Form72},
  uConsultaCNPJ in 'uConsultaCNPJ.pas' {consultaCNPJ},
  Unit73 in 'Unit73.pas' {Form73},
  Unit74 in 'Unit74.pas' {Form74},
  Unit75 in 'Unit75.pas' {Form75};

{$R *.res}

begin
  Application.Initialize;

  form26:=tform26.Create(Application);
  form26.Show;
  form26.Label1.Caption := 'Carregando Formulário...';
  form26.Update;

  Application.CreateForm(Tform22, form22);
  Application.CreateForm(Tfuncoes, funcoes);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TForm70, Form70);
  Application.CreateForm(TForm72, Form72);
  Application.CreateForm(TForm73, Form73);
  Application.CreateForm(TForm74, Form74);
  Application.CreateForm(TForm75, Form75);
  //Application.CreateForm(TconsultaCNPJ, consultaCNPJ);
  //Application.CreateForm(TForm71, Form71);
  //Application.CreateForm(TForm69, Form69);
  //Application.CreateForm(TForm68, Form68);
  if ParamCount = 2 then
     begin
      dm.bd.DatabaseName := ParamStr(1) + ':' + ParamStr(2);
      CaminhoBD := ParamStr(1) + ':' + ParamStr(2);
     end
   else if ParamCount = 1 then
     begin
         dm.bd.DatabaseName := ParamStr(1) ;
         CaminhoBD := ParamStr(1);
     end
   else
     begin
       dm.bd.DatabaseName := copy(ParamStr(0),1,funcoes.PosFinal('\',ParamStr(0))-1)+'\bd.fdb' ;
       CaminhoBD := copy(ParamStr(0),1,funcoes.PosFinal('\',ParamStr(0))-1)+'\bd.fdb' ;
     end;

   try
     dm.bd.Connected := true;
   except
     ShowMessage('Não foi Possivel a Conexão com o Banco de Dados.' + #10 + #13 + 'Verifique:' + #10 + #13 + #10 + #13 + '1. Se o Banco de Dados existe na pasta do EXECUTÁVEL; ' + #10 + #13 + #10 + #13 + '2. Verifique se o Servidor Firebird está instalado adquadamente neste computador.' + #10 + #13 + #10 + #13 + '3.Se este Computador estiver sendo configurado em rede, verifique se o caminho do banco de dados foi posto corretamente, altere a Propriedade do Atalho no campo DESTINO para "c:\controlw\controlw.exe' + '<NOME_DO_SERVIDOR> <PASTA_NO_SERVIDOR_QUE_CONTEM_O_BD>" Exemplo: "c:\controlw\controlw.exe \\Servidor c:\controlw\bd.fdb'  + #10 + #13 + #10 + #13 + '4. Se o problema persistir entre em contato com o SUPORTE.' );
     funcoes.adicionarExcecao;
     Application.Terminate;
     exit;
   end;

  try
    funcoes.geraPgerais(); //gera Configurações de Parametros Gerais
    funcoes.LeNomesServicos(); //ler os nomes para ordem de servico
  except
  end;

  Application.Title := 'Control Estoque for Windows';
  form26.ProgressBar1.Position:=14;

  Application.CreateForm(TF_Carregando, F_Carregando);
  Application.CreateForm(TForm62, Form62);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm63, Form63);

  Application.CreateForm(TForm24, Form24);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm19, Form19);

  Application.CreateForm(TForm56, Form56);

  form26.ProgressBar1.Position:=28;

  application.CreateForm(TForm19, Form19);
  funcoes.CtrlResize(tform(form19));

  Application.CreateForm(TForm23, Form23);
  funcoes.CtrlResize(tform(form23));

  form26.ProgressBar1.Position := 42;

  form26.ProgressBar1.Position:=56;
  Application.CreateForm(Tpergunta1, pergunta1);
  funcoes.CtrlResize(tform(pergunta1));

  form26.ProgressBar1.Position := 70;
  Application.CreateForm(Timprime, imprime);

  form26.ProgressBar1.Position := 84;
  Application.CreateForm(TForm2, Form2);
  funcoes.CtrlResize(tform(form2));

  form26.ProgressBar1.Position := 98;
  form26.Label1.Caption:='Carregando BD...';
  Form26.Update;
  CRLF := #13 + #10;

  Form26.Update;
  form26.Close;

   Try
     funcoes.VerificaVersao_do_bd; //atualizaBD
   except
     on e : exception do
       begin
         gravaErrosNoArquivo(e.Message, 'Project1', '152', 'funcoes.VerificaVersao_do_bd;');
       end;
   end;

{   if ConfParamGerais[5] = 'S' then //usar recursos de Auto Peças
    begin                          // Gera CDS temporários de equivalências
      funcoes.Timer1.Enabled := true;
    end;}

   try
    if ParamCount > 0 then
      begin
        if funcoes.le_configTerminalWindows(6, 'S') = 'S' then
          begin
            funcoes.fazBackupDoBD(true);
          end;
      end;
     //copia bd do servidor
   except
   end;

   
   Application.CreateForm(TForm26, Form26);

   {treadVerificaPag := TTWThreadVerificaPagamento.Create(true);
   treadVerificaPag.FreeOnTerminate := true;
   treadVerificaPag.Resume;}

   Application.Run;
end.
