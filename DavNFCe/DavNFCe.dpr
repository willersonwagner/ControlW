program DavNFCe;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  untNFCe in '..\untNFCe.pas',
  classes1 in '..\classes1.pas',
  func in 'func.pas',
  funcoesDAV in '..\funcoesDAV.pas',
  untnfceForm in '..\untnfceForm.pas' {Form72},
  gifAguarde in '..\gifAguarde.pas' {Form65};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm72, Form72);
  Application.CreateForm(TForm65, Form65);
  Application.Run;
end.
