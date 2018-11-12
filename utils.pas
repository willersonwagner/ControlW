unit utils;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, OleCtrls, SHDocVw, stdActns,
  ShellAPI, ShlObj;

  function PastaProcurar(const Title: string; const Flag: integer): string;
  procedure MsgErr(Error: String);
  Function LocalDoExe: String;
  procedure PastaCriar(Nome: String);
  Function StrNumeros(Str: String): String;
  procedure MsgInf(Messagem: String);
  function PathSystem: String;

implementation

function PathSystem: String;
var
  strTmp: array[0..MAX_PATH] of char;
  DirWindows: String;
const
  SYS_64 = 'SysWOW64';
  SYS_32 = 'System32';
begin
  Result := '';

  if Windows.GetWindowsDirectory(strTmp, MAX_PATH) > 0 then
  begin
    DirWindows := Trim(StrPas(strTmp));
    DirWindows := IncludeTrailingPathDelimiter(DirWindows);

    if DirectoryExists(DirWindows + SYS_64) then
      Result := DirWindows + SYS_64
    else
    if DirectoryExists(DirWindows + SYS_32) then
      Result := DirWindows + SYS_32
    else
      raise Exception.Create('Diretório de sistema não encontrado.');
  end
  else
    raise Exception.Create('Ocorreu um erro ao tentar obter o diretório do windows.');
end;

procedure MsgInf(Messagem: String);
begin
  Application.MessageBox(PChar(Messagem),PChar(Application.Title),
  Mb_IconInformation);
end;

Function StrPermanece(Str,Permanece: String): String;
var i, v: Integer; S: String;
begin
  for I := 1 to Length(Str) do
    for v := 1 to Length(Permanece) do
      if Str[i] = Permanece[v] then
        S:= S+Str[i];
  Result:= S;
end;

Function StrNumeros(Str: String): String;
begin
  Result:= StrPermanece(Str, '0123456789');
end;

procedure PastaCriar(Nome: String);
begin
  if not DirectoryExists(Nome) then
    ForceDirectories(Nome)
end;

Function LocalDoExe: String;
begin
  Result:= ExtractFilePath(ParamStr(0));
end;

procedure MsgErr(Error: String);
begin
  Application.MessageBox(PChar(Error),PChar(Application.Title),
  Mb_IconError);
end;

function BrowseDialogCallBack
  (Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): 
  integer stdcall;
var
  wa, rect : TRect;
  dialogPT : TPoint;
begin
  //center in work area
  if uMsg = BFFM_INITIALIZED then
  begin
    wa := Screen.WorkAreaRect;
    GetWindowRect(Wnd, Rect);
    dialogPT.X := ((wa.Right-wa.Left) div 2) - 
                  ((rect.Right-rect.Left) div 2);
    dialogPT.Y := ((wa.Bottom-wa.Top) div 2) - 
                  ((rect.Bottom-rect.Top) div 2);
    MoveWindow(Wnd,
               dialogPT.X,
               dialogPT.Y,
               Rect.Right - Rect.Left,
               Rect.Bottom - Rect.Top,
               True);
  end;

  Result := 0;
end; (*BrowseDialogCallBack*)

function PastaProcurar(const Title: string; const Flag: integer): string;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  Result:='';
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  with BrowseInfo do begin
    hwndOwner := Application.Handle;
    pszDisplayName := @DisplayName;
    lpszTitle := PChar(Title);
    ulFlags := Flag;
    lpfn := BrowseDialogCallBack;
  end;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result := TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;

end.
