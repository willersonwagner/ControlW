unit P4InfoVarejo_Constantes;

interface

resourcestring
  mensagem_01 = 'Não existem registros com este critério.';
  mensagem_02 = 'Impressão do cheque não foi possível. '+chr(10)+chr(13)+
                'Código do movimento bancário está vazio.';
  mensagem_03 = 'Impressão do cheque não foi possível. '+chr(10)+chr(13)+
                 'Nenhum registro foi encontrado com o código do movimento bancário.';
  mensagem_04 = 'Impressão do cheque não foi possível. '+chr(10)+chr(13)+
                 'Impressão do cheque não está configurado para este banco.';
  mensagem_05 = 'Não existem contatos para esta transportadora.';
  mensagem_06 = 'Não existem contatos para este representante.';
  mensagem_07 = 'Impressão não foi possível.'+chr(10)+chr(13)+
                 'Duplicata inexistente no banco de dados';
  mensagem_08 = 'Não existem clientes atendidos para esta transportadora.';
  mensagem_09 = 'Não existem clientes para este representante.';
  mensagem_10 = 'Não existe produção com o critério especificado.';
  mensagem_11 = 'Produto inexistente!';

const
  P4InfoVarejo_moeda   = '###,###,##0.00';
  P4InfoVarejo_decimal4= '###,###,##0.0000';
  P4InfoVarejo_decimal3= '###,###,##0.000';
  P4InfoVarejo_decimal2= '###,###,##0.00';
  P4InfoVarejo_decimal1= '###,###,##0.0';
  P4InfoVarejo_integer = '###,###,##0';
  P4InfoVarejo_dtbanco = 'mm/dd/yyyy';
  P4InfoVarejo_hrbanco = 'hh:mm:ss';
  P4InfoVarejo_dtabrev = 'dd/mm/yyyy';
  P4InfoVarejo_Sintegra = '###,###,##0000';
  P4InfoVarejo_KeySearch = 121;
  P4InfoVarejo_keymove   = 117;
  P4InfoVarejo_KeyExibeInformacao = 123;
  ad_control_mora_diaria = 6.00;

 //Cript   = '~%()*áº¹¼_ñª¬½¡Ü«»-./:;<=>?{|}ïöü~"¿#¢£¥Ñ@%>§!Ç$+ƒñäåç`&ëïÄæØ';
 Cript   = 'ABCDEFGHIJKLMNOPQRSTUVXYWZabcdefghijklmnopqrstuvxywz1234567890';
 Decript = '0123456789abcdefghijklmnopqrstuvxywzABCDEFGHIJKLMNOPQRSTUVXYWZ';


implementation

end.











