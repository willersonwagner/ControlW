unit UTraducao;

interface

uses Windows, Consts;

  procedure SetResourceString(AResString: PResStringRec; ANewValue: PChar);

const
  SNewMsgDlgYes: PChar = '&Sim';
  SNewMsgDlgOK: PChar = 'Ok';
  SNewMsgDlgCancel: PChar = 'Cancelar';
  SNewMsgDlgNo: PChar = '&Não';
  SNewMsgDlgWarning = 'Aviso';
  SNewMsgDlgError = 'Erro';
  SNewMsgDlgInformation = 'Informação';
  SNewMsgDlgConfirm = 'Confirme';
  SNewMsgDlgHelp = '&Ajuda';
  SNewMsgDlgHelpNone = 'Não há arquivo de ajuda';
  SNewMsgDlgHelpHelp = 'Ajuda';
  SNewMsgDlgAbort = '&Abortar';
  SNewMsgDlgRetry = '&Repetir';
  SNewMsgDlgIgnore = '&Ignorar';
  SNewMsgDlgAll = '&Todos';
  SNewMsgDlgNoToAll = 'N&ão para Todos';
  SNewMsgDlgYesToAll = 'Sim pata &Todos';

implementation

procedure SetResourceString(AResString: PResStringRec; ANewValue: PChar);
var
  POldProtect: DWORD;
begin
  VirtualProtect(AResString, SizeOf(AResString^), PAGE_EXECUTE_READWRITE, @POldProtect);
  AResString^.Identifier := Integer(ANewValue);
  VirtualProtect(AResString, SizeOf(AResString^), POldProtect, @POldProtect);
end;

initialization

	SetResourceString(@SMsgDlgYes, SNewMsgDlgYes);
	SetResourceString(@SMsgDlgOK, SNewMsgDlgOK);
	SetResourceString(@SMsgDlgCancel, SNewMsgDlgCancel);
	SetResourceString(@SMsgDlgNo, SNewMsgDlgNo);
	SetResourceString(@SMsgDlgWarning, SNewMsgDlgWarning);
	SetResourceString(@SMsgDlgError, SNewMsgDlgError);
	SetResourceString(@SMsgDlgInformation, SNewMsgDlgInformation);
	SetResourceString(@SMsgDlgConfirm, SNewMsgDlgConfirm);
	SetResourceString(@SMsgDlgHelp, SNewMsgDlgHelp);
	SetResourceString(@SMsgDlgHelpNone, SNewMsgDlgHelpNone);
	SetResourceString(@SMsgDlgHelpHelp, SNewMsgDlgHelpHelp);
	SetResourceString(@SMsgDlgAbort, SNewMsgDlgAbort);
	SetResourceString(@SMsgDlgRetry, SNewMsgDlgRetry);
	SetResourceString(@SMsgDlgIgnore, SNewMsgDlgIgnore);
	SetResourceString(@SMsgDlgAll, SNewMsgDlgAll);
	SetResourceString(@SMsgDlgNoToAll, SNewMsgDlgNoToAll);
	SetResourceString(@SMsgDlgYesToAll, SNewMsgDlgYesToAll);

end.
